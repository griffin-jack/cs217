# This script clones the AWS FPGA repository from GitHub and setups the environment for F2 FPGA development.

# Clone the AWS FPGA repository
cd ~/
git clone https://github.com/aws/aws-fpga.git

# Download git-lfs if not already installed
sudo apt-get install -y git-lfs

# Install jq if not already installed
sudo apt install -y jq
sudo apt install -y python3-pip
sudo apt install -y python3.8-venv

# Source Hardware Development Kit (HDK) environment
cd ~/aws-fpga
source hdk_setup.sh
echo ""
echo "Download any other dependencies if you see any errors after sourcing the hdk_setup.sh script."
echo ""

# Source Software Development Kit (SDK) environment
cd ~/aws-fpga
source sdk_setup.sh
echo ""
echo "Download any other dependencies if you see any errors after sourcing the sdk_setup.sh script."
echo ""
