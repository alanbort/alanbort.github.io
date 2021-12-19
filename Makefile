DEBUG=JEKYLL_GITHUB_TOKEN=blank PAGES_API_URL=http://0.0.0.0

.PHONY: install clean server dev-install update build

default: install build server

dev-install:
ifneq ($(shell id -u), 0)
	@echo "You must be root to perform this action."
else
	@apt install -y ruby-full
endif

install:
	@if [ -d "vendor" ]; then \
		echo "vendor directory exists. Updating instead"; \
		$(MAKE) update; \
	else \
		echo "Installing with bundler"; \
		gem install jekyll bundler --install-dir vendor && \
		bundle install --path=vendor; \
	fi

update:
	@bundle update

clean:
	@if [ -d "_site" ] && [ -d "vendor" ]; then \
		echo "Cleaning site with Jekyll"; \
		bundle exec jekyll clean; \
	else \
		if [ -d "_site" ]; then \
			echo "Removing _site manually"; \
			rm -fR _site; \
		else \
			echo "Site was already cleaned"; \
		fi \
	fi

clean-all: clean
	@echo "Removing local gems"
	@rm -fR vendor

build: clean
	@${DEBUG} bundle exec jekyll build --profile --config _config.yml,.debug.yml

server: clean
	@${DEBUG} bundle exec jekyll server --livereload --config _config.yml,.debug.yml