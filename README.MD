
## AWS Login Credentials

1. Create an IAM user with CLI access.
2. Copy the key id and the key to your Github repo's [settings/secrets/actions](secrets) using the variable names below.
```
AWS_ACCESS_KEY_ID      
AWS_SECRET_ACCESS_KEY    
```

## Key Pairs for EC2/Ansible

1. Create key pair in AWS. [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html](docs)
2. Save pem file to a safe place.
3. Open pen file and copy the private SSH key.
4. Add your private SSH key in repo config so they can be used in CI/CD (e.g. Ansible). 
```
EC2_PRIVATE_KEY
```
(This variable name is used in the CI/CD job that utilizes Ansible.)