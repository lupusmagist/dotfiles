
Based of the fully automated development environment from TechDufus.  
<a href="https://github.com/TechDufus/dotfiles">https://github.com/TechDufus/dotfiles</a>  

My build is built more towards configuring Debian 13 with aplications that I use.  
Check out TechDufus for a more comprehensive guide on how all of this works, the instructions below is much abridged.  

### Update system and install dependencies  

```
mkdir ~/.ansible-vault
sudo apt update && sudo apt-get upgrade -y
sudo apt install git curl
```

### Dont not git clone, use command below

## Usage

### 1. Create vault.secret

Copy your current vault.secret file to location.  

If you do not have a current vault.secret file create one. In the file must be one line with random chars, or a password.  
This is the secret key that ansible will use to encrypt/decrypt the passwords used in you configs.

```bash
echo 7QkxLeQXHaPMUvgNQ1FSPO0 > ~/.ansible-vault/vault.secret
```

This vault.secret can be copied to new installs.  

Next you will have to edit the group_vars/all.yml file.  
Remove the sections for: work_computer and ssh_key.  
Edit or delete the section for git_user_name.  

New keys will have to generated and copied into ansible_become_pass and git_user_email sections using:  

```bash
ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret 'your_sudo_password' --name 'ansible_become_pass'
ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret 'your_git_email_address' --name 'git_user_email'
```

### 2. Install

This playbook includes a custom shell script located at `bin/dotfiles`. This script is added to your $PATH after installation and can be run multiple times while making sure any Ansible dependencies are installed and updated.

This shell script is also used to initialize your environment after installing `Debian` and performing a full system upgrade as mentioned above.

> NOTE: You must follow required steps below before running the full system command or things may become unusable until fixed.  
Run the command below with the git tag. It should install all the needed components, but it will fail.

#### Test command

The comand below will install Ansible and try to install Git (That was already manaually installed above.)

```bash
curl -fsSL https://raw.githubusercontent.com/lupusmagist/dotfiles/main/bin/dotfiles | bash -s -- --tags git
```

The command above might fail while updating Ansible, just run it again. If it fails with a Ansible error:

```bash
cd ~/.dotfiles
./bin/dotfiles -t git -vvv
```

This will provide more detail on the failure.  
Most of the time it can be traced back to the secrets above.  

If the above command completes, you can install either all scripts or select the ones to install as sugested below.  

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lupusmagist/dotfiles/main/bin/dotfiles)"

or 

~/.dotfiles//bin/dotfiles
```

If you want to run only a specific role, you can specify the following bash command:

```bash
curl -fsSL https://raw.githubusercontent.com/lupusmagist/dotfiles/main/bin/dotfiles | bash -s -- --tags comma,seperated,tags

or 

~/.dotfiles//bin/dotfiles -t comma,seperated,tags

```

### Update

Updates happen each time the dotfiles command is run. (Even when installing specific roles).  

```bash
dotfiles
```

This will handle the following tasks:

- Verify Ansible is up-to-date
- Generate SSH keys and add to `~/.ssh/authorized_keys`
- Clone this repository locally to `~/.dotfiles`
- Verify any `ansible-galaxy` plugins are updated
- Run this playbook with the values in `~/.config/dotfiles/group_vars/all.yaml`

This `dotfiles` command is available to you after the first use of this repo, as it adds this repo's `bin` directory to your path, allowing you to call `dotfiles` from anywhere.

Any flags or arguments you pass to the `dotfiles` command are passed as-is to the `ansible-playbook` command.

For Example: Running the tmux tag with verbosity

```bash
dotfiles -t tmux -vvv
```

#### Encrypting items using vault.secret  

```bash
ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret "mynewsecret" --name "MY_SECRET_VAR"

or

cat myfile.conf | ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret --stdin-name "myfile"
```
