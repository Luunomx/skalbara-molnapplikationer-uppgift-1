#!/bin/bash
set -euo pipefail

STACK_NAME="wordpress-stack"
REGION="eu-west-1"
TEMPLATE_FILE="cloudformation-wordpress.yaml"

KEY_NAME="alb-ec2-key"
ALLOWED_SSH="0.0.0.0/0"   # byt gärna till din IP

function stack_exists() {
  aws cloudformation describe-stacks \
    --region "$REGION" \
    --stack-name "$STACK_NAME" >/dev/null 2>&1
}

function create_or_update_stack() {
  if stack_exists; then
    echo "🔄 Updating stack ${STACK_NAME} ..."
    aws cloudformation update-stack \
      --stack-name ${STACK_NAME} \
      --region ${REGION} \
      --template-body file://${TEMPLATE_FILE} \
      --capabilities CAPABILITY_NAMED_IAM \
      --parameters \
        ParameterKey=KeyName,ParameterValue=${KEY_NAME} \
        ParameterKey=AllowedSSH,ParameterValue=${ALLOWED_SSH} || true

    echo "⏳ Waiting for update ..."
    aws cloudformation wait stack-update-complete --stack-name ${STACK_NAME} --region ${REGION}
    echo "✅ Update complete!"
  else
    echo "🚀 Creating stack ${STACK_NAME} ..."
    aws cloudformation create-stack \
      --stack-name ${STACK_NAME} \
      --region ${REGION} \
      --template-body file://${TEMPLATE_FILE} \
      --capabilities CAPABILITY_NAMED_IAM \
      --parameters \
        ParameterKey=KeyName,ParameterValue=${KEY_NAME} \
        ParameterKey=AllowedSSH,ParameterValue=${ALLOWED_SSH}

    echo "⏳ Waiting for create ..."
    aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME} --region ${REGION}
    echo "✅ Stack created!"
  fi
}

create_or_update_stack

echo "📋 Stack Outputs:"
aws cloudformation describe-stacks \
  --stack-name ${STACK_NAME} \
  --region ${REGION} \
  --query "Stacks[0].Outputs" \
  --output table
