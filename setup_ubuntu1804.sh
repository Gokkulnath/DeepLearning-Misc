#!/usr/bin/env bash
### Script to Setup an Ubuntu Instance with Cuda and CUDNN. 
### 


sudo apt update
#sudo apt upgrade
sudo apt install unzip  git -y
sudo apt-get install gcc -y
sudo apt -y autoremove

####### Cuda and CUDNN
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y

# Get CUDNN 9.1 and Install it
wget http://files.fast.ai/files/cudnn-10.1-linux-x64-v7.6.3.30.tgz
tar xf cudnn-10.1-linux-x64-v7.6.3.30.tgz
sudo cp cuda/include/*.* /usr/local/cuda/include/
sudo cp cuda/lib64/*.* /usr/local/cuda/lib64/
rm -rf cuda

# Setup Miniconda 
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
echo 'export PATH=~/miniconda3/bin:$PATH' >> ~/.bashrc
conda init
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
jupass='sha1:34122d83e563:f1f92740d9986be5ca7183f92308e41dad71d00b'
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py


# Enable Jupyter Notebook Widgets
pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix
# Crontab to start jupyter on Start
(crontab -l ; echo "@reboot cd $HOME; source ~/.bashrc;  $HOME/miniconda3/bin/jupyter notebook") | crontab -
# Setup Fastai2 Environment
conda create -n fastai2 python=3.7 -y
conda activate fastai2
git clone https://github.com/fastai/fastai2  && cd fastai2 && pip install -q -e ".[dev]"
git clone https://github.com/fastai/fastcore && cd fastcore && pip install -q -e ".[dev]"
conda install -c conda-forge ipywidgets -y
pip install wandb

#Setup kernel on Jupyter
pip install ipykernel
python -m ipykernel install --user --name fastai2 --display-name "fastai2"
echo 'alias fastai2="conda activate fastai2"'>>~/.bashrc

conda deactivate

### Tensorflow 2.0
conda create -n tf2 python=3.7 -y
conda activate tf2
conda install -c anaconda tensorflow-gpu -y
conda install -c conda-forge ipywidgets -y

#Setup kernel on Jupyter
pip install ipykernel
python -m ipykernel install --user --name tf2 --display-name "tf2"
pip install wandb

echo 'alias tf2="conda activate tf2"'>>~/.bashrc
conda deactivate


#### Pytorch 

conda create -n pytorch python=3.7 -y
conda activate pytorch
conda install pytorch torchvision cudatoolkit=10.1 -c pytorch -y
conda install -c conda-forge ipywidgets -y
pip install git+https://github.com/PytorchLightning/pytorch-lightning.git@master --upgrade
pip install wandb

#Setup kernel on Jupyter
pip install ipykernel
python -m ipykernel install --user --name pytorch --display-name "pytorch"
echo 'alias pytorch="conda activate pytorch"'>>~/.bashrc

conda deactivate

sudo apt-get update 
sudo apt-get upgrade
sudo apt-get install git 
git config --global user.name "Gokkulnath T S"
git config --global user.email "gokkulnath@Gmail.com"


# Cleanup
rm cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
rm Miniconda3-latest-Linux-x86_64.sh

