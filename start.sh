#!/usr/bin/env bash

set -e

ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"
PROJECT_NAME="datainsight-visits-collector"

echo -e "${ANSI_YELLOW}Installing dependencies${ANSI_RESET}"
bundle install --path vendor --local
bundle exec whenever --update-crontab $PROJECT_NAME
