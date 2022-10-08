{ pkgs, ... }:
pkgs.writeText "telegraf-iot-quest-feeder.conf" ''
  # https://github.com/influxdata/telegraf/blob/master/plugins/inputs/kafka_consumer/README.md
  [[inputs.kafka_consumer]]
    brokers = ["redpanda-1:9092"]
    topics = ["sensors-raw"]
    max_message_len = 1000000
    version = "2.8.2" # redpanda supports only kafka 2 version
    data_format = "influx"

  [[outputs.socket_writer]]
    # Write metrics to a local QuestDB instance over TCP
    address = "tcp://quest-db:9009"

  # Debug
  [[outputs.file]]
    files = ["stdout"]
''