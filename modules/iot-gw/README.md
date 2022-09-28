# General

Run nixos test/switch, whatever:

```sh
sudo nixos-rebuild dry-build -I nixos-config=/home/jacfal/my-infra/home-gw/configuration.nix
```

## Zigbee2mqtt

### Troubleshooting

When...

```
Configuration is not consistent with adapter state/backup!
- PAN ID: configured=, adapter=
- Extended PAN ID: configured=, adapter=
- Network Key: configured=xy, adapter=zxt
- Channel List: configured=11, adapter=11
Zigbee2MQTT:error 2022-09-28 18:58:31: Error: startup failed - configuration-adapter mismatch - see logs above for more information
```

Network key regenerated during the startup. The solution is to remove the `coordinator_backup.json` and then repair all devices.

```bash
rm  /var/lib/zigbee2mqtt/coordinator_backup.json 
```
