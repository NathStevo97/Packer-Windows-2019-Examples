# This file was autogenerated by the BETA 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/from-1.5/variables#type-constraints for more info.
variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "disk_size" {
  type    = string
  default = "40960"
}

variable "iso_checksum" {
  type    = string
  default = "3022424f777b66a698047ba1c37812026b9714c5"
}

variable "iso_url" {
  type    = string
  default = "https://software-download.microsoft.com/download/pr/17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso"
}

variable "memsize" {
  type    = string
  default = "2048"
}

variable "numvcpus" {
  type    = string
  default = "2"
}

variable "vm_name" {
  type    = string
  default = "Win2019_17763"
}

variable "winrm_password" {
  type    = string
  default = "packer"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/from-1.5/blocks/source
# could not parse template for following block: "template: hcl2_upgrade:15:42: executing \"hcl2_upgrade\" at <.Name>: can't evaluate field Name in type struct { HTTPIP string; HTTPPort string }"

source "virtualbox-iso" "autogenerated_1" {
  boot_command         = ["<spacebar>"]
  boot_wait            = "{{user `boot_wait`}}"
  communicator         = "winrm"
  disk_size            = "{{user `disk_size`}}"
  guest_additions_mode = "disable"
  guest_os_type        = "Windows2016_64"
  headless             = false
  iso_checksum         = "{{user `iso_checksum`}}"
  iso_interface        = "sata"
  iso_url              = "{{user `iso_url`}}"
  shutdown_command     = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout     = "30m"
  vboxmanage           = [["modifyvm", "{{.Name}}", "--memory", "{{user `memsize`}}"], ["modifyvm", "{{.Name}}", "--cpus", "{{user `numvcpus`}}"], ["modifyvm", "{{.Name}}", "--firmware", "EFI"], ["storageattach", "{{.Name}}", "--storagectl", "SATA Controller", "--type", "dvddrive", "--port", "3", "--medium", "./scripts/uefi/gui/autounattend.iso"]]
  vm_name              = "{{user `vm_name`}}"
  winrm_insecure       = true
  winrm_password       = "{{user `winrm_password`}}"
  winrm_timeout        = "4h"
  winrm_use_ssl        = true
  winrm_username       = "{{user `winrm_username`}}"
}

source "vmware-iso" "autogenerated_2" {
  boot_command     = ["<spacebar>"]
  boot_wait        = "${var.boot_wait}"
  communicator     = "winrm"
  disk_size        = "${var.disk_size}"
  disk_type_id     = "0"
  floppy_files     = ["scripts/uefi/gui/autounattend.xml"]
  guest_os_type    = "windows9srv-64"
  headless         = false
  http_directory   = "http"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  shutdown_command = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout = "30m"
  skip_compaction  = false
  vm_name          = "${var.vm_name}"
  vmx_data = {
    firmware            = "efi"
    memsize             = "${var.memsize}"
    numvcpus            = "${var.numvcpus}"
    "scsi0.virtualDev"  = "lsisas1068"
    "virtualHW.version" = "14"
  }
  winrm_insecure = true
  winrm_password = "${var.winrm_password}"
  winrm_timeout  = "4h"
  winrm_use_ssl  = true
  winrm_username = "${var.winrm_username}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/from-1.5/blocks/build
build {
  sources = ["source.virtualbox-iso.autogenerated_1", "source.vmware-iso.autogenerated_2"]

  provisioner "powershell" {
    only    = ["vmware-iso"]
    scripts = ["scripts/vmware-tools.ps1"]
  }
  provisioner "powershell" {
    only    = ["virtualbox-iso"]
    scripts = ["scripts/virtualbox-guest-additions.ps1"]
  }
  provisioner "powershell" {
    scripts = ["scripts/setup.ps1"]
  }
  provisioner "windows-restart" {
    restart_timeout = "30m"
  }
  provisioner "powershell" {
    scripts = ["scripts/win-update.ps1"]
  }
  provisioner "windows-restart" {
    restart_timeout = "30m"
  }
  provisioner "powershell" {
    scripts = ["scripts/win-update.ps1"]
  }
  provisioner "windows-restart" {
    restart_timeout = "30m"
  }
  provisioner "powershell" {
    scripts = ["scripts/cleanup.ps1"]
  }
}
