# How to configure saml2aws for logining the aws
## Login aws by IDP directly
### What
### How to
* configure saml2aws
    * install saml2aws by brew ```brew intall saml2aws```
    * install awscli by brew ```brew install awscli```
    * relate saml2aws to Zsh, add the following cmd at the end of **.zshrc**, ```eval "$(saml2aws --completion-script-zsh)"``` and source **.zshrc**
* create IDP (IAM identity provider)
  * in iam console
    * create SAML metadata document
    * go to iam console in aws search bar
    * click identity providers -> Add provider -> choose Provider type is **SAML** 
## login aws by MFA
### MFA algorithm & tool
* okta
* 