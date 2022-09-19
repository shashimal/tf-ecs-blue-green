[
  {
    "name": "cook",
    "image": "793209430381.dkr.ecr.us-east-1.amazonaws.com/cook-service:latest",
    "essential": true,
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ]
  }
]

