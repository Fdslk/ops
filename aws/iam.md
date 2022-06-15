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