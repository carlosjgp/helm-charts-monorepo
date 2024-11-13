SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
# Only prints commands outputs on the Makefile (hides secrets)
MAKEFLAGS += --silent


.DEFAULT_GOAL := generate-examples

check-git-status:
	if [ ! -z "$(shell git status --porcelain)" ];
	then
		echo "Changes detected. Please run 'make generate-examples'"
		git status
		exit 1
	fi

generate-examples:
	tools/generate-examples.sh


lint:
	# https://github.com/helm/chart-testing
	poetry run ct lint --validate-maintainers=false --chart-dirs=charts
