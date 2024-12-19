// Database and collection creation with JSON Schema validation

// Environment variables
const dbName = process.env.DATABASE;
const collectionName = process.env.COLLECTION;
const collectionInfoName = process.env.COLLECTION_INFO;

db = db.getSiblingDB(dbName);

// Create main collection with schema validation for required fields
db.createCollection(collectionName, {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: [
            "patient_id",
            "name",
            "age",
            "gender",
            "blood_type",
            "date_of_admission",
            "hospital"
         ],
         properties: {
            patient_id: {
               bsonType: "string",
               description: "Unique identifier for each patient."
            },
            name: {
               bsonType: "string",
               description: "Patient's name must be a string."
            },
            age: {
               bsonType: "int",
               minimum: 0,
               maximum: 150,
               description: "Age must be an integer between 0 and 150."
            },
            gender: {
               bsonType: "string",
               enum: ["Male", "Female", "Other"],
               description: "Gender must be 'Male', 'Female', or 'Other'."
            },
            blood_type: {
               bsonType: "string",
               enum: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
               description: "Blood type must be a valid blood type."
            },
            date_of_admission: {
               bsonType: "date",
               description: "Must be a date"
            },
            hospital: {
               bsonType: "string",
               description: "Hospital name must be a string."
            },
            discharge_date: {
               bsonType: "date",
               description: "Must be a date"
            },
         }
      }
   }
});

// Create indexes for the collection
const collection = db.getCollection(collectionName);

// Create an index on 'patient_id'
collection.createIndex({ patient_id: 1 });

// Create a unique compound index on 'patient_id' and 'date_of_admission'
collection.createIndex({ patient_id: 1, date_of_admission: 1 }, { unique: true });

// Create info collection
db.createCollection(collectionInfoName);