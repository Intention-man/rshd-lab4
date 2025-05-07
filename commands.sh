# Установка VirtualBox
brew install --cask virtualbox virtualbox-extension-pack
# Скачивание Ubuntu Server (AMD64)
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova
# Импорт образа
VBoxManage import jammy-server-cloudimg-amd64.ova --vsys 0 --vmname "Ubuntu_AMD" --ostype "Ubuntu_64"
# Настройка параметров ВМ
VBoxManage modifyvm "Ubuntu_AMD" \
  --memory 4096 \
  --cpus 2 \
  --nic1 nat \
  --natpf1 "ssh,tcp,,2222,,22" \
  --audio-driver none \
  --usb off \
  --graphicscontroller vmsvga
# Создаем динамический диск
VBoxManage createmedium disk --filename ~/VirtualBox\ VMs/Ubuntu_AMD/disk.vdi --size 20000
# Создаем контроллер SATA
VBoxManage storagectl "Ubuntu_AMD" \
  --name "SATA" \
  --add sata \
  --controller IntelAhci \
  --portcount 1
# Подключаем диск
VBoxManage storageattach "Ubuntu_AMD" \
  --storagectl "SATA" \
  --port 0 \
  --device 0 \
  --type hdd \
  --medium ~/VirtualBox\ VMs/Ubuntu_AMD/disk.vdi

# ------------------------------------------------------------

VBoxManage unregistervm "Ubuntu_AMD" --delete
rm -rf ~/"VirtualBox VMs"/Ubuntu_AMD

VBoxManage import jammy-server-cloudimg-amd64.ova \
  --vsys 0 \
  --vmname "Ubuntu_AMD" \
  --ostype "Ubuntu_64" \
  --eula accept \
  --options "keepallmacs" \
  --vsys 0 --unit 10 --disk ~/"VirtualBox VMs"/Ubuntu_AMD/disk.vdi

VBoxManage modifyvm "Ubuntu_AMD" \
  --memory 4096 \
  --cpus 2 \
  --nic1 nat \
  --natpf1 "ssh,tcp,,2222,,22" \
  --audio-driver none \
  --usb off \
  --graphicscontroller vmsvga \
  --boot1 disk \
  --boot2 none \
  --boot3 none \
  --boot4 none

VBoxManage modifyvm "Ubuntu_AMD" --uart1 0x3F8 4 --uartmode1 server /tmp/ubuntu-serial



# -----------------------------------------------------------


# Удаляем проблемную ВМ
VBoxManage unregistervm "Ubuntu_AMD" --delete
rm -rf ~/"VirtualBox VMs/Ubuntu_AMD"

# Создаем новую ВМ с чистого листа
VBoxManage createvm --name "Ubuntu_AMD" --ostype "Ubuntu_64" --register --basefolder ~/"VirtualBox VMs"

VBoxManage modifyvm "Ubuntu_AMD" \
  --memory 4096 \
  --cpus 2 \
  --firmware efi \
  --chipset ich9 \
  --nic1 nat \
  --natpf1 "ssh,tcp,,2222,,22" \
  --audio-driver none \
  --usb off \
  --graphicscontroller vmsvga \
  --boot1 disk \
  --boot2 none \
  --boot3 none

# Создаем контроллер
VBoxManage storagectl "Ubuntu_AMD" --name "SATA" --add sata --controller IntelAhci --portcount 2 --bootable on

# Создаем диск
VBoxManage createmedium --filename ~/"VirtualBox VMs/Ubuntu_AMD/disk.vdi" --size 20000 --format VDI --variant Standard

# Подключаем диск
VBoxManage storageattach "Ubuntu_AMD" --storagectl "SATA" --port 0 --device 0 --type hdd --medium ~/"VirtualBox VMs/Ubuntu_AMD/disk.vdi"

#----------------------------------------------------------------

# Полностью пересоздадим ВМ с другим подходом
VBoxManage unregistervm "Ubuntu_AMD" --delete
rm -rf ~/"VirtualBox VMs/Ubuntu_AMD"

VBoxManage createvm --name "Ubuntu_AMD" --ostype "Ubuntu_64" --register
VBoxManage modifyvm "Ubuntu_AMD" --memory 4096 --cpus 2 --nic1 nat --natpf1 "ssh,tcp,,2222,,22"
VBoxManage storagectl "Ubuntu_AMD" --name "SATA" --add sata --controller IntelAhci --portcount 1
VBoxManage createmedium disk --filename ~/"VirtualBox VMs/Ubuntu_AMD/disk.vdi" --size 20000
VBoxManage storageattach "Ubuntu_AMD" --storagectl "SATA" --port 0 --device 0 --type hdd --medium ~/"VirtualBox VMs/Ubuntu_AMD/disk.vdi"

# -------------------------

VBoxManage modifyvm "Ubuntu_AMD" --natpf1 delete "ssh"

VBoxManage modifyvm "Ubuntu_AMD" \
  --memory 4096 \
  --cpus 2 \
  --firmware bios \
  --chipset piix3 \
  --nic1 nat \
  --natpf1 "ssh,tcp,,2222,,22" \
  --audio-driver none \
  --usb off \
  --graphicscontroller vmsvga \
  --boot1 disk \
  --boot2 none \
  --boot3 none \
  --pae off \
  --rtcuseutc on

VBoxManage showvminfo "Ubuntu_AMD" --machinereadable | grep storage

VBoxManage storagectl "Ubuntu_AMD" --name "SATA" --hostiocache on


# -----------------------------------