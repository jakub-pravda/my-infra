{ pkgs }:
hubNameList:
let
  hubNamesSubscribeAll = map (hubName: ''"${hubName}/#"'') hubNameList;
  hubNamesFormatted = builtins.concatStringsSep "," hubNamesSubscribeAll;
in pkgs.writeText "telegraf-iot-quest-feeder.conf" ''
  # https://github.com/influxdata/telegraf/blob/release-1.14/plugins/inputs/mqtt_consumer/README.md
  [[inputs.mqtt_consumer]]
    servers = [ "tcp://mosquitto:1883" ]
    topics = [ ${hubNamesFormatted} ]
    qos = 1
    data_format = "json"
    fieldpass = [
      "battery",
      "linkquality", 
      "humidity",
      "temperature",
      "external_measured_room_sensor",
      "local_temperature",
      "occupied_heating_setpoint_scheduled",
      "pi_heating_demand",
      "pressure"
      ]

  [[outputs.socket_writer]]
    # Write metrics to a local QuestDB instance over TCP
    address = "tcp://quest-db:9009"
    data_format = "influx"

  # Debug
  [[outputs.file]]
    files = ["stdout"]
''
