CREATE TABLE Users (
    userId SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    surname VARCHAR NOT NULL, 
    passwordHash VARCHAR NOT NULL, 
    email VARCHAR UNIQUE NOT NULL, 
    phoneNumber TEXT, 
    lastLoginDate TIMESTAMP,
    registrationDate TIMESTAMP NOT NULL, 
    userType VARCHAR NOT NULL, 
    status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'suspended')), 
    isVerified BOOLEAN DEFAULT FALSE NOT NULL 
);
