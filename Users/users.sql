CREATE TABLE Users (
    userId SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    surname VARCHAR NOT NULL, 
    passwordHash VARCHAR NOT NULL, 
    emailId INT NOT NULL REFERENCES email(id), 
    phoneNumberId INT NOT NULL REFERENCES phoneNumber(id), 
    lastLoginDate TIMESTAMP,
    registrationDate TIMESTAMP NOT NULL, 
    userType VARCHAR NOT NULL CHECK (userType IN ('operator', 'administrator', 'user')), 
    status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'suspended')), 
    isVerified BOOLEAN DEFAULT FALSE NOT NULL 
);
