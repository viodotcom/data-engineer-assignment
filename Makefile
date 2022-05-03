.DEFAULT_GOAL := run

# Wait for LocalSrack to be up and running
wait-for-localstack:
	@echo "Waiting for LocalStack to be up and running"
	@until curl -s http://localstack:4566/health | jq '[.services[] == "available"] | all'; do \
    	echo "LocalStack not yet available..."; \
    	sleep 20; \
	done
	@echo "Localstack available!"

# Zip Lambda functions
zip-lambdas:
	@echo "Zipping Lambda functions code"
	@./zip-lambdas.sh

# Deploy Terraform resources
run-terraform: zip-lambdas
	@echo "Deploying Terraform resources"
	@cd deployment && terraform init && terraform apply -auto-approve

# Check AWS resouces
check-resources:
	@echo "Checking AWS buckets"
	@aws --endpoint-url=http://localstack:4566 s3api list-buckets
	@aws --endpoint-url=http://localstack:4566 lambda list-functions

# Trigger test lambda every minute
test-lambda:
	@echo "Starting loop to triggering test Lambda every minute"
	@while true; do \
		echo "Triggering test Lambda"; \
		aws --endpoint-url=http://localstack:4566 lambda invoke --function-name test response.json; \
		sleep 60; \
	done

# TODO: Add all the necessary steps to complete the assignment
run: wait-for-localstack run-terraform check-resources test-lambda
