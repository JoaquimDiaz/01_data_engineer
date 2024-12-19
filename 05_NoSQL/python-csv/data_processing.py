import polars as pl
import logging
import os
from datetime import datetime

def process_data(config, **kwarg) -> pl.DataFrame:
    
    file_path = config['FILE_PATH']
    required_columns = config['REQUIRED_COLUMNS']
    id_columns = config['PATIENT_ID_COLUMNS']
    
    # Loading file
    if os.path.exists(file_path):    
        df = pl.read_csv(file_path, **kwarg)
    else:
        raise FileNotFoundError(f"Could not find file '{file_path}'")

    # Standardize column names to snake_case
    df.columns = [col.lower().replace(' ', '_') for col in df.columns]
    
    check_for_missing_columns(df, required_columns)
    
    check_for_duplicates(df)
    
    check_for_nulls(df, required_columns)
    
    # Removing duplicates
    df = df.unique()
    
    # Lowering and Capitalizing 'name'
    df = df.with_columns(
        pl.col('name')
        .str.to_lowercase()
        .str.to_titlecase()
        .alias('name')
    )
    
    # Parsing dates
    df = df.with_columns(
        pl.col('date_of_admission').str.to_datetime().alias('date_of_admission')
    )
    
    if 'discharge_date' in df.columns:
        df = df.with_columns(
            pl.col('discharge_date').str.to_datetime().alias('discharge_date')
        )        
        check_for_date_incoherence(df)
    
    # Creating ids
    df = create_patient_id(df, id_columns)
    df = create_admission_id(df)
        
    return df     
   
def check_for_missing_columns(df, required_columns) -> None:
    
    missing_columns = [
        col for col in required_columns if col not in df.columns
    ]
    
    if missing_columns:
        raise ValueError(f"Missing required columns in dataset: {missing_columns}") 
    else:
        logging.info(f"{required_columns} present in dataset")    
        
def check_for_duplicates(df) -> None:
    
    nb_duplicates = df.is_duplicated().sum()
    
    if nb_duplicates > 0:
        logging.warning(f"⚠️   Dataset contains '{nb_duplicates}' duplicated lines")
        
def check_for_nulls(df, required_columns) -> None:
    
    df_null_counts = df.select(required_columns).null_count()

    list_null_col = [
        col for col in required_columns if df_null_counts[col][0] > 0
    ]

    if list_null_col:
        details = {
            col: df_null_counts[col][0] for col in list_null_col
        }
        raise ValueError(f"Error: Columns with missing values in required columns: {details}")
    else:
        logging.info("No missing values in required columns")
        
def check_for_date_incoherence(df):
    
    incorrect_rows = df.filter(
            pl.col('date_of_admission') > pl.col('discharge_date')
        )
    if not incorrect_rows.is_empty():
        raise ValueError(f"Error : Some rows have a 'discharge_date' anterior to 'date_of_admission")
    
def create_patient_id(df, required_columns) -> pl.DataFrame:
    """ Adds a unique patient identifier ('patient_id') to the DataFrame and reorders columns. """
    try:
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
        raise ValueError(f"Error when creating 'patient_id': {e}")

    return df

def create_admission_id(df) -> pl.DataFrame:
    """ Adds a unique identifier ('admission_id') for hospital admissions to the DataFrame and reorders columns. """
    try:
        df = df.with_columns(
            pl.concat_str(
                pl.col('patient_id'),
                pl.lit('-'), 
                pl.col('date_of_admission').cast(pl.String).str.slice(0, 10)
            )
            .cast(pl.String)
            .alias('_id')
        )
       
        # Reorder columns to make 'patient_id' the first column
        df = df.select(['_id'] + [col for col in df.columns if col != '_id'])
        
    except Exception as e:
        raise ValueError(f"Error when creating 'admission_id': {e}")

    return df

if __name__ == "__main__":
    
    from dotenv import load_dotenv
    
    load_dotenv()

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s — %(name)s — %(levelname)s — %(message)s"
    )
    
    config = {
        'FILE_PATH' : r'.\data\healthcare_dataset.csv' ,
        'REQUIRED_COLUMNS' : os.getenv('REQUIRED_COLUMNS', '').split(','),
        'PATIENT_ID_COLUMNS' : os.getenv('PATIENT_ID_COLUMNS', '').split(','),
    }
    
    print(process_data(config))