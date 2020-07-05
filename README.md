# ws-setup
ws-setup is a collection of scripts and instructions to configure wsl2 et tools on my workstation -- **ubuntu** (and debian for this matter).

### Install WSL2 (on Windows)
- From the start menu **search** for and **select** `Turn Windows features on or off`
- **Tick** `Windows Subsystem for Linux option` and **click** *ok*
- **Reboot** and on *bootup*, **go** to `BIOS` by **pressing** *del* and **enable** `virtualization technology` -- [more help](http://tinyurl.com/yatbhr4u)
- Once BIOS is configured, **go** to `Powershell` as Administrator and run:
    > Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform  
    > Restart-Computer
- Once the machine is back up and running, **run** command below on `Powershell`:
    > wsl --set-default-version 2
- Go to Microsoft store and **download ubuntu** (as of this writing *20.04* is available but I installed *18.04*)

### WSL2 Setup with Ansible (on Linux)
#### Pre-req
- **Configure ssh** -- while not strictly necessary (besides helping with `.ssh` dir creation), it avoids writing an ansible script that repeatedly prompts for a *passphrase* since ansible `private prompts` cannot be induced *conditionally*
    > ssh-keygen -t rsa -b 4096 -C "<your_email>"
#### Main
- **Install** *pip* and *ansible* (used version *2.9.9* as of this writing)
    > sudo apt update && sudo apt install -y python3-pip && pip3 install ansible==<your_version>
- **Download** *main.yml* and **run** `ansible-playbook`
    > wget https://raw.githubusercontent.com/ralphie02/ws-setup/master/main.yml && ansible-playbook main.yml -e "git_name=<your_name> git_email=<your_email>" -K
### Windows Setup (on Windows)
#### Pre-req (as of 2020/06/09; might be unnecessary in the future)
- **Signup** for the [insider program](https://forms.office.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR-NSOqDz219PqoOqk5qxQEZUNFkzQVcxMkJXWEFCUkE4WThQWUJMVlA1Ty4u)
- **Download/update** [App Installer](https://www.microsoft.com/en-ca/p/app-installer/9nblggh4nns1?activetab=pivot:overviewtab)
#### Main
- **Run** the script in `Powershell` as *Administrator* -- installations will be using `winget` which, from my understanding, will be the best tool *in the future* for package management. Installations might fail if Windows Setting in `Apps & features` do not allow installing apps *outside* of `Microsoft Store`
    > iex((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ralphie02/ws-setup/master/setup.ps1'))

### Extra
#### GPG ([reference](https://docs.gitlab.com/ee/user/project/repository/gpg_signed_commits/))
- Generate the key then follow prompts:
    > gpg --full-gen-key
- Get priv gpg key: 
    > gpg --list-secret-keys --keyid-format LONG <your_email>
    ```
    sec   rsa4096/30F2B65B9246B6CA 2017-08-18 [SC]
          D5E4F29F3275DC0CDA8FFC8730F2B65B9246B6CA
    uid                   [ultimate] Mr. Robot <your_email>
    ssb   rsa4096/B7ABC0813E4028C0 2017-08-18 [E]
    ```
- Get pub gpg key (value taken from *sec* above):
    > gpg --armor --export 30F2B65B9246B6CA
#### Powertoys ([reference](https://github.com/microsoft/PowerToys#installing-and-running-microsoft-powertoys))
- Install .Net ([reference](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script#recommended-version))
    > iex((New-Object System.Net.WebClient).DownloadString('https://dot.net/v1/dotnet-install.ps1'))
- Run winget
    > winget install powertoys
