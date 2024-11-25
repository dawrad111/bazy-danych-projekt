CREATE TABLE Email (
    id SERIAL PRIMARY KEY, 
    userId SERIAL REFERENCES Users(userId) NOT NULL, 
    email VARCHAR UNIQUE NOT NULL, 
    link VARCHAR, 
    linkExpiredDate TIMESTAMP, 
    isVerified BOOLEAN DEFAULT FALSE NOT NULL, 
    verifiedDate TIMESTAMP 
);
