#!/usr/bin/env bash
# Script to Create Fastai V2 Environment 
# Get Latest OS Updates and Clean the Older Version updates
sudo apt update
sudo apt install unzip  git -y
sudo apt -y autoremove
# Setup Miniconda 
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
echo 'export PATH=~/miniconda3/bin:$PATH' >> ~/.bashrc
export PATH=~/miniconda3/bin:$PATH
source ~/.bashrc
# Jupyter Notebook setup 
pip install jupyter notebook ipykernel
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
# Setup Fastai2 Environment
conda create -n fastai2 python=3.7
conda activate fastai2
git clone https://github.com/fastai/fastai2  && cd fastai2 && pip install -q -e ".[dev]"
git clone https://github.com/fastai/fastcore && cd fastcore && pip install -q -e ".[dev]"
#Setup kernel on Jupyter
pip install ipykernel
python -m ipykernel install --user --name fastai2 --display-name "fastai2"

# Add Alias Automatically
cd ~
echo 'alias fastai2="conda activate fastai2"'>.bashrc

# Clean up 
rm -rf ~/downloads
echo
echo ---
echo - Rebooting you instance to et your environment ready
echo ---
sudo reboot
