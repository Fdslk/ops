# how to use secret in k8s

* k8s default secret
  * encryption method

| name | Description | Strength | Key Length |
| :--- |    :----:   |     ---: |       ---: |
|identity default| None | test | test |
|secretbox| XSalsa20 and Poly1305| Strong | 32 byte
|aesgcm|
|aescbc|
|kms |