.PHONY= help setup init plan apply apply2 destroy destroy-force destroy-target refresh clean validate all bootstrap-all
.ONESHELL:
SHELL := /bin/bash
BIN_DIR=~/bin
BOOTSTRAP_TFVARS=vars/bootstrap.tfvars
KMS_KEY ?=$(shell cat bootstrap/kms_key.out)
OS ?=linux
PACKER_VERSION ?=1.4.4
PACKER_BIN=packer
PLAN_FILE=plan-$(WS).out
PROJECT_NAME ?=$(shell cat bootstrap/project_name.out)
TERRAFORM_VERSION ?=0.12.8
TERRAFORM_BIN=terraform
TERRAFORM_BUCKET ?=$(shell cat bootstrap/terraform_bucket_name.out)
WS_TFVARS=vars/ws-$(WS).tfvars
ZONE ?= europe-west2-a

help:
	@echo "help ..."

set-env:
	@if [ -z $(WS) ]; then \
		echo "WS was not set"; \
		ERROR=1; \
	else \
		echo "WS: $(WS)"; \
	fi

	@if [ ! -f "$(WS_TFVARS)" ]; then \
		echo "Could not find workspace variables file: $(WS_TFVARS)" ;\
		ERROR=1; \
	fi

	@if [ -z $(TERRAFORM_BUCKET) ]; then \
		echo "TERRAFORM_BUCKET was not set" ;\
		ERROR=1; \
	else \
		echo "TERRAFORM_BUCKET: $(TERRAFORM_BUCKET)" ;\
	fi

	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		exit 1; \
	fi

setup:
	@echo "setup ..."
	@if [ ! -d $(BIN_DIR) ]; then \
		echo "Creating bin folder: $(BIN_DIR)" ;\
		mkdir $(BIN_DIR) ;\
	 fi

	@if [ ! -f $(BIN_DIR)/$(TERRAFORM_BIN) ]; then \
		curl -sLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_$(OS)_amd64.zip && \
		unzip -d /tmp /tmp/terraform.zip && \
		mv /tmp/terraform $(BIN_DIR) && \
		rm /tmp/terraform.zip; \
	fi
	-$(TERRAFORM_BIN) version


	@if [ ! -f $(BIN_DIR)/$(PACKER_BIN) ]; then \
		curl -sLo /tmp/packer.zip https://releases.hashicorp.com/packer/$(PACKER_VERSION)/packer_$(PACKER_VERSION)_$(OS)_amd64.zip && \
		unzip -d /tmp /tmp/packer.zip && \
		mv /tmp/packer $(BIN_DIR) && \
		rm /tmp/packer.zip; \
	fi
	-$(PACKER_BIN) version

bootstrap-all: bootstrap-init bootstrap-plan bootstrap-apply

bootstrap-init:
	@echo "Initialising bootstrap terraform backend"
	@cd bootstrap && \
	$(TERRAFORM_BIN) init \
		-input=false \
		-var-file="$(BOOTSTRAP_TFVARS)"

bootstrap-validate:
	@echo "Validating bootstrap terraform backend"
	@cd bootstrap && \
	$(TERRAFORM_BIN) validate \
		-var-file="$(BOOTSTRAP_TFVARS)"

bootstrap-plan: bootstrap-init
	@echo "Planning bootstrap terraform ..."
	@cd bootstrap && \
	$(TERRAFORM_BIN) plan \
		-input=false \
		-refresh=true \
		-var-file="$(BOOTSTRAP_TFVARS)" \
		-var kms_key="${KMS_KEY}" \
		-out=bootstrap.out

bootstrap-apply:
	@echo "Applying bootstrap terraform ..."
	@cd bootstrap && \
	$(TERRAFORM_BIN) apply \
		-input=false \
		bootstrap.out && \
	rm bootstrap.out && \
	$(TERRAFORM_BIN) output terraform_bucket_name > terraform_bucket_name.out && \
	$(TERRAFORM_BIN) output kms_key > kms_key.out && \
	$(TERRAFORM_BIN) output project_name > project_name.out

