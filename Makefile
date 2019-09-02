# Makefile to kickoff terraform.
# ####################################################
#


## Before we start test that we have the mandatory executables available
	EXECUTABLES = git terraform
	K := $(foreach exec,$(EXECUTABLES),\
		$(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, consider apt-get install $(exec)")))

.PHONY: build

first-run:
	@echo "initialize remote state file"
	cd layer && \
	terraform init

init:
	@echo "initialize remote state file"
	cd layer && \
	terraform init

validate: init
	@echo "running terraform validate"
	cd layer && \
	terraform validate -no-color

plan: validate
	@echo "running terraform plan"
	cd layer && \
	terraform plan -no-color

apply: plan
	@echo "running terraform apply"
	cd layer && \
	terraform apply -auto-approve -no-color

plan-destroy: validate
	@echo "running terraform plan -destroy"
	cd layer && \
	terraform plan -destroy -no-color

destroy: init
	@echo "running terraform destroy"
	cd layer && \
	terraform destroy -force -no-color