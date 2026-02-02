MAKEFLAGS += --no-print-directory

# Load environment variables for local reference
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Colors
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

TARGET_DIR=~/Odoo-Visual-Emotion

.PHONY: help ssh up rest logs status

help:
	@echo "$(YELLOW)Usage: make [target]$(RESET)"
	@echo "  $(GREEN)ssh$(RESET)     Connect to VPS"
	@echo "  $(GREEN)up$(RESET)      Start containers (Remote)"
	@echo "  $(GREEN)rest$(RESET)    Restart containers (Remote)"
	@echo "  $(GREEN)logs$(RESET)    View Odoo logs (Remote)"
	@echo "  $(GREEN)status$(RESET)  Check container status (Remote)"

ssh:
	@echo "$(GREEN)Connecting to $(DOMAIN)...$(RESET)"
	@ssh $(USER)@$(IP)

up:
	@echo "$(GREEN)Starting services on VPS...$(RESET)"
	@ssh $(USER)@$(IP) "cd $(TARGET_DIR) && docker compose up -d"
	@$(MAKE) status
	@echo "$(YELLOW)Odoo is live at:$(RESET) https://$(DOMAIN)"

rest:
	@echo "$(YELLOW)Restarting services on VPS...$(RESET)"
	@ssh $(USER)@$(IP) "cd $(TARGET_DIR) && docker compose restart"
	@$(MAKE) status
	@echo "$(GREEN)Services restarted successfully.$(RESET)"

logs:
	@ssh $(USER)@$(IP) "cd $(TARGET_DIR) && docker compose logs -f odoo"

status:
	@echo "$(GREEN)Current container status:$(RESET)"
	@ssh $(USER)@$(IP) "cd $(TARGET_DIR) && docker compose ps"
