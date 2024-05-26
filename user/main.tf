module "vpc" {
    source ="../module"
    public_cidr_block = var.public_cidr_block
    tags = var.tags
    private_cidr_block = var.private_cidr_block
    database_cidr_block = var.database_cidr_block
}