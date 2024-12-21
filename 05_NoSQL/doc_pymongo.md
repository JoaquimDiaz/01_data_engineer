# Introduction to MongoDB

MongoDB is a popular NoSQL database that stores data in a flexible, JSON-like format. Unlike traditional relational databases, MongoDB uses a document-oriented model that makes it easier to store and retrieve complex, hierarchical data structures.

## Key Concepts

### 1. Documents
Documents are the basic unit of data in MongoDB. A document is similar to a row in a relational database but has a flexible schema. Documents are stored in BSON format (Binary JSON) and can contain various data types, nested objects, and arrays. Example of a document:

```json
{
    "_id": ObjectId("507f1f77bcf86cd799439011"),
    "name": "John Doe",
    "age": 30,
    "address": {
        "street": "123 Main St",
        "city": "New York",
        "country": "USA"
    },
    "hobbies": ["reading", "hiking", "photography"]
}
```

### 2. Collections
Collections are groups of related documents, similar to tables in relational databases. However, collections are schema-less, meaning documents within the same collection can have different fields. Best practice is to store documents of the same type in a collection. Example structure:

- `users` collection: Stores user documents
- `products` collection: Stores product documents
- `orders` collection: Stores order documents

### Databases
A database is a container for collections. A single MongoDB server typically has multiple databases, each acting as a namespace for its collections. For example:

- `ecommerce_db`
  - users collection
  - products collection
  - orders collection
- `blog_db`
  - posts collection
  - comments collection
  - authors collection

## Key Differences from Relational Databases

| Relational Database | MongoDB |
|-------------------|---------|
| Table | Collection |
| Row | Document |
| Column | Field |
| Primary Key | _id field |
| Join | $lookup (aggregation) |

# Prerequisites

First, install PyMongo using pip:
```bash
pip install pymongo
```

## Connection Setup

Connect to MongoDB and select a database and collection:

```python
from pymongo import MongoClient

# Connect to MongoDB (default localhost:27017)
client = MongoClient('mongodb://localhost:27017/')

# Select database and collection
db = client['your_database']
collection = db['your_collection']
```

## Create Operations

### Insert a Single Document
```python
# Insert one document
document = {"name": "John Doe", "age": 30, "city": "New York"}
result = collection.insert_one(document)
print(f"Inserted document ID: {result.inserted_id}")
```

### Insert Multiple Documents
```python
# Insert multiple documents
documents = [
    {"name": "Jane Doe", "age": 25, "city": "Los Angeles"},
    {"name": "Bob Smith", "age": 35, "city": "Chicago"}
]
result = collection.insert_many(documents)
print(f"Inserted document IDs: {result.inserted_ids}")
```

## Read Operations

### Find a Single Document
```python
# Find one document
document = collection.find_one({"name": "John Doe"})
print(document)
```

### Find Multiple Documents
```python
# Find multiple documents
cursor = collection.find({"age": {"$gt": 25}})
for document in cursor:
    print(document)
```

### Query with Filters
```python
# Using query operators
query = {
    "age": {"$gte": 25, "$lte": 35},
    "city": "New York"
}
cursor = collection.find(query)
```

## Update Operations

### Update a Single Document
```python
# Update one document
filter_criteria = {"name": "John Doe"}
new_values = {"$set": {"age": 31}}
result = collection.update_one(filter_criteria, new_values)
print(f"Modified {result.modified_count} document(s)")
```

### Update Multiple Documents
```python
# Update multiple documents
filter_criteria = {"city": "New York"}
new_values = {"$inc": {"age": 1}}
result = collection.update_many(filter_criteria, new_values)
print(f"Modified {result.modified_count} document(s)")
```

## Delete Operations

### Delete a Single Document
```python
# Delete one document
result = collection.delete_one({"name": "John Doe"})
print(f"Deleted {result.deleted_count} document(s)")
```

### Delete Multiple Documents
```python
# Delete multiple documents
result = collection.delete_many({"age": {"$lt": 25}})
print(f"Deleted {result.deleted_count} document(s)")
```

## Common Query Operators

- `$eq`: Equals
- `$gt`: Greater than
- `$gte`: Greater than or equal to
- `$lt`: Less than
- `$lte`: Less than or equal to
- `$ne`: Not equal
- `$in`: In array
- `$nin`: Not in array

## Update Operators

- `$set`: Set a value
- `$unset`: Remove a field
- `$inc`: Increment a value
- `$push`: Add to array
- `$pull`: Remove from array

## Best Practices

1. Always handle exceptions when performing database operations:
```python
try:
    result = collection.insert_one(document)
except Exception as e:
    print(f"An error occurred: {e}")
```

2. Use indexes for frequently queried fields:
```python
# Create an index
collection.create_index([("name", 1)])  # 1 for ascending, -1 for descending
```

3. Close the connection when done:
```python
client.close()
```