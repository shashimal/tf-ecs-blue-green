{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Resource":[
        "arn:aws:logs:*:${aws_account_id}:log-group:/aws/codebuild/*:*"
      ],
      "Action":[
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect":"Allow",
      "Resource":[
        "arn:aws:s3:::${artifact_bucket}",
        "arn:aws:s3:::${artifact_bucket}/*"
      ],
      "Action":[
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Condition": {
        "StringEquals": {
          "s3:ResourceAccount": "${aws_account_id}"
        }
      }
    },
    {
      "Effect":"Allow",
      "Resource":[
        "arn:aws:codecommit:*:${aws_account_id}:*"
      ],
      "Action":[
        "codecommit:GitPull"
      ]
    },
    {
      "Effect":"Allow",
      "Action":[
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases"
      ],
      "Resource":[
        "arn:aws:codebuild:*:${aws_account_id}:report-group/*"
      ]
    },
    {
      "Effect":"Allow",
      "Resource": "*",
      "Action":[
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:StartImageScan",
        "ecr:ListTagsForResource",
        "ecr:UploadLayerPart",
        "ecr:ListImages",
        "ecr:CompleteLayerUpload",
        "ecr:TagResource",
        "ecr:DescribeRepositories",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetLifecyclePolicy",
        "ecr:DescribeImageScanFindings",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken",
        "ecr:PutImage",
        "ecr:UntagResource",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:StartLifecyclePolicyPreview",
        "ecr:InitiateLayerUpload",
        "ecr:GetRepositoryPolicy"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "arn:aws:ec2:*:${aws_account_id}:network-interface/*",
      "Condition": {
        "StringEquals": {
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:PutLifecycleEventHookExecutionStatus"
      ],
      "Resource": "*"
    }
  ]
}
