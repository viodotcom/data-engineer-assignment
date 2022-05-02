.DEFAULT_GOAL := run

# Wait for LocalSrack to be up and running
wait-for-localstack:
	@echo "Waiting for LocalStack to be up and running"
	@until curl -s http://localstack:4566/health | jq '[.services[] == "available"] | all'; do \
    	echo "LocalStack not yet available..."; \
    	sleep 20; \
	done
	@echo "Localstack available!"

# Deploy Terraform resources
run-terraform:
	@echo "Deploying Terraform resources"
	@cd deployment && terraform init && terraform apply -auto-approve

# Check AWS resouces
check-resources:
	@echo "Checking AWS buckets"
	@aws --endpoint-url=http://localstack:4566 s3api list-buckets

keep-docker-running:
	@echo "Keeping docker up and running"
	@tail -f /dev/null

# TODO: Add all the necessary steps to complete the assignment
run: wait-for-localstack run-terraform check-resources keep-docker-running
