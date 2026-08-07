INVENTORY := inventory/hosts.yaml
PLAYBOOK := server/playbook_new_proxmox_node.yaml

# Override on the command line, e.g.: make run TARGET=proxmox7
TARGET ?= proxmox

.PHONY: check list-tasks list-tags lint run

check: ## Syntax-check the new Proxmox node playbook
	uv run ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --syntax-check

list-tasks: ## List tasks in the new Proxmox node playbook
	uv run ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --list-tasks

list-tags: ## List tags in the new Proxmox node playbook
	uv run ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --list-tags

lint: ## Lint the proxmox_node role and playbook
	uv run ansible-lint server/roles/proxmox_node/ $(PLAYBOOK)

run: ## Run the new Proxmox node playbook (TARGET=proxmox7)
	uv run ansible-playbook -i $(INVENTORY) $(PLAYBOOK) -e target_node=$(TARGET)

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
