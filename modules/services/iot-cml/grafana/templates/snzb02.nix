{pkgs, ...}: dataSourceUid: title: topic:
pkgs.writeText "template" ''
  {
    "annotations": {
      "list": [
        {
          "builtIn": 1,
          "datasource": {
            "type": "grafana",
            "uid": "-- Grafana --"
          },
          "enable": true,
          "hide": true,
          "iconColor": "rgba(0, 211, 255, 1)",
          "name": "Annotations & Alerts",
          "target": {
            "limit": 100,
            "matchAny": false,
            "tags": [],
            "type": "dashboard"
          },
          "type": "dashboard"
        }
      ]
    },
    "editable": true,
    "fiscalYearStartMonth": 0,
    "graphTooltip": 0,
    "links": [],
    "liveNow": false,
    "panels": [
      {
        "datasource": {
          "type": "postgres",
          "uid": "${dataSourceUid}"
        },
        "description": "",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 30,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "smooth",
              "lineStyle": {
                "fill": "solid"
              },
              "lineWidth": 1,
              "pointSize": 1,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "auto",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "off"
              }
            },
            "mappings": [],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 80
                }
              ]
            },
            "unit": "celsius"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 9,
          "w": 14,
          "x": 0,
          "y": 0
        },
        "id": 2,
        "options": {
          "legend": {
            "calcs": [],
            "displayMode": "list",
            "placement": "bottom"
          },
          "tooltip": {
            "mode": "single",
            "sort": "none"
          }
        },
        "targets": [
          {
            "datasource": {
              "type": "postgres",
              "uid": "${dataSourceUid}"
            },
            "format": "time_series",
            "group": [
              {
                "params": [
                  "15m",
                  "previous"
                ],
                "type": "time"
              }
            ],
            "hide": false,
            "metricColumn": "none",
            "rawQuery": true,
            "rawSql": "SELECT\n  $__timeGroupAlias(timestamp,15m,previous),\n  temperature AS \"temperature\"\nFROM mqtt_consumer\nWHERE topic in ('${topic}')\nGROUP BY 1\nORDER BY 1",
            "refId": "A",
            "select": [
              [
                {
                  "params": [
                    "temperature"
                  ],
                  "type": "column"
                },
                {
                  "params": [
                    "temperature"
                  ],
                  "type": "alias"
                }
              ]
            ],
            "table": "mqtt_consumer",
            "timeColumn": "timestamp",
            "where": [
              {
                "name": "",
                "params": [
                  "topic",
                  "=",
                  "${topic}"
                ],
                "type": "expression"
              }
            ]
          }
        ],
        "title": "Temparature",
        "type": "timeseries"
      },
      {
        "datasource": {
          "type": "postgres",
          "uid": "${dataSourceUid}"
        },
        "description": "Signal strength",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "continuous-RdYlGr"
            },
            "mappings": [],
            "max": 250,
            "min": 0,
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 80
                }
              ]
            }
          },
          "overrides": []
        },
        "gridPos": {
          "h": 9,
          "w": 3,
          "x": 14,
          "y": 0
        },
        "id": 6,
        "options": {
          "orientation": "auto",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
            ],
            "fields": "",
            "values": false
          },
          "showThresholdLabels": false,
          "showThresholdMarkers": true,
          "text": {
            "titleSize": 1
          }
        },
        "pluginVersion": "8.5.3",
        "targets": [
          {
            "datasource": {
              "type": "postgres",
              "uid": "${dataSourceUid}"
            },
            "format": "time_series",
            "group": [],
            "metricColumn": "none",
            "rawQuery": true,
            "rawSql": "SELECT\n  timestamp AS \"time\",\n  linkquality\nFROM mqtt_consumer\nWHERE topic in ('${topic}')\nORDER BY 1",
            "refId": "A",
            "select": [
              [
                {
                  "params": [
                    "linkquality"
                  ],
                  "type": "column"
                }
              ]
            ],
            "table": "mqtt_consumer",
            "timeColumn": "timestamp",
            "where": []
          }
        ],
        "title": "Linkquality",
        "type": "gauge"
      },
      {
        "datasource": {
          "type": "postgres",
          "uid": "${dataSourceUid}"
        },
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "continuous-BlYlRd"
            },
            "custom": {
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 5,
              "gradientMode": "none",
              "hideFrom": {
                "legend": false,
                "tooltip": false,
                "viz": false
              },
              "lineInterpolation": "smooth",
              "lineWidth": 1,
              "pointSize": 1,
              "scaleDistribution": {
                "type": "linear"
              },
              "showPoints": "auto",
              "spanNulls": false,
              "stacking": {
                "group": "A",
                "mode": "none"
              },
              "thresholdsStyle": {
                "mode": "off"
              }
            },
            "mappings": [],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 80
                }
              ]
            },
            "unit": "humidity"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 9,
          "w": 14,
          "x": 0,
          "y": 9
        },
        "id": 4,
        "options": {
          "legend": {
            "calcs": [],
            "displayMode": "list",
            "placement": "bottom"
          },
          "tooltip": {
            "mode": "single",
            "sort": "none"
          }
        },
        "targets": [
          {
            "datasource": {
              "type": "postgres",
              "uid": "${dataSourceUid}"
            },
            "format": "time_series",
            "group": [],
            "metricColumn": "none",
            "rawQuery": true,
            "rawSql": "SELECT\n  $__timeGroupAlias(timestamp,15m,previous),\n  humidity AS \"humidity\"\nFROM mqtt_consumer\nWHERE topic in ('${topic}')\nGROUP BY 1\nORDER BY 1",
            "refId": "A",
            "select": [
              [
                {
                  "params": [
                    "value"
                  ],
                  "type": "column"
                }
              ]
            ],
            "timeColumn": "time",
            "where": [
              {
                "name": "$__timeFilter",
                "params": [],
                "type": "macro"
              }
            ]
          }
        ],
        "title": "Humidity",
        "type": "timeseries"
      },
      {
        "datasource": {
          "type": "postgres",
          "uid": "${dataSourceUid}"
        },
        "description": "Remaining battery",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "continuous-RdYlGr"
            },
            "mappings": [],
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {
                  "color": "green",
                  "value": null
                },
                {
                  "color": "red",
                  "value": 80
                }
              ]
            },
            "unit": "percent"
          },
          "overrides": []
        },
        "gridPos": {
          "h": 5,
          "w": 3,
          "x": 14,
          "y": 9
        },
        "id": 8,
        "options": {
          "colorMode": "value",
          "graphMode": "none",
          "justifyMode": "auto",
          "orientation": "auto",
          "reduceOptions": {
            "calcs": [
              "lastNotNull"
            ],
            "fields": "",
            "values": false
          },
          "textMode": "auto"
        },
        "pluginVersion": "8.5.3",
        "targets": [
          {
            "datasource": {
              "type": "postgres",
              "uid": "${dataSourceUid}"
            },
            "format": "time_series",
            "group": [],
            "metricColumn": "none",
            "rawQuery": true,
            "rawSql": "SELECT\n  timestamp AS \"time\",\n  battery\nFROM mqtt_consumer\nWHERE topic in ('${topic}')\nORDER BY 1",
            "refId": "A",
            "select": [
              [
                {
                  "params": [
                    "battery"
                  ],
                  "type": "column"
                }
              ]
            ],
            "table": "mqtt_consumer",
            "timeColumn": "timestamp",
            "where": []
          }
        ],
        "title": "Battery",
        "type": "stat"
      }
    ],
    "refresh": "",
    "schemaVersion": 36,
    "style": "dark",
    "tags": [],
    "templating": {
      "list": []
    },
    "time": {
      "from": "now-12h",
      "to": "now"
    },
    "timepicker": {},
    "timezone": "",
    "title": "${title}",
    "version": 6,
    "weekStart": ""
  }
''
