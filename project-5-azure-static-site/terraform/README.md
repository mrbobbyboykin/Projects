# Project 5 — Terraform (Azure)

## Prerequisites

1. **Azure subscription** (free trial / pay-as-you-go) with a budget alert
2. **Azure CLI** — [install](https://learn.microsoft.com/cli/azure/install-azure-cli), then:

```bat
az login
az account show
```

3. **Terraform** `>= 1.5`

Terraform authenticates to Azure using your Azure CLI session (same idea as AWS credentials for Projects 2–4).

## Deploy

```bat
cd project-5-azure-static-site\terraform
copy terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

`apply` will:

1. Create a resource group, Storage static website, and upload site files  
2. Create a Consumption Function App + Table Storage  
3. Zip-deploy the Function via `az functionapp deployment ...` (needs Azure CLI)

Open:

```bat
terraform output website_url
```

Click **Count this visit** — the browser calls the Function URL from `config.js`.

## Quota error on new subscriptions

If `terraform apply` fails on **App Service Plan** with:

```text
Operation cannot be completed without additional quota
Current Limit (Total VMs): 0
Amount required: 1
```

Your subscription has **no compute VM quota** yet (common on brand-new free accounts). The Function App Consumption plan still counts against that quota.

### Option A — Request quota (full demo)

1. [Azure Portal](https://portal.azure.com) → **Subscriptions** → **Azure Subscription 1**
2. **Usage + quotas** → filter by region (`eastus`) or search **App Service**
3. Find **Total Regional vCPUs** or **App Service plan** quota → **Request increase** → set **New limit: 1** (or higher)
4. Approval is often same-day for small increases on free/trial subs
5. In `terraform.tfvars`, ensure `enable_visitor_api = true`, then `terraform apply` again

### Option B — Static site only (works immediately)

In `terraform.tfvars`:

```hcl
enable_visitor_api = false
```

Then:

```bat
terraform apply
```

You get the static portfolio site; the counter button will not work until you enable the API and re-apply.

If partial resources were created before the failure, Terraform will reconcile on the next apply (no manual cleanup needed unless you prefer a clean slate).

## Tear down

```bat
terraform destroy
```

## Optional stretch

Add Azure Front Door / CDN in front of the storage origin for a closer CloudFront parallel (see `docs/ARCHITECTURE.md`).
