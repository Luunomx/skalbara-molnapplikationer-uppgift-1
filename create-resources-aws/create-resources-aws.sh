#!/bin/bash
set -euo pipefail

STACK_NAME="luunom-wordpress"
REGION="eu-west-1"
TEMPLATE_FILE="cloudformation-wordpress.yaml"
KEY_NAME="alb-ec2-key"
ALLOWED_SSH="0.0.0.0/0"

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
      ParameterKey=AllowedSSH,ParameterValue="$ALLOWED_SSH"

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
      ParameterKey=AllowedSSH,ParameterValue="$ALLOWED_SSH"

  aws cloudformation wait stack-create-complete \
    --stack-name "$STACK_NAME" \
    --region "$REGION"
fi

echo "✅ Stack $STACK_NAME deployed successfully!"
aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --query "Stacks[0].Outputs"
