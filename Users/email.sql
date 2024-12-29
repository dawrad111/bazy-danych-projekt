CREATE TABLE email (
    id SERIAL PRIMARY KEY, 
    email VARCHAR UNIQUE NOT NULL, 
    link VARCHAR, 
    linkexpiredate TIMESTAMP, 
    isverified BOOLEAN DEFAULT FALSE NOT NULL, 
    verifieddate TIMESTAMP 
);
