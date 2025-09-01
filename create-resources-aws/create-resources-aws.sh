#!/bin/bash
set -euo pipefail

STACK_NAME="luunom-wordpress"
REGION="eu-west-1"
TEMPLATE_FILE="cloudformation-wordpress.yaml"
KEY_NAME="new-ec2-key"
ALLOWED_SSH="0.0.0.0/0"

# Nya WP-parametrar
ADMIN_USER="admin"
ADMIN_PASSWORD="Omega181"
ADMIN_EMAIL="hugohemlin@hotmail.com"
SITE_TITLE="Luunoms site"

echo "🚀 Creating stack $STACK_NAME ..."

if aws cloudformation describe-stacks --region "$REGION" --stack-name "$STACK_NAME" >/dev/null 2>&1; then
  echo "🔄 Stack exists, updating..."
  aws cloudformation update-stack \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --template-body file://"$TEMPLATE_FILE" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
      ParameterKey=KeyName,ParameterValue="$KEY_NAME" \
      ParameterKey=AllowedSSH,ParameterValue="$ALLOWED_SSH" \
      ParameterKey=AdminUser,ParameterValue="$ADMIN_USER" \
      ParameterKey=AdminPassword,ParameterValue="$ADMIN_PASSWORD" \
      ParameterKey=AdminEmail,ParameterValue="$ADMIN_EMAIL" \
      ParameterKey=SiteTitle,ParameterValue="$SITE_TITLE"

  aws cloudformation wait stack-update-complete \
    --stack-name "$STACK_NAME" \
    --region "$REGION"
else
  echo "🆕 Stack does not exist, creating..."
  aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --template-body file://"$TEMPLATE_FILE" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
      ParameterKey=KeyName,ParameterValue="$KEY_NAME" \
      ParameterKey=AllowedSSH,ParameterValue="$ALLOWED_SSH" \
      ParameterKey=AdminUser,ParameterValue="$ADMIN_USER" \
      ParameterKey=AdminPassword,ParameterValue="$ADMIN_PASSWORD" \
      ParameterKey=AdminEmail,ParameterValue="$ADMIN_EMAIL" \
      ParameterKey=SiteTitle,ParameterValue="$SITE_TITLE"

  aws cloudformation wait stack-create-complete \
    --stack-name "$STACK_NAME" \
    --region "$REGION"
fi

echo "✅ Stack $STACK_NAME deployed successfully!"
aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --query "Stacks[0].Outputs"
