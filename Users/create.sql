CREATE TABLE Users (
    userId SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    surname VARCHAR NOT NULL,
    passwordHash VARCHAR NOT NULL,
    email VARCHAR UNIQUE NOT NULL,
    phoneNumber TEXT,
    lastLoginDate TIMESTAMP,
    registrationDate TIMESTAMP NOT NULL,
    userType VARCHAR NOT NULL CHECK (userType IN ('operator', 'administrator', 'user')),
    status VARCHAR(9) NOT NULL CHECK (status IN ('active', 'suspended')),
    isVerified BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE Email (
    id SERIAL PRIMARY KEY,
    userId SERIAL REFERENCES Users(userId) NOT NULL,
    email VARCHAR UNIQUE NOT NULL,
    link VARCHAR,
    linkExpiredDate TIMESTAMP,
    isVerified BOOLEAN DEFAULT FALSE NOT NULL,
    verifiedDate TIMESTAMP
);

CREATE TABLE Logs (
    id SERIAL PRIMARY KEY,
    userId SERIAL REFERENCES Users(userId) NOT NULL,
    activityType VARCHAR NOT NULL,
    time TIMESTAMP NOT NULL
);

CREATE TABLE PhoneNumber (
    id SERIAL PRIMARY KEY,
    userId SERIAL REFERENCES Users(userId) NOT NULL,
    phoneNumber TEXT NOT NULL,
    code VARCHAR,
    linkExpiredDate TIMESTAMP,
    isVerified BOOLEAN DEFAULT FALSE NOT NULL,
    verifiedDate TIMESTAMP
);
