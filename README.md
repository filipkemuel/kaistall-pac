# kaistall-pac
My Personal Pacman Repo. 
With packages built from AUR that I need on my machines.

[Packages in the repo](Packages.md)

## Setup 

1) First add the gpg-key
   ```Shell
   pacman-key --recv-keys 27481B6EA21FDC55B08746109CE4184AEB8CAD30
   ```
   ```Shell
   pacman-key --lsign-key 27481B6EA21FDC55B08746109CE4184AEB8CAD30
   ```

2) add the repo to /etc/pacman.conf
   ```INI
   [kaistall-pac]
   Server = https://filipkemuel.github.io/$repo/$arch
   ```
   Do ad it under the official repo's so that it has lower priority than the official repo's.

3) Update the pacman repo caches
   ```Shell
   pacman -Sy
   ```
