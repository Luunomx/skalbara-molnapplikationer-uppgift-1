#!/bin/bash
set -euo pipefail

STACK_NAME="luunom-wordpress"
REGION="eu-west-1"

echo "🗑️  Tar bort stack $STACK_NAME i region $REGION ..."
aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION

echo "⏳ Väntar på att stacken ska tas bort ..."
aws cloudformation wait stack-delete-complete \
  --stack-name $STACK_NAME \
  --region $REGION

echo "✅ Stack $STACK_NAME borttagen!"
