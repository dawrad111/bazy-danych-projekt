CREATE TABLE Logs (
    id SERIAL PRIMARY KEY, 
    userId SERIAL REFERENCES Users(userId) NOT NULL, 
    activityType VARCHAR NOT NULL, 
    time TIMESTAMP NOT NULL
);