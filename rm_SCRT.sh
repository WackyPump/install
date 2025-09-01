#sudo apt remove secureboot-db

sudo apt remove scrt
sudo apt purge scrt

sudo rm -rf /etc/scrt/
sudo rm -rf /usr/share/scrt/

#sudo find / -name "*scrt*" -exec rm -rf {} \;
sudo apt autoremove

rm -rf ~/.vandyke/
rm -rf ~/.config/VanDyke/

sudo dpkg -r scrt
sudo dpkg --purge scrt

echo "验证："
#验证
which scrt   
dpkg -l | grep scrt

