{ pkgs, ... }:
pkgs.writeText "telegraf-iot-quest-feeder.conf" ''
  # https://github.com/influxdata/telegraf/blob/release-1.23/plugins/inputs/amqp_consumer/README.md
  [[inputs.amqp_consumer]]
    brokers = ["amqp://rabbit-mq:5672"]
    exchange = "quest-feeder"
    queue = "sensors-raw"
    queue_durability = "durable"
    binding_key = "#"
    data_format = "influx"

  [[outputs.socket_writer]]
    # Write metrics to a local QuestDB instance over TCP
    address = "tcp://quest-db:9009"

  # Debug
  [[outputs.file]]
    files = ["stdout"]
''