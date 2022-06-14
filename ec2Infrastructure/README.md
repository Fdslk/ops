# How to create EC2 instance in local

* [create VPC](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-vpc.html)
  ```
  aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specification 'ResourceType=vpc,Tags=[{Key=Name,Value=MyVpc}]'
  ```
  * create success
  ```json
  {
    "Vpc": {
        "CidrBlock": "10.0.0.0/16",
        "DhcpOptionsId": "dopt-0acc367abec4237f3",
        "State": "pending",
        "VpcId": "",
        "OwnerId": "160071257600",
        "InstanceTenancy": "default",
        "Ipv6CidrBlockAssociationSet": [],
        "CidrBlockAssociationSet": [
            {
                "AssociationId": "vpc-cidr-assoc-0289205971c8ead31",
                "CidrBlock": "10.0.0.0/16",
                "CidrBlockState": {
                    "State": "associated"
                }
            }
        ],
        "IsDefault": false,
        "Tags": [
            {
                "Key": "Name",
                "Value": "MyVpc"
            }
        ]
    }
  }
  ```

* create subnets
    ```
    aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24
    ```
    * successfully create
       ```json
       {
            "Subnet": {
                "AvailabilityZone": "ap-southeast-2a",
                "AvailabilityZoneId": "apse2-az3",
                "AvailableIpAddressCount": 251,
                "CidrBlock": "10.0.1.0/24",
                "DefaultForAz": false,
                "MapPublicIpOnLaunch": false,
                "State": "available",
                "SubnetId": "",
                "VpcId": "",
                "OwnerId": "160071257600",
                "AssignIpv6AddressOnCreation": false,
                "Ipv6CidrBlockAssociationSet": [],
                "SubnetArn": "arn:aws:ec2:ap-southeast-2:160071257600:subnet/subnet-060baf73d83fa57a9"
            }
        }
       ```

* create internet gateway
  ```
  aws ec2 create-internet-gateway
  ```
  successfully creating
  ```json
    {
        "InternetGateway": {
            "Attachments": [],
            "InternetGatewayId": "",
            "OwnerId": "160071257600",
            "Tags": []
        }
    }
  ```
* after internet-gateway creating, attaching internet-gateway to vpc
  ```
  aws ec2 attach-internet-gateway --vpc-id <vpc-id> --internet-gateway-id <igw-id>
  ```

* create route table
  ```
    aws ec2 create-route-table --vpc-id <vpc-id>
  ```

  * successfully creating
  ```json
    {
        "RouteTable": {
            "Associations": [],
            "PropagatingVgws": [],
            "RouteTableId": "",
            "Routes": [
                {
                    "DestinationCidrBlock": "10.0.0.0/16",
                    "GatewayId": "local",
                    "Origin": "CreateRouteTable",
                    "State": "active"
                }
            ],
            "Tags": [],
            "VpcId": "",
            "OwnerId": ""
        }
    }
  ```

* create route
  ```
  aws ec2 create-route --route-table-id <rtb-id> \
              --destination-cidr-block 0.0.0.0/0 --gateway-id <igw-id>
  ```

  * successfully creating
    ```json
    {
        "Return": true
    }
    ```
* Associating Route Table and modifying subnet
  * associate with route table
  ```
  aws ec2 associate-route-table --subnet-id <subnet-id> --route-table-id <rtb-id>

  successfully associated
    {
        "AssociationId": "rtbassoc-0d0dfe5f119fa3e9c",
        "AssociationState": {
            "State": "associated"
        }
    }
  ```
  * map public IP for ec2
  ```
  aws ec2 modify-subnet-attribute --subnet-id <subnet-id> --map-public-ip-on-launch
  ```

* [create key-pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)
    ```
    aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
    ```
    
* [create security-group](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-security-group.html)
    ```
    aws ec2 create-security-group \
    --description "ec2 security group" \
    --group-name zqf-sg-instances \
    --vpc-id <vpc-id>
    ```
    * success creating
     ```json
        {
            "GroupId": "sg-0e4bd81d89d2b8c7e"
        }
     ```
* use TCP/22 to security group
  ```
  aws ec2 authorize-security-group-ingress --group-id <sg-id> --protocol tcp --port 22 --cidr 0.0.0.0/0
  ```

