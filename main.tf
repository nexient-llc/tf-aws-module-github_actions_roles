// Copyright 2022 Nexient LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        for repo in var.github_repos : "repo:${var.github_org}/${repo}:*"
      ]
    }

    dynamic "condition" {
      for_each = var.conditions

      content {
        test     = condition.test
        variable = condition.variable
        values   = condition.values
      }
    }
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = var.oidc_url
  client_id_list  = var.client_id_list
  thumbprint_list = var.thumbprint_list
  tags = {
    terraform = "true"
  }
}

resource "aws_iam_role" "github" {
  name                  = var.iam_role_name
  description           = var.iam_role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = var.max_session_duration
  path                  = var.iam_role_path
  force_detach_policies = true
  tags = {
    terraform = "true"
  }
}

resource "aws_iam_policy_attachment" "policy" {
  for_each = var.policy_arns

  name       = each.key
  roles      = [aws_iam_role.github.id]
  policy_arn = each.value

}
