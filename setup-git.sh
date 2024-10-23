#!/bin/bash
. .env
git config --global user.name $name
git config --global user.email $email
git config --global core.editor "code --wait"
gh auth login