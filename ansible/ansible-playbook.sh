#!/bin/bash

source .venv/bin/activate

ansible-playbook "$@"
