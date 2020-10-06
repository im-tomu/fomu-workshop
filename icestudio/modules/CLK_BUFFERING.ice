{
  "version": "1.2",
  "package": {
    "name": "CLK_BUFFERING",
    "version": "0.1",
    "description": "System clock buffering.",
    "author": "Juan Manuel Rico",
    "image": ""
  },
  "design": {
    "board": "fomu",
    "graph": {
      "blocks": [
        {
          "id": "ea761b76-2554-46fc-9436-991ee3fd292a",
          "type": "basic.input",
          "data": {
            "name": "clk_i",
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
            "x": 48,
            "y": 208
          }
        },
        {
          "id": "02554bef-db6b-4e07-9bf1-478d7995c7b6",
          "type": "basic.output",
          "data": {
            "name": "clk_o",
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
            "x": 792,
            "y": 208
          }
        },
        {
          "id": "483a160a-12bb-47e1-94a3-feeb0b5b251d",
          "type": "basic.code",
          "data": {
            "code": "// Connect to system clock (with buffering).\nSB_GB clk_gb (\n    .USER_SIGNAL_TO_GLOBAL_BUFFER(clk_input),\n    .GLOBAL_BUFFER_OUTPUT(clk_output)\n);\n",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk_input"
                }
              ],
              "out": [
                {
                  "name": "clk_output"
                }
              ]
            }
          },
          "position": {
            "x": 232,
            "y": 168
          },
          "size": {
            "width": 456,
            "height": 144
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "ea761b76-2554-46fc-9436-991ee3fd292a",
            "port": "out"
          },
          "target": {
            "block": "483a160a-12bb-47e1-94a3-feeb0b5b251d",
            "port": "clk_input"
          }
        },
        {
          "source": {
            "block": "483a160a-12bb-47e1-94a3-feeb0b5b251d",
            "port": "clk_output"
          },
          "target": {
            "block": "02554bef-db6b-4e07-9bf1-478d7995c7b6",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}