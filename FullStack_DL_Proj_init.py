#!/usr/bin/env python
# coding: utf-8
import os
from argparse import ArgumentParser


def create_file(path,contents=''):
    with open(path,'w') as out:
        out.writelines(contents)

parser = ArgumentParser()
parser.add_argument('-p','--project_name',help='Enter the project directory name',type=str)
parser.add_argument('-n','--modules_count',help='Enter the number of Sub modules',type=int,default=1)
args = parser.parse_args()

base_dir = args.project_name #'fsdl-text-recognizer' 
modules_count = args.modules_count # 1


os.makedirs(base_dir,exist_ok=True)
os.makedirs(os.path.join(base_dir,'api'),exist_ok=True)
os.makedirs(os.path.join(base_dir,'api','tests'),exist_ok=True)
create_file(os.path.join(base_dir,'api','tests','test_app.py'),'# Test that predictions are working')
create_file(os.path.join(base_dir,'api','tests','Dockerfile'),'# Specifies Docker image that runs the web server.')
create_file(os.path.join(base_dir,'api','tests','__init__.py'),'# Code for serving predictions as a REST API.')
create_file(os.path.join(base_dir,'api','tests','app.py'),'# Flask web server that serves predictions.')

os.makedirs(os.path.join(base_dir,'data'),exist_ok=True)
os.makedirs(os.path.join(base_dir,'data','raw'),exist_ok=True)
create_file(os.path.join(base_dir,'data','raw','dataset_metadata.toml'),'# Specifications for downloading data')

os.makedirs(os.path.join(base_dir,'evaluation'),exist_ok=True)
create_file(os.path.join(base_dir,'evaluation','evaluate_modeule.py'),'# Scripts for evaluating model on eval set.')

os.makedirs(os.path.join(base_dir,'notebooks'),exist_ok=True)

os.makedirs(os.path.join(base_dir,'tasks'),exist_ok=True)
# Deployment
create_file(os.path.join(base_dir,'tasks','build_api_docker.sh'),'')
# Code quality
create_file(os.path.join(base_dir,'tasks','lint.sh'),'# Code quality')
# Tests
create_file(os.path.join(base_dir,'tasks','test_api.sh'),'# Tests')
create_file(os.path.join(base_dir,'tasks','test_functionality.sh'),'# Tests')
create_file(os.path.join(base_dir,'tasks','test_validation.sh'),'# Tests')
# Training
create_file(os.path.join(base_dir,'tasks','train_character_predictor.sh'),'# Training')
        
for i in range(modules_count):
    
    module = str(input('Enter the Submodule Name')) # 'text_recognizer'
    os.makedirs(os.path.join(base_dir, module),exist_ok=True)

    create_file(os.path.join(base_dir, module ,'__init__.py'),'# Package that can be deployed as a self-contained prediction system')
    create_file(os.path.join(base_dir, module ,'{}_predictor.py'.format(module)),'# Takes a raw image and obtains a prediction')

    os.makedirs(os.path.join(base_dir, module,'datasets'),exist_ok=True)
    create_file(os.path.join(base_dir, module ,'datasets','__init__.py'),'# Code for loading datasets') 
    create_file(os.path.join(base_dir, module ,'datasets','dataset.py'),'# Base class for datasets - logic for downloading data') 
    create_file(os.path.join(base_dir, module ,'datasets','custom_dataset.py')) 


    os.makedirs(os.path.join(base_dir, module,'models'),exist_ok=True)
    create_file(os.path.join(base_dir, module ,'models','__init__.py'),'# Code for instantiating models, including data preprocessing and loss functions') 
    create_file(os.path.join(base_dir, module ,'models','base.py'),'# Base class for models') 
    create_file(os.path.join(base_dir, module ,'models','custom_model.py')) 

    os.makedirs(os.path.join(base_dir, module,'networks'),exist_ok=True)
    create_file(os.path.join(base_dir, module ,'networks','__init__.py'),'# Code for building neural networks (i.e., "dumb" input->output mappings) used by models') 
    create_file(os.path.join(base_dir, module ,'networks','resnet.py'),'# Code for instantiating models, including data preprocessing and loss functions') 

    os.makedirs(os.path.join(base_dir, module,'tests'),exist_ok=True)
    os.makedirs(os.path.join(base_dir, module,'tests','support'),exist_ok=True)
    create_file(os.path.join(base_dir, module ,'tests','support','about.txt'.format(module)),'# Raw data used by tests') 
    create_file(os.path.join(base_dir, module ,'tests','test_{}.py'.format(module)),'# Test model on a few key examples') 

    os.makedirs(os.path.join(base_dir, module,'weights'),exist_ok=True)
    create_file(os.path.join(base_dir, module ,'util.py'.format(module)),'# Test model on a few key examples') 

    os.makedirs(os.path.join(base_dir,'training'),exist_ok=True)
    create_file(os.path.join(base_dir, 'training','about.txt'),'# Code for running training experiments and selecting the best model') 
    create_file(os.path.join(base_dir, 'training','run_experiment.py'),'# Parse experiment config and launch training.') 
    create_file(os.path.join(base_dir, 'training','util.py'),'# Logic for training a model with a given config') 
