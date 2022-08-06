#!/bin/sh
if [ "$1" == "up" ]; then
    echo "Docker compose up..."
    docker compose -f ./rabbitmq/compose-rabbitmq.yml up -d
    docker compose -f ./questdb/compose-questdb.yml up -d
    docker compose -f ./telegraf/compose-telegraf.yml up -d
elif [ "$1" == "down" ]; then
    echo "Docker compose down..."
    docker compose -f ./rabbitmq/compose-rabbitmq.yml down -v
    docker compose -f ./questdb/compose-questdb.yml down -v
    docker compose -f ./telegraf/compose-telegraf.yml down -v
else
    echo "Only up/down are valid cmds now"
    exit 1
fi
