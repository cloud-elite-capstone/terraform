#!/bin/sh
cp -n .env.example .env
cp -n terraform/environments/dev/terraform.example.tfvars terraform/environments/dev/terraform.tfvars
npm install
