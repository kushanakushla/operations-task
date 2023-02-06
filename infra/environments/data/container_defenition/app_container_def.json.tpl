[
    {
      "image": "${image}",
      "cpu": 256,
      "memory": 512,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "protocol": "tcp",
          "hostPort": 3000
        }
      ]
      }
    }
]