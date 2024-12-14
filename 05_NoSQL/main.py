import polars as pl
from pymongo import MongoClient, errors

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

client = MongoClient("mongodb://localhost:27017/")

data_dicts = df.to_dicts()

db = client.test_database

collection = db.test_collection

collection.insert_many(data_dicts)

print(collection.count_documents({}))