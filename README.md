# AWS terraform-lab

- Create `secrets.tfvars` file that contains: 
```
access_key = "<AWS access key>"
secret_key = "<AWS secret key>"
```
- Upload or generate new ssh Key in AWS Console. Update `valiables.tf#52` with new key name.
- Make sure you are in folder with `tf` and `tfvars` files.
- You can run `terraform version` to ensure you have terraform installed and
version is `0.12.*`.
- Run `terraform init` to install AWS provider
- Update `variables.tf` and `secrets.tfvars` if need
- Run `terraform validate` to validate terraform files
- Run `terraform plan -var-file=./secrets.tfvars` and review list of changes terraform will require to meet desired state. You might be asked for AWS credentials and DB password, if `secrets.tfvars` file missed.
- Run `terraform apply -var-file=./secrets.tfvars` to apply changes, confirm changes with `yes`. You might be asked for AWS credentials and DB password, if `secrets.tfvars` file missed.
- To delete all created resources in AWS run `terraform destroy -var-file=./secrets.tfvars`, review changes you going to apply, then confirm with `yes`.

