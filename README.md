
Based of the fully automated development environment from TechDufus.  
<a href="https://github.com/TechDufus/dotfiles">https://github.com/TechDufus/dotfiles</a>  

My build is built more towards configuring Debian 13 with aplications that I use.  
Check out TechDufus for a more comprehensive guide on how all of this works, the instructions below is much abridged.  

### Update system and install dependencies  

```
sudo apt update && sudo apt-get upgrade -y
sudo apt install git curl
```

### Dont not git clone, use command below

## Usage

### 1. Create vault.secret

Create ~/.ansible-vault/ and copy current vault.secret file to location.  

Encrypting items using vault.secret:  

```bash
ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret "mynewsecret" --name "MY_SECRET_VAR"
cat myfile.conf | ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret --stdin-name "myfile"
```

### 2. Install

This playbook includes a custom shell script located at `bin/dotfiles`. This script is added to your $PATH after installation and can be run multiple times while making sure any Ansible dependencies are installed and updated.

This shell script is also used to initialize your environment after installing `Debian` and performing a full system upgrade as mentioned above.

> NOTE: You must follow required steps before running this command or things may become unusable until fixed.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lupusmagist/dotfiles/main/bin/dotfiles)"
```

If you want to run only a specific role, you can specify the following bash command:

```bash
curl -fsSL https://raw.githubusercontent.com/lupusmagist/dotfiles/main/bin/dotfiles | bash -s -- --tags comma,seperated,tags
```

Run the command below with the git tag. It should install all the needed components, but it will fail.  

```bash
curl -fsSL https://raw.githubusercontent.com/lupusmagist/dotfiles/main/bin/dotfiles | bash -s -- --tags git
```

Once it has failed, edit the group_vars/all.yml and replace the ansible_become_pass section with new section generated using:  

```bash
ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret 'your_sudo_password' --name 'ansible_become_pass'
```

Now you can cd into .dotfiles and install using instructions below.  
A reboot might be required at this point.  

```bash
./bin/dotfiles -t tmux -vvv
```

### Update

To update your environment run the `dotfiles` command in your shell:

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
