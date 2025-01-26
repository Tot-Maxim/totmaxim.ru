#!/bin/bash

sudo systemctl stop my-node-js-app
docker compose up --build

sudo systemctl daemon-reload
sudo systemctl start my-node-js-app

