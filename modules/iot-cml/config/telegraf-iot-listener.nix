{ pkgs, ... }:
pkgs.writeText "telegraf-iot-listener.conf" ''
  # https://github.com/influxdata/telegraf/blob/master/plugins/inputs/http_listener_v2/README.md
  [[inputs.http_listener_v2]]
    service_address = ":2684"
    methods = ["POST"]
    data_format = "influx"

  # https://github.com/influxdata/telegraf/blob/release-1.9/plugins/outputs/kafka/README.md
  [[outputs.kafka]]
    brokers = ["redpanda-1:9092"]
    topic = "sensors-raw"
    data_format = "influx"
    version = "2.8.2" # redpanda supports only kafka 2 version

  # Debug
  [[outputs.file]]
    files = ["stdout"]
''
