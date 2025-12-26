#!/bin/bash

# Quick cost check script
# Run this weekly to monitor AWS spending

echo "💰 Checking AWS costs for current month..."

aws ce get-cost-and-usage \
  --time-period Start=$(date -u +%Y-%m-01),End=$(date -u +%Y-%m-%d) \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --query 'ResultsByTime[0].Total.BlendedCost.Amount' \
  --output text

echo ""
echo "Run 'aws ce get-cost-and-usage' with different parameters for detailed breakdown"
