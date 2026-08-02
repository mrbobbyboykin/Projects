# Project 4 — Terraform (CodePipeline + CodeBuild)

## 1) Create local tfvars

```bat
cd project-4-cicd\terraform
copy terraform.tfvars.example terraform.tfvars
```

Confirm `site_bucket_name` and `cloudfront_distribution_id` still match Project 3:

```bat
terraform -chdir=..\..\project-3-static-site\terraform output -raw site_bucket_name
terraform -chdir=..\..\project-3-static-site\terraform output -raw cloudfront_distribution_id
```

## 2) Apply

```bat
terraform init
terraform plan
terraform apply
```

## 3) Complete the GitHub connection (required once)

After apply, the CodeStar connection is usually **PENDING**.

1. AWS Console → **Developer Tools** → **Connections** (or CodePipeline → Settings → Connections)
2. Open the connection named like `portfolio-lab-lab-p4-github`
3. Choose **Update pending connection** / complete the GitHub OAuth
4. Status must become **Available**

Until then, pipeline runs will fail at the Source stage.

## 4) Test

1. Make a tiny change under `project-3-static-site/site/`
2. Commit and push to `main`
3. AWS Console → **CodePipeline** → `portfolio-lab-lab-p4-site-deploy`
4. Confirm Source → Deploy succeeds
5. Hard-refresh https://d2ma7ywng4dw2d.cloudfront.net

You can also start a release manually from the pipeline console.

## Tear down

```bat
terraform destroy
```

This removes the pipeline only — Project 3 site resources stay until you destroy that stack separately.
