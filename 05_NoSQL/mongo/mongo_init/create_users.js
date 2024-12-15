// Create users for the database

// ENVIRONMENT VARIABLES
const dbName = _getEnv("DATABSE");
const collectionName = _getEnv("COLLECTION");
const collectionInfoName = _getEnv("COLLECTION_INFO");

db = db.getSiblingDB('admin');

// Create an admin user
db.createUser({
  user: "adminUser",
  pwd: "adminPassword",
  roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
});

// Create a specific database user
db = db.getSiblingDB('your_database_name');
db.createUser({
  user: "appUser",
  pwd: "appPassword",
  roles: [
    { role: "readWrite", db: "your_database_name" }
  ]
});