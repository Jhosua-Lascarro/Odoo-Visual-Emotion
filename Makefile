MAKEFLAGS += --no-print-directory

# Simple color setup
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: help up down prune

help:
	@echo "$(YELLOW)Usage: make [target]$(RESET)"
	@echo "  $(GREEN)up$(RESET)      Start containers"
	@echo "  $(GREEN)down$(RESET)    Stop containers"
	@echo "  $(GREEN)prune$(RESET)   Remove all data"

up: certs
	@echo "$(GREEN)Starting services...$(RESET)"
	@docker compose up -d > /dev/null 2>&1
	@$(MAKE) check
	@echo "$(YELLOW)Odoo is ready at:$(RESET) https://localhost"

down:
	@echo "$(YELLOW)Stopping services...$(RESET)"
	@docker compose down > /dev/null 2>&1
	@echo "$(GREEN)Services stopped successfully.$(RESET)"

prune:
	@echo "$(YELLOW)Cleaning all data...$(RESET)"
	@docker compose down -v > /dev/null 2>&1
	@rm -rf config/nginx/certs/*.crt config/nginx/certs/*.key > /dev/null 2>&1
	@echo "$(GREEN)All volumes and certificates removed.$(RESET)"

certs:
	@echo "$(GREEN)Generating SSL certificates...$(RESET)"
	@mkdir -p config/nginx/certs > /dev/null 2>&1
	@if [ ! -f config/nginx/certs/localhost.crt ]; then \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-keyout config/nginx/certs/localhost.key \
			-out config/nginx/certs/localhost.crt \
			-subj "/C=ES/ST=Local/L=Local/O=Dev/OU=IT/CN=localhost" > /dev/null 2>&1; \
		echo "$(GREEN)Certificates generated.$(RESET)"; \
	else \
		echo "Certificates already exist."; \
	fi

check:
	@echo "$(GREEN)Waiting for HTTPS 200 OK...$(RESET)"
	@i=1; while [ $$i -le 40 ]; do \
		STATUS=$$(curl -skL -w "%{http_code}" https://localhost -o /dev/null); \
		if [ "$$STATUS" -eq 200 ]; then \
			echo "$(GREEN)Success: Status 200$(RESET)"; \
			exit 0; \
		fi; \
		if [ $$(($$i % 5)) -eq 0 ]; then \
			echo "Attempt $$i: Still waiting... (Status: $$STATUS)"; \
		fi; \
		i=$$(($$i + 1)); \
		sleep 5; \
	done; \
	echo "$(YELLOW)Error: Timeout waiting for Odoo after 200 seconds$(RESET)"; \
	echo "--- Last 20 lines of Odoo logs ---"; \
	docker logs --tail 20 odoo; \
	exit 1

