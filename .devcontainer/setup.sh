#!/bin/sh
cp -n .env.example .env
cp -n terraform/environments/dev/terraform.tfvars.example terraform/environments/dev/terraform.tfvars
npm install
