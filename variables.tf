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


variable "client_id_list" {
  description = "list of client ids"
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

variable "conditions" {
  description = "additional conditions applied to the policy"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "github_org" {
  description = "the name of the organization within github"
  type        = string
}

variable "github_repos" {
  description = "a list of github repositories for which the role works with"
  type        = list(string)
}

variable "iam_role_description" {
  description = "the description for the iam role"
  type        = string
  default     = "IAM role to enable GitHub OIDC access"
}

variable "iam_role_name" {
  description = "the name of the iam role"
  type        = string
  default     = "GitHubOIDCRole"
}

variable "iam_role_path" {
  description = "the path to the iam role"
  default     = "/"
  type        = string
}

variable "max_session_duration" {
  description = "the maximum number of miliseconds the role can be assumed for"
  type        = number
  default     = 3600
}

variable "oidc_url" {
  description = "the url to the identify provider"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "policy_arns" {
  description = "list of role policies and their names to associate with the github assume role"
  type        = map(string)
  default     = {}
}

variable "thumbprint_list" {
  description = "list of thumbprints for the open identity connect provider"
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
