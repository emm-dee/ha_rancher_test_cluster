# Not much here. Check elsewhere

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

terraform {
    required_version = ">= 0.11.8"
}
