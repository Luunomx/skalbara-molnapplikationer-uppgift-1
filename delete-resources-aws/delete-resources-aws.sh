#!/bin/bash
set -euo pipefail

STACK_NAME="wordpress-stack"
REGION="eu-west-1"

echo "⚠️  Detta kommer ta bort hela stacken: $STACK_NAME i region $REGION"
read -p "Är du säker? (yes/no): " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
  echo "❌ Avbrutet"
  exit 1
fi

echo "🗑️  Tar bort stack $STACK_NAME ..."
aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION

echo "⏳ Väntar på att stacken ska tas bort ..."
aws cloudformation wait stack-delete-complete \
  --stack-name $STACK_NAME \
  --region $REGION

echo "✅ Stack $STACK_NAME borttagen!"
