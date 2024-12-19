from dotenv import load_dotenv
from datetime import datetime
import logging

def insert_data_to_mongo(df, client, config):   
    
    database = config['DATABASE']
    main_collection = config['COLLECTION']
    info_collection = config['COLLECTION_INFO']
    file_path = config['FILE_PATH']
    
    try:
        data_to_insert = df.to_dicts()
        
    except Exception as e:
        raise ValueError(f"Error when creating documents to insert : {e}")
   
    # Starting a transaction to ensure atomic insertion
    with  client.start_session() as session:
        with session.start_transaction():
            logging.info("Established connection to MongoDB")
            try:    
                db = client[database]

                collection =  db[main_collection]

                collection_info = db[info_collection]
                
                data_details = get_dataset_info(df, file_path)
                
                initial_count = collection.count_documents({})
                logging.info(f"Initial count of documents in collection: {initial_count}")
                
                count_to_insert = data_details['row_count']
                logging.info(f"Number of documents to insert : {count_to_insert}")
                
                collection.insert_many(data_to_insert)
                
                target_count = initial_count + count_to_insert
                
                result_count = collection.count_documents({})
                
                if target_count == result_count:
                    logging.info(f"Correct number of documents after insertion")
                    logging.info(f"Number of documents after insertion : {result_count}")
                    collection_info.insert_one(data_details)
                    
                else:
                    raise ValueError(
                        f"Nomber of rows in collection does not match target :\n"
                        f"Target : {target_count}, Result : {result_count}"
                    )                
                    
            except Exception as e:
                raise ValueError(f" Error during MongoDB insertion: {e}")

def get_dataset_info(df, file_path):
    return {
        "file": file_path,
        "row_count": df.height,
        "column_count": df.width,
        "execution_date": datetime.now().strftime("%Y-%m-%d")
    }