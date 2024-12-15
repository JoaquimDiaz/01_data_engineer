import polars as pl
from pymongo import MongoClient
from dotenv import load_dotenv
import logging
import os
from datetime import datetime

def main():
    
    load_dotenv()

    SERVER = os.getenv('SERVER')
    PORT = int(os.getenv('PORT'))
    
    DATABASE = os.getenv('DATABASE')
    COLLECTION = os.getenv('COLLECTION')
    COLLECTION_INFO = os.getenv('COLLECTION_INFO')

    FILE_PATH = os.getenv('FILE_PATH')
    LOGGING_PATH = os.getenv('LOGGING_PATH')

    # Split the comma-separated strings into lists
    REQUIRED_COLUMNS = os.getenv('REQUIRED_COLUMNS', '').split(',')
    PATIENT_ID_COLUMNS = os.getenv('PATIENT_ID_COLUMNS', '').split(',')
    
    execution_date = datetime.now().strftime('%y%m%d')

    logging_file = os.path.join(LOGGING_PATH, f'main_{execution_date}')

    if not os.path.isdir(LOGGING_PATH):
        print(f"The directory '{LOGGING_PATH}' does not exist. Creating directory")
        os.makedirs(LOGGING_PATH)

    logging.basicConfig(
                level=logging.INFO,  
                format="%(asctime)s - %(levelname)s - %(message)s",  
                encoding='utf-8', 
                handlers=[
                    logging.FileHandler(logging_file, encoding='utf-8'),
                    logging.StreamHandler() # Permet d'afficher les logs dans la console
                ]
            )

    # Vérification des chemins
    if not os.path.isfile(FILE_PATH):
        raise FileNotFoundError(f"The file '{FILE_PATH}' does not exist. Please check the file path.")

    logging.info("Starting main.py script")


    # Importation des données
    try:
        df = pl.read_csv(FILE_PATH, infer_schema=False)
    except Exception as e:
        raise ValueError(f"Error when loading data : {e}")


    df_is_empty = df.is_empty()

    if df_is_empty:
        raise ValueError(f"Error : {FILE_PATH} is empty")

    logging.info(f"df_is_empty = {df_is_empty}")
    
    df = standardize_column_names(df)

    missing_columns = test_missing_columns(df, REQUIRED_COLUMNS)
    
    if missing_columns:
        raise ValueError(f"Missing some required column in data set : {missing_columns}")
    else:
        logging.info("All required columns present in dataset")

    emptry_string_cols = test_empty_string(df, REQUIRED_COLUMNS)

    if emptry_string_cols:
        raise ValueError(f"Dataset contains empty strings in required columns : {emptry_string_cols}")
    
    df = capitalize_column(df, 'name')
    
    nb_duplicates = count_duplicates(df)
    
    if nb_duplicates > 0:
        try :
            df = df.unique()
        except Exception as e:
            raise ValueError(f"Error when deleting duplicates : {e}")
        
    df = create_patient_id(df,PATIENT_ID_COLUMNS)
    
    test_hashing(df, PATIENT_ID_COLUMNS)
    
    data_details = get_info(df, FILE_PATH)
    
    logging.info(data_details)
    
    try:
        data_to_insert = df.to_dicts()
        
    except Exception as e:
        raise ValueError(f"Error when creating documents to insert : {e}")
    
    # Creating connection to MongoDB
    client = MongoClient(f"mongodb://{SERVER}:{PORT}")
    
    # Starting a transaction to ensure atomic insertion
    with  client.start_session() as session:
        with session.start_transaction():
            logging.info("Established connection to MongoDB")
            try:    
                db = client[DATABASE]

                collection =  db[COLLECTION]

                collection_info = db[COLLECTION_INFO]
                
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

def test_empty_string(df : pl.DataFrame, required_columns: list) -> list :
    """
    Identifies columns that contains empty string. It can be the case sometimes with polars dataframes.

    Args:
        df (pl.Dataframe): The Polars Dataframe to check for empty strings.
        required_columns (list) : The list of columns that must not contain empty strings.
        
    Return:
        list: The list of columns containing empty strings.
    """
    df_empty_strings = df.select(required_columns).filter(pl.any_horizontal(pl.col('*') == ''))

    if not df_empty_strings.is_empty():
        
        columns_with_empty_string = [
            col for col in required_columns if not df_empty_strings.select(pl.col(col) == '').is_empty()
            ]
        
        return columns_with_empty_string
    
    return []

def standardize_column_names(df: pl.DataFrame) -> pl.DataFrame:
    """
    Standardize column names to follow a 'snake_case' pattern.
    
    Args:
        df (pl.DataFrame): The DataFrame input to format columns.
        
    Return:
        df (pl.DataFrame): The DataFrame with columns formated
    Raises:
        ValueError: If an error occurs during renaming.
    """
    try:
        df = df.rename({
            col : col.lower().replace(' ','_') for col in df.columns
        })
        return df
    except Exception as e:
        raise ValueError(f"Error when trying to rename columns : {e}")

def test_missing_columns(df: pl.DataFrame, required_columns: list) -> list:
    """
    Check if the DataFrame contains all the required columns.
    
    Args:
        df (pl.DataFrame): The input DataFrame.
        required_columns: The list of columns required in the DataFrame.
    Return:
        list: The list of required columns missing in the DataFrame.
    """
    missing_columns = [col for col in required_columns if col not in df.columns]

    return missing_columns
    
