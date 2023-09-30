#https://registry.terraform.io/modules/hashicorp/subnets/cidr/latest
module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  #3    = /19   Avail 8187
  #4    = /20   Avail 4091
  #5    = /21   Avail 2043
  #6    = /22   Avail 1019
  #7    = /23   Avail 507
  #8    = /24   Avail 251
  #9    = /25   Avail 123
  #10   = /26   Avail 59
  #11   = /27   Avail 27
  #12   = /28   Avail 11
  #13   = /29   Avail 3   Smallest Size

  base_cidr_block = "10.200.0.0/16"
  networks = [
    {
      name     = "Subnet1"
      new_bits = 3
    },
    {
      name     = "Subnet2"
      new_bits = 4
    },
    {
      name     = "Subnet3"
      new_bits = 5
    },
    {
      name     = "Subnet4"
      new_bits = 6
    },
    {
      name     = "Subnet5"
      new_bits = 7
    },
    {
      name     = "Subnet6"
      new_bits = 8
    },
    {
      name     = "Subnet7"
      new_bits = 9
    },
    {
      name     = "Subnet8"
      new_bits = 10
    },
    {
      name     = "Subnet9"
      new_bits = 11
    },
    {
      name     = "Subnet10"
      new_bits = 12
    },
    {
      name     = "Subnet11"
      new_bits = 13
    },
  ]
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.environment}${var.application}${var.iteration}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [module.subnet_addrs.base_cidr_block]
  tags                = var.tags

  dynamic "subnet" {
    for_each = module.subnet_addrs.network_cidr_blocks
    content {
      name           = subnet.key
      address_prefix = subnet.value
    }
  }
}