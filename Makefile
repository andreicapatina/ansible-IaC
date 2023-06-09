PLAYBOOK_DIR = ./playbooks
VAULT_GEN_PASS_FILE = ./env/$(ENVIRONMENT)/vault_pass.sh
VAULT_VARS_FILE = ./env/$(ENVIRONMENT)/vault_secrets.yml
VARS_FILE = ./env/$(ENVIRONMENT)/$(ANSIBLE_LIMIT_HOST).yml

validate:
ifeq ($(ANSIBLE_LIMIT_HOST),)
	@echo "Empty arguments"
	@exit 1
else ifeq ($(ENVIRONMENT),)
	@echo "Empty arguments"
	@exit 1
endif

# -------------------------------- Configuration python env ---------------------------------------------------------- #
configure:
	python3 -m venv python_virtual_env; \
	. python_virtual_env/bin/activate; \
	python3 -m pip install --upgrade pip; \
	pip install -r requirements.txt; \
	ansible-galaxy collection install community.postgresql; \
	ansible-galaxy collection install community.mongodb;

# -------------------------------- Launching Postgresql playbooks ---------------------------------------------------- #
deploy_postgresql: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_postgresql.yml 

install_postgresql: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_postgresql.yml --tags "install"

configure_postgresql: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_postgresql.yml --tags "configure"

# -------------------------------- Launching Mongodb playbooks ------------------------------------------------------- #
deploy_mongodb: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_mongodb.yml 

install_mongodb: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_mongodb.yml --tags "install"

configure_mongodb: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_mongodb.yml --tags "configure"

# -------------------------------- Launching Elasticsearch playbooks -------------------------------------------------- #
deploy_elasticsearch: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_elasticsearch.yml --tags "install, $(ES_VERSION), configure"

install_elasticsearch: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_elasticsearch.yml --tags "install, $(ES_VERSION)" 

configure_elasticsearch: validate
	ansible-playbook -i env/$(ENVIRONMENT)/hosts --limit $(ANSIBLE_LIMIT_HOST) --extra-vars="@$(VARS_FILE)" --extra-vars="@$(VAULT_VARS_FILE)" --vault-password-file="$(VAULT_GEN_PASS_FILE)" $(PLAYBOOK_DIR)/deploy_elasticsearch.yml --tags "configure, $(ES_VERSION)"

