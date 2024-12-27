CREATE TABLE Email (
    id SERIAL PRIMARY KEY, 
    email VARCHAR UNIQUE NOT NULL, 
    link VARCHAR, 
    linkExpiredDate TIMESTAMP, 
    isVerified BOOLEAN DEFAULT FALSE NOT NULL, 
    verifiedDate TIMESTAMP 
);
