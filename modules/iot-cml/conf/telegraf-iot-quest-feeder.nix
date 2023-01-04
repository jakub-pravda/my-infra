{ config, pkgs }:
let
  sensorNode = config.sensor-node;
in pkgs.writeText "telegraf-iot-quest-feeder.conf" ''
  # https://github.com/influxdata/telegraf/blob/release-1.14/plugins/inputs/mqtt_consumer/README.md
  [[inputs.mqtt_consumer]]
    servers = [ "tcp://mosquitto:1883" ]
    topics = [ "${sensorNode.hubName}/#" ]
    qos = 1
    data_format = "json"
    fieldpass = ["battery", "humidity", "linkquality", "temperature" ]

  [[outputs.socket_writer]]
    # Write metrics to a local QuestDB instance over TCP
    address = "tcp://quest-db:9009"
    data_format = "influx"

  # Debug
  [[outputs.file]]
    files = ["stdout"]
''