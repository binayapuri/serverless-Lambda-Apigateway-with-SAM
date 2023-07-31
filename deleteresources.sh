# !/bin/bash



cd apipython

sam delete

cd ..

cd architectureTerraform

terraform destroy -auto-approve


cd ..

cd client

cd terraform_s3

terraform destroy -auto-approve

