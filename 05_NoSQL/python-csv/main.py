import polars as pl
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure
from dotenv import load_dotenv
import logging
import os
from datetime import datetime

from data_processing import process_data
from mongo_insert import insert_data_to_mongo

def main(): 
    
    config = load_config()
    init_logging(config['LOGGING_PATH'])
    
    client = create_mongo_client(config)
    
    df = process_data(config)
                      
    insert_data_to_mongo(df, client, config)

################################################

def create_mongo_client(config):
    """ Create a mongodb client. """
    
    client = MongoClient(f"mongodb://{config['MONGO_ADMIN_USERNAME']}:{config['MONGO_ADMIN_PASSWORD']}@{config['SERVER']}:{config['PORT']}")
    
    test_connexion(client)
    
    return client

def test_connexion(mongo_client):
    """ Test that the connexion to mongodb is working. """   
    try:
        mongo_client.admin.command('ping')
        logging.info("✅   Connection to MongoDB successful!")

    except ConnectionFailure as e:
        raise ConnectionFailure("❌   Could not connect to MongoDB:", e)
           
def load_config():
    """ Load environment variables contained in '.env' file. """
    
    load_dotenv()

    config = {
        'SERVER' : os.getenv('SERVER'),
        'PORT' : int(os.getenv('PORT')),
        
        'DATABASE' : os.getenv('DATABASE'),
        'COLLECTION' : os.getenv('COLLECTION'),
        'COLLECTION_INFO' : os.getenv('COLLECTION_INFO'),

        'FILE_PATH' : os.getenv('FILE_PATH') ,
        'LOGGING_PATH' : os.getenv('LOGGING_PATH'),

        # Split the comma-separated strings into lists
        'REQUIRED_COLUMNS' : os.getenv('REQUIRED_COLUMNS', '').split(','),
        'PATIENT_ID_COLUMNS' : os.getenv('PATIENT_ID_COLUMNS', '').split(','),
        
        'MONGO_ADMIN_USERNAME' : os.getenv('MONGO_ADMIN_USERNAME'),
        'MONGO_ADMIN_PASSWORD' : os.getenv('MONGO_ADMIN_PASSWORD')
    }
    
    missing_variables = []
    
    for key in config:
        if config[key] == None:
            missing_variables.append(key)
    
    if missing_variables:
        raise ValueError(f"Error during config loading, the following variables are missing : {missing_variables}")
    
    return config

def init_logging(logging_path):
    
    execution_date = datetime.now().strftime('%y%m%d')
    
    logging_file = os.path.join(logging_path, f'main_{execution_date}')

    if not os.path.isdir(logging_path):
        print(f"The directory '{logging_path}' does not exist. Creating directory")
        os.makedirs(logging_path)

    logging.basicConfig(
                level=logging.INFO,  
                format="%(asctime)s - %(levelname)s - %(message)s",  
                encoding='utf-8', 
                handlers=[
                    logging.FileHandler(logging_file, encoding='utf-8'),
                    logging.StreamHandler()
                ]
            )
    logging.info("Starting main.py script")

if __name__=="__main__":
    main()