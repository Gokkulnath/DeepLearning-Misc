
#!/usr/bin/env bash

# Script to Create Fastai V1 Environment 

# Get Latest OS Updates and Clean the Older Version
sudo apt update
sudo apt install unzip  git -y
sudo apt -y autoremove


# Add CUDA Repository
sudo apt update
mkdir downloads
cd ~/downloads/
sudo add-apt-repository ppa:graphics-drivers/ppa -y
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y

# Get CUDNN 9.1 and Install it
wget http://files.fast.ai/files/cudnn-9.1-linux-x64-v7.tgz
tar xf cudnn-9.1-linux-x64-v7.tgz
sudo cp cuda/include/*.* /usr/local/cuda/include/
sudo cp cuda/lib64/*.* /usr/local/cuda/lib64/

# Get Anaconda and Install 
wget https://repo.continuum.io/archive/Anaconda3-5.3.0-Linux-x86_64.sh # Might Need update Periodically Last Updated : 18-09-2018
bash Anaconda3-5.3.0-Linux-x86_64.sh -b
echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
source ~/.bashrc


# Jupyter Notebook setup 
jupyter notebook --generate-config
echo "c = get_config()  # Get the config object.
c.IPKernelApp.pylab = 'inline'  # in-line figure when using Matplotlib
c.NotebookApp.ip = '*'  # Serve notebooks locally.
c.NotebookApp.open_browser = False  # Do not open a browser window by default when using notebooks." >> $HOME/.jupyter/jupyter_notebook_config.py
echo "Enter Password for Jupyter Notebook Login"
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py

# Enable Jupyter Notebook Widgets
pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix


# Crontab to start jupyter on Start
(crontab -l ; echo "@reboot cd $HOME; source ~/.bashrc;  $HOME/anaconda3/bin/jupyter notebook") | crontab -



#Fastai Version Dev Install
conda create -n fastai python=3.7 -y
source activate fastai
conda install -c pytorch pytorch-nightly cuda92 -y
conda install -c fastai torchvision-nightly -y
conda install -c fastai fastai -y

# Dev Install only. Comment Below if Dev env not required
conda uninstall fastai -y
git clone https://github.com/fastai/fastai
cd fastai
tools/run-after-git-clone
pip install -e .[dev]

#CV2 
pip install opencv-python

#Setup kernel on Jupyter
pip install ipykernel
python -m ipykernel install --user --name fastai --display-name "fastai"

# Clean up 
rm -rf ~/downloads
echo
echo ---
echo - Rebooting you instance to et your environment ready
echo ---
sudo reboot

# TODO
# Add Alias Automatically
cd ~
echo 'alias fastai="source activate fastai"'>.bashrc
#echo 'alias fastai="source activate fastai"'>.bashrc
source .bashrc

# Put Kaggle Json Automatically
