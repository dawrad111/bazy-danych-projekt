CREATE TABLE PhoneNumber (
    id SERIAL PRIMARY KEY, 
    userId SERIAL REFERENCES Users(userId) NOT NULL, 
    phoneNumber TEXT NOT NULL, 
    link VARCHAR,
    linkExpiredDate TIMESTAMP,
    isVerified BOOLEAN DEFAULT FALSE NOT NULL, 
    verifiedDate TIMESTAMP 
);
