#!/bin/bash

# Navigate to the terraform directory
cd architectureTerraform

# Apply Terraform changes to create the infrastructure
terraform init
terraform apply -auto-approve

# Retrieve the output values using Terraform output command
security_group_id=$(terraform output -raw INSTANCE_SG_ID)
subnet_id=$(terraform output -raw PUBLIC_SUBNET_ID)

# Navigate back to the main folder
cd ..

# ansibe ko lagi

cd ansible

# ansible-playbook ansible.yaml -i aws_ec2.yaml --private-key=/Users/binayapuri/downloads/binaya.pem

ansible-playbook ansible.yaml -i aws_ec2.yaml --private-key=/Users/binayapuri/downloads/binaya.pem






# Pass the output values as environment variables to SAM deploy command
cd ..


cd apipython

sam build

sam package --template-file template.yaml --output-template-file packaged.yaml --s3-bucket binay-node


sam deploy --template-file packaged.yaml \
           --stack-name bp-node-test-yes \
           --parameter-overrides SecurityGroupId=$security_group_id \
                                SubnetId=$subnet_id \

           --capabilities CAPABILITY_IAM
           --y

# Retrieve the API Gateway URL
api_gateway_url=$(aws cloudformation describe-stacks --stack-name bp-node-test-yes --query "Stacks[0].Outputs[?OutputKey=='ApiGatewayUrl'].OutputValue" --output text)

# echo $(api_gateway_url)

cd ..

# replace with api

echo ${api_gateway_url}

cd client

# sed -i '' "s|'{{API_URL}}'|'${api_gateway_url}'|g" files/index.html

sed -i '' "s|{{API_URL}}|${api_gateway_url}|g" files/index.html

cd terraform_s3

terraform init




terraform apply -auto-approve





