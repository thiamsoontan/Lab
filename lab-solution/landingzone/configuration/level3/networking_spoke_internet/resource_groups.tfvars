
resource_groups = {
  # Default to var.global_settings.default_region. You can overwrite it by setting the attribute region = "region2"
  networking_spoke_re1 = {
    name   = "networking-spoke-internet-re1"

    tags = { 
      purpose = "internet networking hub resource group" 
      project-code = "ignite" 
      env = "sandpit" 
      zone = "internet"        
    }  
  }

}


