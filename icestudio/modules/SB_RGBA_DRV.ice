{
  "version": "1.2",
  "package": {
    "name": "SB_RGBA_DRV",
    "version": "0.1",
    "description": "iCE40 UltraPlus RGB driver.",
    "author": "Juan Manuel Rico",
    "image": ""
  },
  "design": {
    "board": "fomu",
    "graph": {
      "blocks": [
        {
          "id": "b15672d8-2cc0-4f2e-a5c6-94de78659ccf",
          "type": "basic.input",
          "data": {
            "name": "power_up",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
            "clock": false
          },
          "position": {
            "x": -256,
            "y": 128
          }
        },
        {
          "id": "85ab9730-f026-4285-86dd-abb2f338ae31",
          "type": "basic.output",
          "data": {
            "name": "BLUE",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 1016,
            "y": 168
          }
        },
        {
          "id": "0e1f9059-67d6-40cc-8653-6c8208093b4f",
          "type": "basic.input",
          "data": {
            "name": "enable",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
            "clock": false
          },
          "position": {
            "x": -256,
            "y": 240
          }
        },
        {
          "id": "7c85e6ad-6f1d-49d8-9c1c-82ad40d8b230",
          "type": "basic.output",
          "data": {
            "name": "RED",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 1024,
            "y": 352
          }
        },
        {
          "id": "3417cd76-ecff-4b2a-9ae3-45faa8cc042e",
          "type": "basic.input",
          "data": {
            "name": "BLUE_PWM",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
            "clock": false
          },
          "position": {
            "x": -256,
            "y": 352
          }
        },
        {
          "id": "838cb58a-2211-4a35-8253-18ac9491457b",
          "type": "basic.input",
          "data": {
            "name": "RED_PWM",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
            "clock": false
          },
          "position": {
            "x": -256,
            "y": 464
          }
        },
        {
          "id": "e981e408-54c7-4b38-bc99-2508dd197e1e",
          "type": "basic.output",
          "data": {
            "name": "GREEN",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 1024,
            "y": 536
          }
        },
        {
          "id": "b6d5b2a0-6c0d-4b7c-bb62-6aa6605ea429",
          "type": "basic.input",
          "data": {
            "name": "GREEN_PWM",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
            "clock": false
          },
          "position": {
            "x": -256,
            "y": 576
          }
        },
        {
          "id": "ef62aea7-0f83-4fd8-80f0-5c93e3a677e5",
          "type": "basic.constant",
          "data": {
            "name": "MODE",
            "value": "\"0b0\"",
            "local": false
          },
          "position": {
            "x": 168,
            "y": -152
          }
        },
        {
          "id": "3bcab194-bcfe-46b5-91ff-208a843def63",
          "type": "basic.constant",
          "data": {
            "name": "BLUE_CURRENT",
            "value": "\"0b000000\"",
            "local": false
          },
          "position": {
            "x": 352,
            "y": -152
          }
        },
        {
          "id": "6100c41e-2ba3-442a-b6fa-7f20e0b53194",
          "type": "basic.constant",
          "data": {
            "name": "RED_CURRENT",
            "value": "\"0b000000\"",
            "local": false
          },
          "position": {
            "x": 536,
            "y": -152
          }
        },
        {
          "id": "fe7e8f4c-224f-42d3-b2f1-ab2f0ade9f31",
          "type": "basic.constant",
          "data": {
            "name": "GREEN_CURRENT",
            "value": "\"0b000000\"",
            "local": false
          },
          "position": {
            "x": 720,
            "y": -152
          }
        },
        {
          "id": "15b1918f-21ac-49c1-8287-081992b83b33",
          "type": "basic.code",
          "data": {
            "code": "\n    SB_RGBA_DRV #(\n        .CURRENT_MODE (MODE),\n        .RGB0_CURRENT (BLUE_CURRENT),\n        .RGB1_CURRENT (RED_CURRENT),\n        .RGB2_CURRENT (GREEN_CURRENT)\n    ) RGBA_DRIVER (\n        .CURREN (power_up),\n        .RGBLEDEN (enable),\n        .RGB0PWM (BLUE_PWM),\n        .RGB1PWM (RED_PWM),\n        .RGB2PWM (GREEN_PWM),\n        .RGB0 (BLUE),\n        .RGB1 (RED),\n        .RGB2 (GREEN)\n    );",
            "params": [
              {
                "name": "MODE"
              },
              {
                "name": "BLUE_CURRENT"
              },
              {
                "name": "RED_CURRENT"
              },
              {
                "name": "GREEN_CURRENT"
              }
            ],
            "ports": {
              "in": [
                {
                  "name": "power_up"
                },
                {
                  "name": "enable"
                },
                {
                  "name": "BLUE_PWM"
                },
                {
                  "name": "RED_PWM"
                },
                {
                  "name": "GREEN_PWM"
                }
              ],
              "out": [
                {
                  "name": "BLUE"
                },
                {
                  "name": "RED"
                },
                {
                  "name": "GREEN"
                }
              ]
            }
          },
          "position": {
            "x": 120,
            "y": 104
          },
          "size": {
            "width": 736,
            "height": 560
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "b15672d8-2cc0-4f2e-a5c6-94de78659ccf",
            "port": "out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "power_up"
          }
        },
        {
          "source": {
            "block": "ef62aea7-0f83-4fd8-80f0-5c93e3a677e5",
            "port": "constant-out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "MODE"
          }
        },
        {
          "source": {
            "block": "3bcab194-bcfe-46b5-91ff-208a843def63",
            "port": "constant-out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "BLUE_CURRENT"
          }
        },
        {
          "source": {
            "block": "6100c41e-2ba3-442a-b6fa-7f20e0b53194",
            "port": "constant-out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "RED_CURRENT"
          }
        },
        {
          "source": {
            "block": "fe7e8f4c-224f-42d3-b2f1-ab2f0ade9f31",
            "port": "constant-out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "GREEN_CURRENT"
          }
        },
        {
          "source": {
            "block": "0e1f9059-67d6-40cc-8653-6c8208093b4f",
            "port": "out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "enable"
          }
        },
        {
          "source": {
            "block": "3417cd76-ecff-4b2a-9ae3-45faa8cc042e",
            "port": "out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "BLUE_PWM"
          }
        },
        {
          "source": {
            "block": "838cb58a-2211-4a35-8253-18ac9491457b",
            "port": "out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "RED_PWM"
          }
        },
        {
          "source": {
            "block": "b6d5b2a0-6c0d-4b7c-bb62-6aa6605ea429",
            "port": "out"
          },
          "target": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "GREEN_PWM"
          }
        },
        {
          "source": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "BLUE"
          },
          "target": {
            "block": "85ab9730-f026-4285-86dd-abb2f338ae31",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "RED"
          },
          "target": {
            "block": "7c85e6ad-6f1d-49d8-9c1c-82ad40d8b230",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "15b1918f-21ac-49c1-8287-081992b83b33",
            "port": "GREEN"
          },
          "target": {
            "block": "e981e408-54c7-4b38-bc99-2508dd197e1e",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}