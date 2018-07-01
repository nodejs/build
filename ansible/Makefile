.PHONY: ENV

virtualenv_path = ./virtualenv

ENV: Makefile
	virtualenv2 --distribute $(virtualenv_path)

CHECK_ENV:
ifndef VIRTUAL_ENV
	$(error PLEASE ENTER THE VIRTUALENV BEFORE FUN THE COMMAND)
endif

UPDATE_ENV: requirements.txt
	$(virtualenv_path)/bin/pip install --upgrade setuptools
	$(virtualenv_path)/bin/pip install --upgrade pip
	$(virtualenv_path)/bin/pip install -r requirements.txt

FLAKE8: CHECK_ENV
	flake8

