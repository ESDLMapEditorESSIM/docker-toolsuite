.PHONY: up down logs status setup help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

setup: ## Copy .env.template to .env (if .env doesn't exist)
	@if [ -f .env ]; then \
		echo ".env already exists, skipping"; \
	else \
		cp .env.template .env; \
		echo "Created .env from template - edit as needed"; \
	fi

up: ## Start all services
	docker-compose up

up-d: ## Start all services (detached)
	docker-compose up -d

down: ## Stop all services
	docker-compose down

logs: ## Follow logs (all services)
	docker-compose logs -f

status: ## Show service status
	docker-compose ps
