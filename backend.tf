terraform {
    backend "s3" {
        bucket = "terraforminternals3"
        key    = "terraform.tfstate"
    }
}