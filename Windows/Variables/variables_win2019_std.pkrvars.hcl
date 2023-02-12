boot_command = ["<tab><wait><enter><wait>", "a<wait>a<wait>a<wait>a<wait>a<wait>a<wait>"]
boot_wait = "5s"
boot_wait_hyperv = "120s"
disk_size = "40960"
floppy_files = ["./Files/bios/win2019/Std/autounattend.xml", "./Files/scripts/winrmConfig.ps1"]
guest_os_type_virtualbox = "Windows2019_64"
guest_os_type_vmware = "windows9srv-64"
headless = true
http_directory = "../http/Agent_Installations"
iso_checksum = "3022424f777b66a698047ba1c37812026b9714c5"
iso_path = "../../ISOs/Windows Server/2019/17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso"
iso_url = "https://software-download.microsoft.com/download/pr/17763.737.190906-2324.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us_1.iso"
memsize = "4096"
numvcpus = "2"
output_directory = "output-windows-2019-DC"
secondary_iso_image = "./Files/bios/win2019/Std/secondary.iso"
switch_name = "Default Switch" #change this to whatever your switch is! Look in Hyper-V Manager to find it!
upgrade_timeout = ""
vlan_id = ""
vm_name = "packer-windows2019-std"
winrm_password = "packer"
winrm_timeout = "4h"
winrm_username = "Administrator"