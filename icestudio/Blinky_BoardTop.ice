{
  "version": "1.2",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "fomu",
    "graph": {
      "blocks": [
        {
          "id": "5a1323c3-4597-429f-a9c7-e8ff5b23d9b3",
          "type": "basic.output",
          "data": {
            "name": "",
            "pins": [
              {
                "index": "0",
                "name": "usb_dn",
                "value": "A2"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 552,
            "y": 136
          }
        },
        {
          "id": "78891846-58bc-44c5-9ee7-ace57d4836bb",
          "type": "basic.output",
          "data": {
            "name": "",
            "pins": [
              {
                "index": "0",
                "name": "usb_dp",
                "value": "A1"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 560,
            "y": 184
          }
        },
        {
          "id": "69ae577b-ac2d-4f56-9596-ffcb4021899a",
          "type": "basic.output",
          "data": {
            "name": "",
            "pins": [
              {
                "index": "0",
                "name": "usb_dp_pu",
                "value": "A4"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 568,
            "y": 232
          }
        },
        {
          "id": "6cd56993-b7cb-4edd-9b9e-ef9fbf93e3f9",
          "type": "basic.output",
          "data": {
            "name": "",
            "pins": [
              {
                "index": "0",
                "name": "rgb0",
                "value": "A5"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 552,
            "y": 280
          }
        },
        {
          "id": "f80013c3-4b76-4b26-ae0a-784025bbff6f",
          "type": "basic.output",
          "data": {
            "name": "",
            "pins": [
              {
                "index": "0",
                "name": "rgb1",
                "value": "B5"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 560,
            "y": 328
          }
        },
        {
          "id": "a1562249-78d8-4020-b272-0c9217acfdf7",
          "type": "basic.output",
          "data": {
            "name": "",
            "pins": [
              {
                "index": "0",
                "name": "rgb2",
                "value": "C5"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 568,
            "y": 376
          }
        },
        {
          "id": "b36bd0fd-d390-445f-9d3b-479acb5dc869",
          "type": "e70075def0e8492b26e8972d4d035c1c73e3afd7",
          "position": {
            "x": 368,
            "y": 200
          },
          "size": {
            "width": 96,
            "height": 192
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "b36bd0fd-d390-445f-9d3b-479acb5dc869",
            "port": "e3c9bc63-8b3a-4bf0-a6a4-abf64dec805b"
          },
          "target": {
            "block": "6cd56993-b7cb-4edd-9b9e-ef9fbf93e3f9",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "b36bd0fd-d390-445f-9d3b-479acb5dc869",
            "port": "fd5a9c81-dceb-4773-af8d-f3c7d472f43c"
          },
          "target": {
            "block": "f80013c3-4b76-4b26-ae0a-784025bbff6f",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "b36bd0fd-d390-445f-9d3b-479acb5dc869",
            "port": "9d5d6cc4-a66f-4bef-b255-3e4d06406775"
          },
          "target": {
            "block": "a1562249-78d8-4020-b272-0c9217acfdf7",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "b36bd0fd-d390-445f-9d3b-479acb5dc869",
            "port": "1ef8433d-89c7-4a46-9f81-127e4625c385"
          },
          "target": {
            "block": "5a1323c3-4597-429f-a9c7-e8ff5b23d9b3",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "b36bd0fd-d390-445f-9d3b-479acb5dc869",
            "port": "c3202cb6-0734-4718-8e2c-06a6af70dce1"
          },
          "target": {
            "block": "78891846-58bc-44c5-9ee7-ace57d4836bb",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "b36bd0fd-d390-445f-9d3b-479acb5dc869",
            "port": "8dafbca8-542c-47aa-8038-475339d38665"
          },
          "target": {
            "block": "69ae577b-ac2d-4f56-9596-ffcb4021899a",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {
    "e70075def0e8492b26e8972d4d035c1c73e3afd7": {
      "package": {
        "name": "Blinky",
        "version": "0.1",
        "description": "Simple blinky example.",
        "author": "Juan Manuel Rico",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "1ef8433d-89c7-4a46-9f81-127e4625c385",
              "type": "basic.output",
              "data": {
                "name": "usb_dn"
              },
              "position": {
                "x": 256,
                "y": 192
              }
            },
            {
              "id": "c3202cb6-0734-4718-8e2c-06a6af70dce1",
              "type": "basic.output",
              "data": {
                "name": "usb_dp"
              },
              "position": {
                "x": 256,
                "y": 240
              }
            },
            {
              "id": "8dafbca8-542c-47aa-8038-475339d38665",
              "type": "basic.output",
              "data": {
                "name": "usb_dp_pu",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false
              },
              "position": {
                "x": 256,
                "y": 288
              }
            },
            {
              "id": "e3c9bc63-8b3a-4bf0-a6a4-abf64dec805b",
              "type": "basic.output",
              "data": {
                "name": "BLUE"
              },
              "position": {
                "x": 1080,
                "y": 320
              }
            },
            {
              "id": "fd5a9c81-dceb-4773-af8d-f3c7d472f43c",
              "type": "basic.output",
              "data": {
                "name": "RED"
              },
              "position": {
                "x": 1080,
                "y": 456
              }
            },
            {
              "id": "788c569d-cf7f-4dae-aac1-76189ebc5ec8",
              "type": "basic.input",
              "data": {
                "name": "clk",
                "clock": false
              },
              "position": {
                "x": -24,
                "y": 488
              }
            },
            {
              "id": "9d5d6cc4-a66f-4bef-b255-3e4d06406775",
              "type": "basic.output",
              "data": {
                "name": "GREEN"
              },
              "position": {
                "x": 1080,
                "y": 592
              }
            },
            {
              "id": "1dd78ea6-3955-462b-a500-2b60b6f150a0",
              "type": "basic.constant",
              "data": {
                "name": "mode",
                "value": "\"0b1\"",
                "local": false
              },
              "position": {
                "x": 632,
                "y": 128
              }
            },
            {
              "id": "4450d93c-241e-4519-89b1-3db32b05a74f",
              "type": "basic.constant",
              "data": {
                "name": "current",
                "value": "\"0b000011\"",
                "local": false
              },
              "position": {
                "x": 736,
                "y": 128
              }
            },
            {
              "id": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
              "type": "faca1a3f2c3124f5fa40f6be960575788a8a49b8",
              "position": {
                "x": 704,
                "y": 408
              },
              "size": {
                "width": 128,
                "height": 160
              }
            },
            {
              "id": "7ee4fba5-3303-4928-931a-f67ceb9d1721",
              "type": "basic.info",
              "data": {
                "info": "Assign USB pins to \"0\" so as to disconnect Fomu from\nthe host system.  Otherwise it would try to talk to\nus over USB, which wouldn't work since we have no stack.",
                "readonly": true
              },
              "position": {
                "x": 24,
                "y": 128
              },
              "size": {
                "width": 480,
                "height": 72
              }
            },
            {
              "id": "f7f8fbf8-4b48-469a-9f57-425e689b3369",
              "type": "c4dd08263a85a91ba53e2ae2b38de344c5efcb52",
              "position": {
                "x": 120,
                "y": 240
              },
              "size": {
                "width": 96,
                "height": 64
              }
            },
            {
              "id": "ad444913-0f71-4de3-9afc-47099a8025cc",
              "type": "49bbffdd8923fd315c8784617f34fb53643f55e2",
              "position": {
                "x": 400,
                "y": 472
              },
              "size": {
                "width": 96,
                "height": 96
              }
            },
            {
              "id": "b7e33c0f-3564-4177-8ac5-d6e45ba9ee8f",
              "type": "c83dcd1d9ab420d911df81b3dfae04681559c623",
              "position": {
                "x": 528,
                "y": 392
              },
              "size": {
                "width": 96,
                "height": 64
              }
            },
            {
              "id": "3aa5743f-5065-4847-a53f-fb7319531ce8",
              "type": "2935c74667d5b53536ec18b0cf19b1caeec60a84",
              "position": {
                "x": 184,
                "y": 488
              },
              "size": {
                "width": 96,
                "height": 64
              }
            },
            {
              "id": "79b80dea-9c20-48b9-a730-68b323381b69",
              "type": "basic.info",
              "data": {
                "info": "Half mode, 4mA of current.",
                "readonly": true
              },
              "position": {
                "x": 648,
                "y": 80
              },
              "size": {
                "width": 320,
                "height": 40
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "1dd78ea6-3955-462b-a500-2b60b6f150a0",
                "port": "constant-out"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "ef62aea7-0f83-4fd8-80f0-5c93e3a677e5"
              }
            },
            {
              "source": {
                "block": "4450d93c-241e-4519-89b1-3db32b05a74f",
                "port": "constant-out"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "3bcab194-bcfe-46b5-91ff-208a843def63"
              },
              "vertices": [
                {
                  "x": 776,
                  "y": 240
                }
              ]
            },
            {
              "source": {
                "block": "4450d93c-241e-4519-89b1-3db32b05a74f",
                "port": "constant-out"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "6100c41e-2ba3-442a-b6fa-7f20e0b53194"
              }
            },
            {
              "source": {
                "block": "4450d93c-241e-4519-89b1-3db32b05a74f",
                "port": "constant-out"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "fe7e8f4c-224f-42d3-b2f1-ab2f0ade9f31"
              },
              "vertices": [
                {
                  "x": 784,
                  "y": 240
                },
                {
                  "x": 792,
                  "y": 240
                }
              ]
            },
            {
              "source": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "85ab9730-f026-4285-86dd-abb2f338ae31"
              },
              "target": {
                "block": "e3c9bc63-8b3a-4bf0-a6a4-abf64dec805b",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "7c85e6ad-6f1d-49d8-9c1c-82ad40d8b230"
              },
              "target": {
                "block": "fd5a9c81-dceb-4773-af8d-f3c7d472f43c",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "e981e408-54c7-4b38-bc99-2508dd197e1e"
              },
              "target": {
                "block": "9d5d6cc4-a66f-4bef-b255-3e4d06406775",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "f7f8fbf8-4b48-469a-9f57-425e689b3369",
                "port": "19c8f68d-5022-487f-9ab0-f0a3cd58bead"
              },
              "target": {
                "block": "1ef8433d-89c7-4a46-9f81-127e4625c385",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "f7f8fbf8-4b48-469a-9f57-425e689b3369",
                "port": "19c8f68d-5022-487f-9ab0-f0a3cd58bead"
              },
              "target": {
                "block": "c3202cb6-0734-4718-8e2c-06a6af70dce1",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "ad444913-0f71-4de3-9afc-47099a8025cc",
                "port": "1d736c39-4508-4892-a588-95c481288c3f"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "3417cd76-ecff-4b2a-9ae3-45faa8cc042e"
              }
            },
            {
              "source": {
                "block": "ad444913-0f71-4de3-9afc-47099a8025cc",
                "port": "b395b403-3bfe-4808-bd8d-90d10b20b936"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "838cb58a-2211-4a35-8253-18ac9491457b"
              }
            },
            {
              "source": {
                "block": "ad444913-0f71-4de3-9afc-47099a8025cc",
                "port": "0bb7dca1-6a06-48c0-b91d-e6e6dd86d18e"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "b6d5b2a0-6c0d-4b7c-bb62-6aa6605ea429"
              }
            },
            {
              "source": {
                "block": "b7e33c0f-3564-4177-8ac5-d6e45ba9ee8f",
                "port": "19c8f68d-5022-487f-9ab0-f0a3cd58bead"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "b15672d8-2cc0-4f2e-a5c6-94de78659ccf"
              }
            },
            {
              "source": {
                "block": "b7e33c0f-3564-4177-8ac5-d6e45ba9ee8f",
                "port": "19c8f68d-5022-487f-9ab0-f0a3cd58bead"
              },
              "target": {
                "block": "85df3463-4235-41d4-bd20-3a0bd1c4fd14",
                "port": "0e1f9059-67d6-40cc-8653-6c8208093b4f"
              }
            },
            {
              "source": {
                "block": "3aa5743f-5065-4847-a53f-fb7319531ce8",
                "port": "02554bef-db6b-4e07-9bf1-478d7995c7b6"
              },
              "target": {
                "block": "ad444913-0f71-4de3-9afc-47099a8025cc",
                "port": "d880db6e-2929-4aba-a450-b2723417bd70"
              }
            },
            {
              "source": {
                "block": "788c569d-cf7f-4dae-aac1-76189ebc5ec8",
                "port": "out"
              },
              "target": {
                "block": "3aa5743f-5065-4847-a53f-fb7319531ce8",
                "port": "ea761b76-2554-46fc-9436-991ee3fd292a"
              }
            },
            {
              "source": {
                "block": "f7f8fbf8-4b48-469a-9f57-425e689b3369",
                "port": "19c8f68d-5022-487f-9ab0-f0a3cd58bead"
              },
              "target": {
                "block": "8dafbca8-542c-47aa-8038-475339d38665",
                "port": "in"
              }
            }
          ]
        }
      }
    },
    "faca1a3f2c3124f5fa40f6be960575788a8a49b8": {
      "package": {
        "name": "SB_RGBA_DRV",
        "version": "0.1",
        "description": "iCE40 UltraPlus RGB driver.",
        "author": "Juan Manuel Rico",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "b15672d8-2cc0-4f2e-a5c6-94de78659ccf",
              "type": "basic.input",
              "data": {
                "name": "power_up",
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
                "name": "BLUE"
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
                "name": "RED"
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
                "name": "GREEN"
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
                "value": "1'b0",
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
                "value": "6'b000000",
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
                "value": "6'b000000",
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
                "value": "6'b000000",
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
      }
    },
    "c4dd08263a85a91ba53e2ae2b38de344c5efcb52": {
      "package": {
        "name": "Bit 0",
        "version": "1.0.0",
        "description": "Assign 0 to the output wire",
        "author": "Jesús Arroyo",
        "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%2247.303%22%20height=%2227.648%22%20viewBox=%220%200%2044.346456%2025.919999%22%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22325.37%22%20y=%22315.373%22%20font-weight=%22400%22%20font-size=%2212.669%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20transform=%22translate(-307.01%20-298.51)%22%3E%3Ctspan%20x=%22325.37%22%20y=%22315.373%22%20style=%22-inkscape-font-specification:'Courier%2010%20Pitch'%22%20font-family=%22Courier%2010%20Pitch%22%3E0%3C/tspan%3E%3C/text%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "19c8f68d-5022-487f-9ab0-f0a3cd58bead",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 608,
                "y": 192
              }
            },
            {
              "id": "b959fb96-ac67-4aea-90b3-ed35a4c17bf5",
              "type": "basic.code",
              "data": {
                "code": "// Bit 0\n\nassign v = 1'b0;",
                "params": [],
                "ports": {
                  "in": [],
                  "out": [
                    {
                      "name": "v"
                    }
                  ]
                }
              },
              "position": {
                "x": 96,
                "y": 96
              },
              "size": {
                "width": 384,
                "height": 256
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "b959fb96-ac67-4aea-90b3-ed35a4c17bf5",
                "port": "v"
              },
              "target": {
                "block": "19c8f68d-5022-487f-9ab0-f0a3cd58bead",
                "port": "in"
              }
            }
          ]
        }
      }
    },
    "49bbffdd8923fd315c8784617f34fb53643f55e2": {
      "package": {
        "name": "PWM_GENERATOR",
        "version": "0.1",
        "description": "PWM generator.",
        "author": "Juan Manuel Rico",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "1d736c39-4508-4892-a588-95c481288c3f",
              "type": "basic.output",
              "data": {
                "name": "pwm_0"
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
                "name": "pwm_1"
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
                "name": "pwm_2"
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
      }
    },
    "c83dcd1d9ab420d911df81b3dfae04681559c623": {
      "package": {
        "name": "Bit 1",
        "version": "1.0.0",
        "description": "Assign 1 to the output wire",
        "author": "Jesús Arroyo",
        "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%2247.303%22%20height=%2227.648%22%20viewBox=%220%200%2044.346456%2025.919999%22%3E%3Ctext%20style=%22line-height:125%25%22%20x=%22325.218%22%20y=%22315.455%22%20font-weight=%22400%22%20font-size=%2212.669%22%20font-family=%22sans-serif%22%20letter-spacing=%220%22%20word-spacing=%220%22%20transform=%22translate(-307.01%20-298.51)%22%3E%3Ctspan%20x=%22325.218%22%20y=%22315.455%22%20style=%22-inkscape-font-specification:'Courier%2010%20Pitch'%22%20font-family=%22Courier%2010%20Pitch%22%3E1%3C/tspan%3E%3C/text%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "19c8f68d-5022-487f-9ab0-f0a3cd58bead",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 608,
                "y": 192
              }
            },
            {
              "id": "b959fb96-ac67-4aea-90b3-ed35a4c17bf5",
              "type": "basic.code",
              "data": {
                "code": "// Bit 1\n\nassign v = 1'b1;",
                "params": [],
                "ports": {
                  "in": [],
                  "out": [
                    {
                      "name": "v"
                    }
                  ]
                }
              },
              "position": {
                "x": 96,
                "y": 96
              },
              "size": {
                "width": 384,
                "height": 256
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "b959fb96-ac67-4aea-90b3-ed35a4c17bf5",
                "port": "v"
              },
              "target": {
                "block": "19c8f68d-5022-487f-9ab0-f0a3cd58bead",
                "port": "in"
              }
            }
          ]
        }
      }
    },
    "2935c74667d5b53536ec18b0cf19b1caeec60a84": {
      "package": {
        "name": "CLK_BUFFERING",
        "version": "0.1",
        "description": "System clock buffering.",
        "author": "Juan Manuel Rico",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "ea761b76-2554-46fc-9436-991ee3fd292a",
              "type": "basic.input",
              "data": {
                "name": "clk_i",
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
                "name": "clk_o"
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
      }
    }
  }
}