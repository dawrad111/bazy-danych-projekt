CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    surname VARCHAR NOT NULL, 
    passwordHash VARCHAR NOT NULL, 
    emailId INT NOT NULL REFERENCES email(id), 
    phonenumberId INT NOT NULL REFERENCES phone_number(id), 
    lastLoginDate TIMESTAMP,
    registrationDate TIMESTAMP NOT NULL, 
    userType VARCHAR NOT NULL CHECK (userType IN ('operator', 'administrator', 'user')), 
    status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'suspended')), 
    isVerified BOOLEAN DEFAULT FALSE NOT NULL 
);

CREATE TABLE email (
    id SERIAL PRIMARY KEY, 
    email VARCHAR UNIQUE NOT NULL, 
    link VARCHAR, 
    linkexpiredate TIMESTAMP, 
    isverified BOOLEAN DEFAULT FALSE NOT NULL, 
    verifieddate TIMESTAMP 
);

CREATE TABLE Logs (
    id SERIAL PRIMARY KEY,
    userid INT REFERENCES Users(id) NOT NULL,
    activityType VARCHAR NOT NULL,
    time TIMESTAMP NOT NULL
);

CREATE TABLE phone_number (
    id SERIAL PRIMARY KEY, 
    phoneNumber TEXT NOT NULL, 
    code VARCHAR,
    linkExpiredDate TIMESTAMP,
    isVerified BOOLEAN DEFAULT FALSE NOT NULL, 
    verifiedDate TIMESTAMP 
);

