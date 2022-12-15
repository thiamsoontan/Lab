resource_groups = {
  vm_region1 = {
    name = "vm-windows"
    region = "region1"      
    tags = { 
      purpose = "vm server resource group" 
      project-code = "ignite" 
      env = "sandpit" 
      zone = "internet"    
    }    
  }
}

