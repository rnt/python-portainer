SHELL=/bin/sh

.PHONY: help clean-pyc clean-build docs

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf " \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

test:
	@nosetests -s

coverage:
	@rm -f .coverage
	@nosetests --with-coverage --cover-package=portainer --cover-html

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

venv: requirements.txt ## Create virtualenv
	@test -d venv || @echo "Creating venv..."
	@test -d venv || @python3 -m venv venv
	@venv/bin/pip install --quiet --upgrade pip setuptools
	@venv/bin/pip install --quiet --requirement requirements.txt
	@echo -e "\nNow run: source venv/bin/activate\n"

lint: venv ## Run code lint checks
	venv/bin/pycodestyle --exclude=venv/*
	venv/bin/pylint --ignore=venv portainer

rpm: venv ## Create module rpm
	@venv/bin/python3 setup.py bdist_rpm

pip-compile: venv ## Generate requirements.txt from requirements.in
	@venv/bin/pip-compile --output-file requirements.txt requirements.in

autopep8: venv ## Run autopep8
	find . -iname '*.py' -not -path './venv/*' -and -not -path './build/*' | xargs --max-args=1 venv/bin/autopep8 -i

build: venv ## Build artifact
	venv/bin/python3 setup.py sdist
	venv/bin/python3 setup.py bdist_wheel

upload: build ## Upload to pypi
	venv/bin/twine upload dist/*
