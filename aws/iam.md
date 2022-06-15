* note for IAM
  * permission can be assigned to a user directly or inherited from user group
  * MFA (multi Factor authentication)
    * add a authenticator for aws account
* iam permission yaml
  * Version is for the configuration version
  * Id is for the configuration id
  * Statement is for the permision details Statement
    ```json
    {
        "Version": "2012-10-17",
        "Id": "create it as you like",
        "Statement" [
            {
                "Sid": "first section",
                "Effect": "Allow or Deny",
                "Principal": {
                "ASW": ["arn:aws:iam::<accountId>:user/alias"]
                },
                "Action": [
                    "s3:GetObject",
                    "s3:PutObject",
                ],
                "Resource": "*"
            }
        ]
    }
    ```
* access to AWS in different ways
  * Aws CLI command line tool
  * AWS SDK in different programming languages
  * both ways are needed to obtain user's AccessID and AccessKey for aws console, **don't share this with others very important**
  * run ```aws configure``` to setup your aws cli, then run ```aws iam list-users``` to verify everything is set up correctly.