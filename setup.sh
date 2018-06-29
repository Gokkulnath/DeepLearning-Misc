#!/usr/bin/env bash

sudo apt update
sudo apt install unzip -y
sudo apt -y autoremove
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
mkdir downloads
cd ~/downloads/
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y
wget http://files.fast.ai/files/cudnn-9.1-linux-x64-v7.tgz
tar xf cudnn-9.1-linux-x64-v7.tgz
sudo cp cuda/include/*.* /usr/local/cuda/include/
sudo cp cuda/lib64/*.* /usr/local/cuda/lib64/
wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
bash Anaconda3-5.0.1-Linux-x86_64.sh -b
echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
source ~/.bashrc

cd
git clone https://github.com/fastai/fastai.git
cd fastai/
conda env create -f environment.yml
wget http://files.fast.ai/models/weights.tgz
tar -xvf weights.tgz
rm weights.tgz

# clean up of Downloaded Files
cd 
rm -rf downloads


# Jupyter Notebook setup 
jupyter notebook --generate-config
echo "c = get_config()  # Get the config object.
c.IPKernelApp.pylab = 'inline'  # in-line figure when using Matplotlib
c.NotebookApp.ip = '*'  # Serve notebooks locally.
c.NotebookApp.open_browser = False  # Do not open a browser window by default when using notebooks." >> $HOME/.jupyter/jupyter_notebook_config.py
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py

pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix


# Crontab to start jupyter on Start
( crontab -l ; echo "@reboot cd /home/ubuntu; source ~/.bashrc;  /home/ubuntu/anaconda3/bin/jupyter notebook" ) | crontab -

# Setup Kernel in jupyter
source activate fastai
pip install ipykernel
python -m ipykernel install --user --name fastai --display-name "fastai"


echo
echo ---
echo - Rebooting you instance to et your environment ready
echo ---
sudo reboot
