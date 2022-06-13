# How to create EC2 instance in local

* [create key-pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)
    ```
    aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
    ```

* [create launch template](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-launch-template.html)
  ```
  aws ec2 create-launch-template \
    --launch-template-name TemplateForWebServer \
    --version-description WebVersion1 \
    --tag-specifications 'ResourceType=launch-template,Tags=[{Key=purpose,Value=production}]' \
    --launch-template-data file://template-configuration.json
  ```
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
        "VpcId": "vpc-04ac233447a6a3241",
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

* [create security-group](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-security-group.html)
    ```
    aws ec2 create-security-group \
    --description "ec2 security group" \
    --group-name zqf-sg-instances \
    --vpc-id vpc-04ac233447a6a3241
    ```
    * success creating
     ```json
        {
            "GroupId": "sg-0e4bd81d89d2b8c7e"
        }
     ```

* [Launch an instance from a launch template](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-launch-template.html)
    ```
    aws ec2 run-instances \
        --launch-template LaunchTemplateId=lt-04544f790a78979b0,Version=1
    ```