# watt_pwner
Multitool for Wattpad written in the Lua scripting language.

![2022-07-05_04-15](https://user-images.githubusercontent.com/108309124/177242523-d66be79a-ee28-45e6-a92b-0e47f0c780bd.png)
## Installation

### Windows
1. Clone the watt_pwner repository whichever way you prefer.
2. Run the `windows_install.bat` batch script and wait for it to finish.
3. Run `windows_run.bat` to launch watt_pwner

### Linux, macOS and Unix-like
1. Clone the watt_pwner repository whichever way you prefer.
2. Open a terminal and navigate to the directory you have cloned the repository into.
3. Run `chmod 755 linux_install.sh` to give the bash script execute permissions
4. Run the bash script (`./linux_install.sh`)
5. Run watt_pwner by running `./luvit wattpwner.lua`

### Manual Installation
1. Install [Luvit](https://luvit.io)
2. Install the following dependencies using `lit`

   • creationix/coro-http
   
   • luvit/json
   
   • luvit/secure-socket
  
3. Clone the watt_pwner repository into the folder where you installed luvit
4. Run `wattpwner.lua` using `luvit`
