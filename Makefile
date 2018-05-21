SHELL=/bin/sh

.PHONY: help clean-pyc clean-build docs

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf " \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

test:
	@nosetests -s

coverage:
	@rm -f .coverage
	@nosetests --with-coverage --cover-package=safe --cover-html

clean: clean-build clean-pyc clean-docs ## Clean all


clean-build: ##   Clean build
	@rm -fr build/
	@rm -fr dist/
	@rm -fr *.egg-info


clean-pyc:  ##   Clean pyc
	@find . -name '*.pyc' -exec rm -f {} +
	@find . -name '*.pyo' -exec rm -f {} +
	@find . -name '*~' -exec rm -f {} +
	@find . -name '__pycache__' -exec rm -fr {} +

clean-docs:
	@rm -fr  docs/_build

docs:
	@$(MAKE) -C docs html

venv: ## Create virtualenv
	@echo "Creating venv..."
	@python3 -m venv venv
	@venv/bin/pip install --quiet --upgrade pip
	@venv/bin/pip install --quiet --upgrade setuptools
	@venv/bin/pip install --quiet --upgrade pycodestyle pylint
	@venv/bin/pip install --quiet requests
	@echo -e "\nNow run: source venv/bin/activate\n"

check: venv ## Run code check
	venv/bin/pycodestyle --exclude=venv/*
	venv/bin/pylint --ignore=venv portainer

rpm: venv ## Create module rpm
	@python3 setup.py bdist_rpm