bootstrap-output:
	@echo "$@ ..."
	@cd bootstrap  && \
	$(TERRAFORM_BIN) output

bootstrap-destroy:
	@echo "Destroying bootstrap terraform ..."
	@cd bootstrap  && \
	$(TERRAFORM_BIN) destroy \
		-input=false \
		-var-file="$(BOOTSTRAP_TFVARS)" && \
	rm *.out

bootstrap-clean:
	@echo "Cleaning bootstrap terraform ..."
	@cd bootstrap && \
	rm -rf .terraform/ ;\
	rm -rf terraform.tfstate* ;\
	rm *.out ;\
	echo cleaning complete

all: init plan apply

init: set-env
	@echo "Initialising terraform backend"
	@$(TERRAFORM_BIN) init \
		-backend=true \
		-backend-config="bucket=$(TERRAFORM_BUCKET)" \
		-backend-config="prefix=$(PROJECT_NAME)/terraform.tfstate \
		-var-file="$(WS_TFVARS)"
	@echo "Switching to workspace $(WS)"
	@$(TERRAFORM_BIN) workspace select $(WS) || $(TERRAFORM_BIN) workspace new $(WS)

prep:
	@echo "Switching to workspace $(WS)"
	@$(TERRAFORM_BIN) workspace select $(WS) || $(TERRAFORM_BIN) workspace new $(WS)

refresh: set-env prep
	@echo "$@ ..."
	@$(TERRAFORM_BIN) refresh \
		-input=false \
		-var-file="$(WS_TFVARS)"

update-modules:
	@echo "$@ ..."
	@$(TERRAFORM_BIN) get \
		--update=true

validate: set-env prep
	@echo "$@ ..."
	@$(TERRAFORM_BIN) validate \
		-var-file="$(WS_TFVARS)"

plan: set-env prep
	@echo "$@ ..."
	@$(TERRAFORM_BIN) plan \
		-input=false \
		-refresh=true \
		-var-file="$(WS_TFVARS)" \
		-out=$(PLAN_FILE)

apply: set-env prep
	@echo "$@ ..."
	@$(TERRAFORM_BIN) apply \
		-input=false \
		$(PLAN_FILE)
	@rm $(PLAN_FILE)

apply2: set-env prep
	@echo "$@ ..."
	@$(TERRAFORM_BIN) apply \
		-input=false \
		-refresh=true \
		-var-file="$(WS_TFVARS)" \

destroy: set-env prep
	@echo "destroy ..."
	@export TF_WARN_OUTPUT_ERRORS=1
	@$(TERRAFORM_BIN) destroy \
		-input=false \
		-refresh=true \
		-var-file="$(WS_TFVARS)" \
		-var kms_key=="$(KMS_KEY)"

destroy-force: set-env prep
	@echo "destroy ..."
	@export TF_WARN_OUTPUT_ERRORS=1
	@$(TERRAFORM_BIN) destroy \
		-input=false \
		-auto-approve \
		-refresh=true \
		-var-file="$(WS_TFVARS)" \
		-var kms_key=="$(KMS_KEY)"

destroy-target: set-env prep
	@echo "$@ ..."
	@export TF_WARN_OUTPUT_ERRORS=1
	@$(TERRAFORM_BIN) destroy \
		-input=false \
		-refresh=true \
		-var-file="$(WS_TFVARS)" \
		-target $(RESOURCE)

taint: set-env prep
	@echo "$@ ..."
	@$(TERRAFORM_BIN) taint \
		$(RESOURCE)

output: prep
	@echo "$@ ..."
	@$(TERRAFORM_BIN) output

clean:
	@echo "cleaning ..."
	-$(TERRAFORM_BIN) workspace select default
	-$(TERRAFORM_BIN) workspace delete $(WS)
	-rm -rf .terraform/
	-rm -rf terraform.tfstate*
	-rm *.out
	-echo cleaning complete
