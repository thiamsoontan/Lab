landingzone = {
  backend_type        = "azurerm"
  global_settings_key = "launchpad"
  level               = "level3"
  key                 = "networking_spoke_internet" 
  tfstates = {
    launchpad = {
      level   = "lower"
      tfstate = "caf_launchpad.tfstate" # set to launchpad tfstate name
    }  
  }
}
