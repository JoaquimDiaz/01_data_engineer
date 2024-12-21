// Create users for the database

db = db.getSiblingDB('admin');
db.createUser({
  user: process.env.MONGO_ADMIN_USERNAME,
  pwd: process.env.MONGO_ADMIN_PASSWORD,
  roles: [ 
    { role: "userAdminAnyDatabase", db: "admin" }, 
    { role: "readWriteAnyDatabase", db: "admin" } 
  ]
});

db = db.getSiblingDB(process.env.DATABASE);

db.createUser(
  {
    user: process.env.MONGO_DEV_USERNAME,
    pwd: process.env.MONGO_DEV_PASSWORD,
    roles: [{ role: 'readWrite', db: process.env.DATABASE }],
  },
);

db.createUser(
  {
    user: process.env.MONGO_RO_USERNAME,
    pwd: process.env.MONGO_RO_PASSWORD,
    roles: [{ role: 'read', db: process.env.DATABASE }],
  },
);