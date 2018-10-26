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
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
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

conda create -n keras-tf python=3.6 -y
source ~/.bashrc
source activate keras-tf
conda install -c defaults tensorflow-gpu  -y
pip install -q keras

pip install opencv-python

#Setup kernel on Jupyter
pip install ipykernel
python -m ipykernel install --user --name keras-tf --display-name "keras-tf"

# Alias Setup 
cd 
echo 'alias keras-tf="source activate keras-tf"'>.bashrc
source .bashrc


# Clean up 
rm -rf ~/downloads
echo
echo ---
echo - Setup complete. Rebooting Now 
echo ---
sudo reboot

