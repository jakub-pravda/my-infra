{pkgs}:
pkgs.writeText "mosquitto.conf" ''
  persistence true
  allow_anonymous true
  bind_address 0.0.0.0

  persistence_location /mosquitto/data/

  log_dest file /mosquitto/log/mosquitto.log
''
