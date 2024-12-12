from dotenv import load_dotenv
from sqlalchemy import create_engine, Table, MetaData, select, text
import os

load_dotenv()

# Configurer les informations à partir de .env
DB_SERVER = os.getenv('DB_SERVER')
DB_NAME = os.getenv('DB_NAME')
DB_USERNAME = os.getenv('DB_USERNAME')
DB_PASSWORD = os.getenv('DB_PASSWORD')

DRIVER ='mysql+pymysql'

connection_string = f"{DRIVER}://{DB_USERNAME}:{DB_PASSWORD}@{DB_SERVER}/{DB_NAME}"

engine = create_engine(connection_string)

query =text('''
SELECT 
    *
FROM 
    logs
WHERE
    champs = 'prix'
''')

with engine.connect() as conn:
    result = conn.execute(query)
    for row in result:
        print(row)
