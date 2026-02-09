# Using VSCode
1. Download and install VSCode (https://code.visualstudio.com/).
2. Enable setting “remote.SSH.showLoginTerminal”
3. Install the Remote - SSH plugin (https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh).
4. Navigate to the left, click the Remote Explore icon, then click the plus (+) icon on the right to add new remote machines.
5. The command, for example, should be for caddy machine (but remember, you can't run any simulations on caddy machine; you will need FarmShare for that)
```
# VSCode SSH to caddy machine [for coding only]
ssh <YOUR SUID>@caddy.best.stanford.edu 
 
# or

# SSH to Farmshare [for coding and running simulations]
ssh <YOUR SUID>@login.farmshare.stanford.edu 
```
6. Enter the password in the terminal and follow the instructions. During this, you may be asked to provide 2-factor authentication.
7. Once it is set up, you can edit files using VSCode.