def capitalize_column(df: pl.DataFrame, column_name: str, modified_column = None) -> pl.DataFrame:
    """
    Capitalize value of the column in the polars dataframe.
    
    Args
        df (pl.DataFrame): The polars dataframe in which to modify the column.
        column_name (str): The name of the column for which to modify the case.
        modified_column (str, optional): The name of the modified column. Defaults to the original column name.
    
    Return:
        pl.DataFrame: The DataFrame with the specified column capitalized.
        
    Raises:
        ValueError: If the column does not exist or capitalization fails.
    
    """
    try:
        if column_name not in df.columns:
            raise ValueError(f"Column '{column_name}' not present in the DataFrame")
        
        # If no modified_column provided, defaults to replacing the original column.
        if modified_column == None:
            modified_column = column_name
        df = (
            df.with_columns(
                pl.col(column_name)
                .str.to_lowercase()
                .str.to_titlecase()
                .alias(modified_column)
            )
        )
        return df
    except Exception as e:
        raise ValueError(f"Error when formatting 'name' : {e}")

def count_duplicates(df: pl.DataFrame) -> int:
    """
    Count the number of duplicate rows in a Polars DataFrame.

    Args:
        df (pl.DataFrame): The Polars DataFrame to check for duplicates.

    Returns:
        int: The number of duplicate rows in the DataFrame.

    Raises:
        ValueError: If the DataFrame is empty or invalid.
    """
    if df.is_empty():
        raise ValueError("The DataFrame is empty. Cannot count duplicates.")

    # Count duplicate rows
    nb_duplicates = df.is_duplicated().sum()

    # Return the count
    return nb_duplicates

def test_data_type(df):
    # Test pour les types
    try:
        df.get_column('age').cast(pl.Int16)
        df.get_column('room_number').cast(pl.Int16)
        
        df.get_column('date_of_admission').str.strptime(pl.Date, "%Y-%m-%d")
        df.get_column('discharge_date').str.strptime(pl.Date, "%Y-%m-%d")

    except Exception as e:
        print(f"Error during data type validation : {e}")

def test_null(df: pl.DataFrame, required_columns: list) -> None:
    """
    Check for null values in the required columns of a Polars DataFrame.

    Args:
        df (pl.DataFrame): The DataFrame to check.
        required_columns (list): List of required columns to validate for null values.

    Raises:
        ValueError: If null values are present in the required columns.
    """
    df_null_counts = df.select(required_columns).null_count()

    # Identify columns with null values
    list_null_col = [
        col for col in required_columns if df_null_counts[col][0] > 0
    ]

    if list_null_col:
        # Add detailed counts for each column with nulls
        details = {
            col: df_null_counts[col][0] for col in list_null_col
        }
        raise ValueError(f"Error: Columns with missing values: {details}")
    else:
        logging.info("No missing values in required columns")
    

def create_patient_id(df: pl.DataFrame, required_columns: list) -> pl.DataFrame:
    """
    Adds a unique patient identifier ('patient_id') to the DataFrame and reorders columns.

    Args:
        df (pl.DataFrame): Input DataFrame containing patient details.
        required_columns (list): List of columns to concatenate for creating the patient_id.

    Returns:
        pl.DataFrame: Modified DataFrame with 'patient_id' as the first column.

    Raises:
        ValueError: If required columns are missing or the operation fails.
    """
    # Check for required columns
    missing_columns = [col for col in required_columns if col not in df.columns]
    if missing_columns:
        raise ValueError(f"Missing required columns for 'patient_id' creation: {missing_columns}")

    try:
        # Create unique patient_id
        df = df.with_columns(
            pl.concat_str(
                *[pl.col(col) for col in required_columns]
            )
            .hash()
            .cast(pl.String)
            .alias('patient_id')
        )

        # Reorder columns to make 'patient_id' the first column
        df = df.select(['patient_id'] + [col for col in df.columns if col != 'patient_id'])
    except Exception as e:
        raise ValueError(f"Error when creating or reordering 'patient_id': {e}")

    return df

def test_hashing(df, required_columns, id_column='patient_id'):
    
    unique_input_count = df.select(required_columns).unique().height
    unique_id_count = df.select(id_column).unique().height

    if unique_input_count != unique_id_count:
        raise ValueError(
            f"Error: Hashing did not produce unique {id_column}. "
            f"Expected {unique_input_count} unique values, but got {unique_id_count}."
        )

def get_info(df: pl.DataFrame, file_path: str, execution_date = None) -> dict:
    """
    Extracts metadata information about a Polars DataFrame and the associated file.

    Args:
        df (pl.DataFrame): The Polars DataFrame to analyze.
        file_path (str): The file path or name associated with the dataset.
        execution_date (Optional[str]): The date of execution. Defaults to the current date.

    Returns:
        dict: A dictionary containing metadata about the dataset, including:
            - name: The file path or name.
            - row_count: The number of rows in the dataset.
            - columns_count: The number of columns in the dataset.
            - execution_date: The date of execution.

    Raises:
        ValueError: If the DataFrame is empty or the file_path is invalid.
    """
    # Validate file_path
    if not file_path or not isinstance(file_path, str):
        raise ValueError("Invalid file_path: Must be a non-empty string.")
    
    # Validate DataFrame
    if df.is_empty():
        raise ValueError("The DataFrame is empty. Cannot extract information.")

    # Default to the current date if execution_date is not provided
    if execution_date is None:
        execution_date = datetime.now().strftime("%Y-%m-%d")
    
    # Gather dataset metadata
    dataset_info = {
        "name": file_path,
        "row_count": df.height,
        "columns_count": df.width,
        "execution_date": execution_date,
    }
    
    return dataset_info

if __name__=="__main__":
    main()