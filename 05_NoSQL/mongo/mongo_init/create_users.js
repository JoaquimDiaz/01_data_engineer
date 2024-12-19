// Create users for the database

// Create an admin user
db = db.getSiblingDB('admin');
db.createUser({
  user: process.env.MONGO_ADMIN_USERNAME,
  pwd: process.env.MONGO_ADMIN_PASSWORD,
  roles: [ 
    { role: "userAdminAnyDatabase", db: "admin" }, 
    { role: "readWriteAnyDatabase", db: "admin" } 
  ]
});

// Create a user for the specific database
db = db.getSiblingDB(process.env.DATABASE);
db.createUser({
  user: process.env.MONGO_ADMIN_USERNAME,
  pwd: process.env.MONGO_ADMIN_PASSWORD,
  roles: [
    { role: "readWrite", db: process.env.DATABASE }
  ]
});