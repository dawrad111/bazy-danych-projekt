CREATE TABLE phone_number (
    id SERIAL PRIMARY KEY, 
    phoneNumber TEXT NOT NULL, 
    code VARCHAR,
    linkExpiredDate TIMESTAMP,
    isVerified BOOLEAN DEFAULT FALSE NOT NULL, 
    verifiedDate TIMESTAMP 
);
