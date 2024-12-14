import polars as pl
from pymongo import MongoClient

FILE_PATH = 'healthcare_dataset.csv'

df = pl.read_csv(FILE_PATH, infer_schema=False)

# Verifie l'absence d'empty string
df.filter(
    pl.any_horizontal(pl.col("*") == "")
)

# Standardisation du nom des colonnes
df = df.rename({
    col : col.lower().replace(' ','_') for col in df.columns
})

# Changement de la case de la colonne name qui est chaotique
df = (
    df.with_columns(
        pl.col('name')
        .str.to_lowercase()
        .str.to_titlecase()
        .alias('name')
    )
)

# Vérificaiton des lignes dupliqués

nb_duplicate = df.is_duplicated().sum()

if nb_duplicate == 0:
    print("No duplicates found in dataframe")
    
else:
    print(f"Duplicates found in dataframe :{nb_duplicate}")
    
    df = df.unique()
    
# Test pour les types
try:
    df.get_column('age').cast(pl.Int16)
    df.get_column('room_number').cast(pl.Int16)
    
    df.get_column('date_of_admission').str.strptime(pl.Date, "%Y-%m-%d")
    df.get_column('discharge_date').str.strptime(pl.Date, "%Y-%m-%d")

except Exception as e:
    print(f"Error : {e}")
    
# Test pour les valeurs manquantes

null_count = df.null_count().sum_horizontal().sum()

if null_count != 0:
    raise ValueError(f"Error : Dataset contains {null_count} missing values")

# Création d'un identifiant unique pour chaque patient avec la fonction hash
df = df.with_columns(
    pl.concat_str(
        pl.col('name'),
        pl.col('age'),
        pl.col('gender'),
        pl.col('blood_type'))
    .hash()
    .cast(pl.String)
    .alias('patient_id')   
)

df = df.select(
    ['patient_id'] + [col for col in df.columns if col not in ['admission_id', 'patient_id']]
)

# Connexion a mongodb

client = MongoClient("mongodb://mongo:27017/")

data_dicts = df.to_dicts()

db = client.test_database

collection = db.test_collection

collection.insert_many(data_dicts)

# Création d'un index sur l'id du patient
collection.create_index('patient_id')

# Création d'un index composé unique sur l'id du patient et la date d'admission
## Une contrainte d'unicité est rajouté pour s'assurer qu'on a pas des doublons d'admission 
collection.create_index(['patient_id','date_of_admission'], unique=True)

print(collection.count_documents({}))