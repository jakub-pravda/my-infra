{ pkgs, ... }:
pkgs.writeText "telegraf-iot-listener.conf" ''
  # https://github.com/influxdata/telegraf/blob/master/plugins/inputs/http_listener_v2/README.md
  [[inputs.http_listener_v2]]
    service_address = ":2684"
    methods = ["POST"]
    data_format = "influx"

  # https://github.com/influxdata/telegraf/blob/master/plugins/outputs/amqp/README.md
  [[outputs.amqp]]
    brokers = ["amqp://rabbit-mq:5672"]
    exchange = "sensors-home-gw"

  # Debug
  [[outputs.file]]
    files = ["stdout"]
''
