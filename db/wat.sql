CREATE TABLE Area (
    Area_ID INT PRIMARY KEY,
    Location VARCHAR(100),
    WASA_Zone VARCHAR(50),
    Population_Count INT,
    Water_Source VARCHAR(100),
    Water_Supply_Capacity DECIMAL(10,2)
);

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Area_ID INT,
    Meter_ID INT,
    Account_Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID)
);

CREATE TABLE Authority (
    Admin_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Role VARCHAR(50)
);

CREATE TABLE Distribution (
    Distribution_ID INT PRIMARY KEY,
    Area_ID INT,
    Water_Source VARCHAR(100),
    Distribution_Date DATE,
    Water_Volume DECIMAL(10,2),
    Backup_Supply_Status VARCHAR(50),
    Leak_Detection_Sensor_Status VARCHAR(50),
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID)
);

CREATE TABLE Monitoring (
    Monitoring_ID INT PRIMARY KEY,
    Area_ID INT,
    Monitoring_Date DATE,
    Usage_Volume DECIMAL(10,2),
    Water_Quality_Status VARCHAR(50),
    Water_Pressure VARCHAR(50),
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID)
);

CREATE TABLE Billing (
    Billing_ID INT PRIMARY KEY,
    Billing_Date DATE,
    Usage_Volume DECIMAL(10,2),
    Rate_Per_Unit DECIMAL(10,2),
    Total_Amount DECIMAL(10,2),
    Payment_Status VARCHAR(20),
    User_ID INT,
    Area_ID INT,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID)
);

CREATE TABLE Complaint (
    Complaint_ID INT PRIMARY KEY,
    User_ID INT,
    Area_ID INT,
    Issue_Type VARCHAR(100),
    Submission_Date DATE,
    Resolution_Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Area_ID) REFERENCES Area(Area_ID)
);
