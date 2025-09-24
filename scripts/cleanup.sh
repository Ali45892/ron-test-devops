#!/bin/bash
set -e

echo "🧹 Cleaning up resources..."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}This will destroy all Terraform-managed resources.${NC}"
echo -e "${RED}This action cannot be undone!${NC}"
echo -e "${YELLOW}Are you sure? (yes/no)${NC}"
read -r response

if [[ "$response" == "yes" ]]; then
    cd terraform/environments/prod
    terraform destroy -auto-approve
    cd ../../..
    echo -e "${GREEN}✅ Resources cleaned up successfully!${NC}"
else
    echo -e "${YELLOW}Cleanup cancelled.${NC}"
fi
