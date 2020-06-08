# ws-setup

Install and configure WSL 2 (installed ubuntu 18.04 for icedtea plugin)


WSL:

ssh-keygen -t rsa -b 4096 -C "<email>"
- type passphrase if needed

gpg --full-gen-key
- get priv gpg key: 
  gpg --list-secret-keys --keyid-format LONG <your_email>
    sec   rsa4096/30F2B65B9246B6CA 2017-08-18 [SC]
          D5E4F29F3275DC0CDA8FFC8730F2B65B9246B6CA
    uid                   [ultimate] Mr. Robot <your_email>
    ssb   rsa4096/B7ABC0813E4028C0 2017-08-18 [E]
- get pub gpg key:
  gpg --armor --export 30F2B65B9246B6CA


sudo apt update && sudo apt install -y python3-pip && pip3 install ansible==2.9.9

wget https://raw.githubusercontent.com/ralphie02/ws-setup/master/main.yml

ansible-playbook main.yml -K -e "git_name=<name> git_email=<email>"


POWERSHELL:

iex((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ralphie02/ws-setup/master/setup.ps1'))
