variable "iso_checksum" {
  type    = string
  default = "3022424f777b66a698047ba1c37812026b9714c5"
}

variable "iso_url" {
  type    = string
  default = "../../../ISOs/Windows Server/2019/17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso"
}

source "hyperv-iso" "win2019-DC" {
  communicator = "winrm"
  cpus         = 1
  disk_size    = 40960
  floppy_files         = ["./HyperV-ISO/Generation 1/extra/files/gen1-2019/dc/autounattend.xml", "./HyperV-ISO/Generation 1/extra/scripts/winrm.ps1"]
  #floppy_files         = ["./Files/bios/win2019/DC/autounattend.xml"]
  guest_additions_mode = "disable"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = 2048
  shutdown_timeout     = "15m"
  switch_name          = "Default Switch"
  vm_name              = "2019min-DC"
  winrm_password       = "packer"
  winrm_timeout        = "12h"
  winrm_username       = "Administrator"
}

build {
  sources = ["source.hyperv-iso.win2019-DC"]

  provisioner "powershell" {
    elevated_password = "packer"
    elevated_user     = "Administrator"
    script            = "./Files/scripts/win-update.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "15m"
  }
  #provisioner "powershell" {
  #  scripts = ["../../../../Testing/illumio_install.ps1"]
  #}
}