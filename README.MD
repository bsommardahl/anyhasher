

## Key Pairs for EC2

1. Create key pair in AWS. [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html](docs)
2. Get the public key. [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/describe-keys.html](docs)
3. Add both in repo config so they can be used in CI/CD. 
```
SSH_PRIVATE_KEY
SSH_PUBLIC_KEY
```