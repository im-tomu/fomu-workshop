{
  "version": "1.2",
  "package": {
    "name": "PWM_GENERATOR",
    "version": "0.1",
    "description": "PWM generator.",
    "author": "Juan Manuel Rico",
    "image": ""
  },
  "design": {
    "board": "fomu",
    "graph": {
      "blocks": [
        {
          "id": "1d736c39-4508-4892-a588-95c481288c3f",
          "type": "basic.output",
          "data": {
            "name": "pwm_0",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 784,
            "y": 152
          }
        },
        {
          "id": "b395b403-3bfe-4808-bd8d-90d10b20b936",
          "type": "basic.output",
          "data": {
            "name": "pwm_1",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 784,
            "y": 256
          }
        },
        {
          "id": "d880db6e-2929-4aba-a450-b2723417bd70",
          "type": "basic.input",
          "data": {
            "name": "clk_input",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true,
            "clock": false
          },
          "position": {
            "x": -88,
            "y": 256
          }
        },
        {
          "id": "0bb7dca1-6a06-48c0-b91d-e6e6dd86d18e",
          "type": "basic.output",
          "data": {
            "name": "pwm_2",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 784,
            "y": 360
          }
        },
        {
          "id": "e510937c-2a8a-430b-aed2-ae42093e9ba4",
          "type": "basic.code",
          "data": {
            "code": "    // Use counter logic to divide system clock. \n    // The clock is 48 MHz, so we divide it down by 2^28.\n    reg [28:0] counter = 0;\n    \n    assign pwm_0 = counter[25];\n    assign pwm_1 = counter[24];\n    assign pwm_2 = counter[23];\n\n    always @(posedge clk_input) begin\n        counter <= counter + 1;\n    end",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk_input"
                }
              ],
              "out": [
                {
                  "name": "pwm_0"
                },
                {
                  "name": "pwm_1"
                },
                {
                  "name": "pwm_2"
                }
              ]
            }
          },
          "position": {
            "x": 104,
            "y": 128
          },
          "size": {
            "width": 568,
            "height": 320
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "e510937c-2a8a-430b-aed2-ae42093e9ba4",
            "port": "pwm_2"
          },
          "target": {
            "block": "0bb7dca1-6a06-48c0-b91d-e6e6dd86d18e",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "e510937c-2a8a-430b-aed2-ae42093e9ba4",
            "port": "pwm_1"
          },
          "target": {
            "block": "b395b403-3bfe-4808-bd8d-90d10b20b936",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "e510937c-2a8a-430b-aed2-ae42093e9ba4",
            "port": "pwm_0"
          },
          "target": {
            "block": "1d736c39-4508-4892-a588-95c481288c3f",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "d880db6e-2929-4aba-a450-b2723417bd70",
            "port": "out"
          },
          "target": {
            "block": "e510937c-2a8a-430b-aed2-ae42093e9ba4",
            "port": "clk_input"
          }
        }
      ]
    }
  },
  "dependencies": {}
}