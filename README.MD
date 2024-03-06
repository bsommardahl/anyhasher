

## Key Pairs for EC2/Ansible

1. Create key pair in AWS. [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html](docs)
2. Copy the private SSH key.
2. Add your private SSH key in repo config so they can be used in CI/CD (e.g. Ansible). 
```
EC2_PRIVATE_KEY
```
(This variable name is used in the CI/CD job that utilizes Ansible.)