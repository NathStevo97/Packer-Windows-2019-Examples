# Build images

# Get Start Time
$startDTM = (Get-Date)

# Variables
$template_file="./templates/rhel7.pkr.hcl"
#$var_file="./variables/variables_win2016_dc.pkrvars.hcl"
$machine="RHEL 7"
$packer_log=1
$env:PACKER_LOG_PATH="packerlog-RHEL7.txt"
packer init -upgrade "./required_plugins.pkr.hcl"
#Write start time so you know how long it's been
Write-Host "Start Time: = $startDTM" -ForegroundColor Yellowa
if ((Test-Path -Path "$template_file")) {
  Write-Output "Template file found"
  Write-Output "Building: $machine"
  try {
    $env:PACKER_LOG=$packer_log
    #packer validate -var-file="$var_file" "$template_file"
    packer validate -only='vmware-iso.rhel-7' "$template_file"
  }
  catch {
    Write-Output "Packer validation failed, exiting."
    exit (-1)
  }
  try {
    $env:PACKER_LOG=$packer_log
    packer version
    #packer build --force -var-file="$var_file" "$template_file"
    packer build -only='vmware-iso.rhel-7' --force "$template_file"
  }
  catch {
    Write-Output "Packer build failed, exiting."
    exit (-1)
  }
}
else {
  Write-Output "Template or Var file not found - exiting"
  exit (-1)
}

$endDTM = (Get-Date)
Write-Host "[INFO]  - Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds" -ForegroundColor Yellow
