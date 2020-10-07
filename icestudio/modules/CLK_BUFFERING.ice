{
  "version": "1.2",
  "package": {
    "name": "CLK_BUFFERING",
    "version": "0.1",
    "description": "System clock buffering.",
    "author": "Juan Manuel Rico",
    "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%22666.462%22%20height=%22652.176%22%20viewBox=%220%200%20176.3347%20172.55495%22%3E%3Cg%20transform=%22translate(-19.155%20-61.967)%22%20stroke=%22#fff%22%3E%3Crect%20width=%22176.335%22%20height=%22172.555%22%20x=%2219.155%22%20y=%2261.967%22%20ry=%2226.063%22%20opacity=%22.5%22%20stroke-width=%222%22%20stroke-dasharray=%224,2%22/%3E%3Cpath%20d=%22M24.591%20174.29h17.335v-57.953h32.681l.946%2057.954%2037.003.325.117-57.628%2033.623-.798.234%2058.1%2033.142.326%22%20fill=%22none%22%20stroke-width=%222.907%22/%3E%3Cpath%20d=%22M37.077%20173.622h17.335v-57.954h32.681l.945%2057.954%2037.004.326.117-57.629%2033.622-.798.235%2058.101%2033.142.326%22%20fill=%22none%22%20stroke-width=%222.907%22%20stroke-dasharray=%225.81400034,2.90700016999999988%22%20opacity=%22.4%22/%3E%3C/g%3E%3C/svg%3E"
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