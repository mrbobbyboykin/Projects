# Terraform quick reference

Run all commands from this directory (`project-2-aws-infrastructure/terraform/`).

```bash
terraform init
terraform plan
terraform apply
terraform output
terraform destroy
```

Format and validate before commit:

```bash
terraform fmt -recursive
terraform validate
```

Copy example vars:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Module implementation order:

1. `modules/vpc` — done  
2. `modules/alb` + `modules/asg` — done  
3. `modules/rds` — done (Single-AZ default)  
4. `modules/s3` + `modules/cloudwatch` — done  
5. Remote state — `bootstrap/` + `backend.hcl.example`  
6. `modules/security` — CloudTrail, Config, GuardDuty, KMS (`enable_security`)

## Phase 6 — Security baseline

```hcl
enable_security     = true
enable_config_rules = true
```

```bash
terraform plan
terraform apply
terraform output cloudtrail_name
terraform output guardduty_detector_id
```

Verify in Console (CloudTrail, Config rules, GuardDuty, KMS), then set `enable_security = false` and apply (or destroy) so Config/KMS do not keep charging. See [`modules/security/README.md`](modules/security/README.md).