* [create launch template](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-launch-template.html)
  ```
  aws ec2 create-launch-template \
    --launch-template-name TemplateForWebServer \
    --version-description WebVersion1 \
    --tag-specifications 'ResourceType=launch-template,Tags=[{Key=purpose,Value=production}]' \
    --launch-template-data file://template-configuration.json
  ```

* [Launch an instance from a launch template](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-launch-template.html)
    ```
    aws ec2 run-instances \
        --launch-template LaunchTemplateId=lt-04544f790a78979b0,Version=1 \
        --security-group-ids <sg-id> \
        --key-name MyKeyPair \
        --subnet-id <subnet-id>
    ```

    * create instance successfully
    ```json
        {
        "Groups": [],
        "Instances": [
            {
                "AmiLaunchIndex": 0,
                "ImageId": "ami-0c6120f461d6b39e9",
                "InstanceId": "",
                "InstanceType": "m1.small",
                "KeyName": "MyKeyPair",
                "LaunchTime": "2022-06-14T04:56:08+00:00",
                "Monitoring": {
                    "State": "disabled"
                },
                "Placement": {
                    "AvailabilityZone": "",
                    "GroupName": "",
                    "Tenancy": "default"
                },
                "PrivateDnsName": "",
                "PrivateIpAddress": "",
                "ProductCodes": [],
                "PublicDnsName": "",
                "State": {
                    "Code": 0,
                    "Name": "pending"
                },
                "StateTransitionReason": "",
                "SubnetId": "",
                "VpcId": "",
                "Architecture": "x86_64",
                "BlockDeviceMappings": [],
                "ClientToken": "",
                "EbsOptimized": false,
                "EnaSupport": true,
                "Hypervisor": "xen",
                "NetworkInterfaces": [
                    {
                        "Attachment": {
                            "AttachTime": "2022-06-14T04:56:08+00:00",
                            "AttachmentId": "eni-attach-0f4ea33ae62f29e1a",
                            "DeleteOnTermination": true,
                            "DeviceIndex": 0,
                            "Status": "attaching",
                            "NetworkCardIndex": 0
                        },
                        "Description": "",
                        "Groups": [
                            {
                                "GroupName": "zqf-sg-instances",
                                "GroupId": ""
                            }
                        ],
                        "Ipv6Addresses": [],
                        "MacAddress": "06:80:c0:b5:58:ec",
                        "NetworkInterfaceId": "eni-04096ceb2fc3b6bcb",
                        "OwnerId": "",
                        "PrivateIpAddress": "",
                        "PrivateIpAddresses": [
                            {
                                "Primary": true,
                                "PrivateIpAddress": ""
                            }
                        ],
                        "SourceDestCheck": true,
                        "Status": "in-use",
                        "SubnetId": "",
                        "VpcId": "",
                        "InterfaceType": "interface"
                    }
                ],
                "RootDeviceName": "/dev/xvda",
                "RootDeviceType": "ebs",
                "SecurityGroups": [
                    {
                        "GroupName": "zqf-sg-instances",
                        "GroupId": ""
                    }
                ],
                "SourceDestCheck": true,
                "StateReason": {
                    "Code": "pending",
                    "Message": "pending"
                },
                "Tags": [
                    {
                        "Key": "aws:ec2launchtemplate:id",
                        "Value": "lt-04544f790a78979b0"
                    },
                    {
                        "Key": "aws:ec2launchtemplate:version",
                        "Value": "1"
                    }
                ],
                "VirtualizationType": "hvm",
                "CpuOptions": {
                    "CoreCount": 1,
                    "ThreadsPerCore": 1
                },
                "CapacityReservationSpecification": {
                    "CapacityReservationPreference": "open"
                },
                "MetadataOptions": {
                    "State": "pending",
                    "HttpTokens": "optional",
                    "HttpPutResponseHopLimit": 1,
                    "HttpEndpoint": "enabled"
                },
                "EnclaveOptions": {
                    "Enabled": false
                }
            }
        ],
        "OwnerId": "",
        "ReservationId": "r-0dae75944e028dd98"
    }
    ```

    * ![screenshot](https://user-images.githubusercontent.com/6279298/173497140-f145d4f5-9e4a-41ff-b777-556d4e6b7cb0.png)
