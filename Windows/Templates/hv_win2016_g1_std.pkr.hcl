variable "iso_checksum" {
  type    = string
  default = "70721288bbcdfe3239d8f8c0fae55f1f"
}

variable "iso_url" {
  type    = string
  default = "../../../ISOs/Windows Server/2016/Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO"
}

source "hyperv-iso" "win2016-STD" {
  communicator         = "winrm"
  cpus                 = 1
  disk_size            = 40960
  floppy_files         = ["./Files/bios/win2016/Std/autounattend.xml", "./Files/scripts/winrmConfig.ps1"]
  guest_additions_mode = "disable"
  iso_checksum         = "md5:${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = 2048
  shutdown_timeout     = "15m"
  switch_name          = "Default Switch"
  vm_name              = "2016min-std"
  winrm_password       = "packer"
  winrm_timeout        = "12h"
  winrm_username       = "Administrator"
}

build {
  sources = ["source.hyperv-iso.win2016-STD"]

  provisioner "powershell" {
    elevated_password = "packer"
    elevated_user     = "Administrator"
    scripts           = ["./Files/scripts/vmware-tools.ps1"]
  }

  provisioner "powershell" {
    elevated_password = "packer"
    elevated_user     = "Administrator"
    scripts           = ["./Files/scripts/setup.ps1"]
  }
  
  /*  
  provisioner "powershell" {
    elevated_password = "packer"
    elevated_user     = "Administrator"
    script            = "./Files/scripts/win-update.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "15m"
  }
  provisioner "powershell" {
    scripts = ["../../../../Testing/illumio_install.ps1"]
  }
  */
}