# Bootstrap for Terraform remote state
#
# Creates (with **local** state):
# - S3 bucket (versioned + encrypted) for `terraform.tfstate`
# - DynamoDB table for state locking
#
# Cost: nearly free when idle (empty bucket + on-demand DynamoDB).
# Keep this stack — do not destroy it while the main project uses remote state.
