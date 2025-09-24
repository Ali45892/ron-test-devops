#!/bin/bash
set -e

echo "🚀 Starting deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_ID="ron-test-2025"
REGION="us-central1"

echo -e "${YELLOW}Step 1: Validating Terraform configuration...${NC}"
cd terraform/environments/prod
terraform validate

echo -e "${YELLOW}Step 2: Planning infrastructure changes...${NC}"
terraform plan

echo -e "${YELLOW}Step 3: Would you like to apply these changes? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${GREEN}Applying Terraform changes...${NC}"
    terraform apply -auto-approve
else
    echo -e "${RED}Deployment cancelled.${NC}"
    exit 1
fi

cd ../../..

echo -e "${YELLOW}Step 4: Building Docker image...${NC}"
docker build -t health-webapp:latest .

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
