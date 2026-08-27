# Module: security (Phase 6)

Lab security baseline for Project 2.

## What it creates

| Resource | Purpose |
|----------|---------|
| **KMS CMK** | Encrypts CloudTrail / Config objects in the log bucket (key rotation on) |
| **S3 log bucket** | Private, versioned, lifecycle (30-day expire); receives CloudTrail + Config |
| **CloudTrail** | Multi-region management-event trail with log-file validation |
| **AWS Config** | Recorder + delivery channel + 3 managed rules (S3 public read, SSL-only, encrypted EBS) |
| **GuardDuty** | Detector (optional via `enable_guardduty`) |
| **IAM role** | `SecurityAudit` read-only role (assume from account root **with MFA**) |

## Cost notes (lab)

- Keep `enable_security = false` until you want screenshots, then enable, verify, destroy.
- CloudTrail management events: first copy is free; storage is S3.
- Config charges per recorded item + rule evaluation — rules are limited to three.
- GuardDuty is usually cheap on idle accounts; disable/destroy when done.
- **Free / new accounts:** GuardDuty often cannot be enabled (`SubscriptionRequiredException`). Keep `enable_guardduty = false` — CloudTrail, Config, and KMS still demonstrate the security baseline.
- KMS: ~$1/month per customer-managed key while it exists.

## Usage

From root `terraform/`:

```hcl
enable_security     = true
enable_config_rules = true
enable_guardduty    = true   # set false if SubscriptionRequiredException
```

```bash
terraform plan
terraform apply
terraform output
```

Console checks: CloudTrail → Trails, Config → Rules, GuardDuty → Findings, KMS → Customer managed keys.
