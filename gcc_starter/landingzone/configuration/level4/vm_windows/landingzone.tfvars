landingzone = {
  backend_type        = "azurerm"
  level               = "level4"
  key                 = "vm_windows"    
  global_settings_key = "networking_spoke" 
  tfstates = {
    networking_spoke = {
      level   = "lower"
      tfstate = "networking_spoke_internet.tfstate"
    }    
  }
}

