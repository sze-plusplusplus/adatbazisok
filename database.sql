DROP DATABASE IF EXISTS WebStorage;

CREATE DATABASE WebStorage
    CHARACTER SET utf8
    COLLATE utf8_general_ci;

USE WebStorage;

DROP TABLE IF EXISTS User;
CREATE TABLE User (
    Id int NOT NULL AUTO_INCREMENT,
    FullName varchar(60) NOT NULL,
    UserName varchar(30) NOT NULL,
    Email varchar(120) NOT NULL,
    Password varchar(120) NOT NULL,
    Registration datetime NOT NULL DEFAULT NOW(),
    Blocked boolean NOT NULL DEFAULT false,
    MaximumStorage int NOT NULL DEFAULT 5,
    PRIMARY KEY (Id),
    UNIQUE KEY (UserName, Email)
);

DROP TABLE IF EXISTS StorageType;
CREATE TABLE StorageType(
    Id int NOT NULL AUTO_INCREMENT,
    SSHEnabled boolean NOT NULL DEFAULT false,
    PHPEnabled boolean NOT NULL DEFAULT false,
    MaximumEmailAccounts int NULL,
    MaximumFTPAccounts int NULL,
    MaximumDatabaseNumber int NULL,
    PHPMemoryLimit int null,
    MaximumPHPExecutionTime int null,
    CPanelIsEnabled boolean NOT NULL DEFAULT false,
    BaseCost decimal NOT NULL,
    DataTrafficMultiplier int NOT NULL DEFAULT 1,
    Name varchar(120) NOT NULL,
    PRIMARY KEY (Id)
);

DROP TABLE IF EXISTS DataCenter;
CREATE TABLE DataCenter(
    Id int NOT NULL AUTO_INCREMENT,
    Name varchar(30) NOT NULL,
    City varchar(80) NOT NULL,
    Number int NOT NULL,
    Area decimal NULL,
    StorageCapacity int NOT NULL,
    PRIMARY KEY (Id),
    UNIQUE KEY (Name)
);

DROP TABLE IF EXISTS Storage;
CREATE TABLE Storage(
    Id int NOT NULL AUTO_INCREMENT,
    UserId int NOT NULL,
    Creation datetime NOT NULL DEFAULT NOW(),
    Expiration datetime NOT NULL DEFAULT DATE_ADD(NOW(), INTERVAL 1 YEAR),
    TypeId int NOT NULL,
    Size int NOT NULL,
    MaximumDataTraffic int NOT NULL,
    EmailStorageSize int NULL,
    DatabaseSize int null,
    DataCenterId int NOT NULL,
    Cost decimal NOT NULL,
    Name varchar(80) NOT NULL,
    PRIMARY KEY (Id),
    UNIQUE KEY (UserId, Name),
    FOREIGN KEY (UserId) REFERENCES User(Id),
    FOREIGN KEY (TypeId) REFERENCES StorageType(Id),
    FOREIGN KEY (DataCenterId) REFERENCES DataCenter(Id)
);


DROP TABLE IF EXISTS Domain;
CREATE TABLE Domain(
    Id int NOT NULL AUTO_INCREMENT,
    UserId int NOT NULL,
    DomainAddress varchar(100) NOT NULL,
    StorageId int NULL,
    TLD varchar(5) NOT NULL,
    Registration datetime NOT NULL DEFAULT NOW(),
    Expiration datetime NOT NULL DEFAULT DATE_ADD(NOW(), INTERVAL 1 YEAR),
    NameServer1 varchar(100) NOT NULL,
    NameServer2 varchar(100) NULL,
    NameServer3 varchar(100) NULL,
    NameServer4 varchar(100) NULL,
    PRIMARY KEY (Id),
    UNIQUE (DomainAddress, TLD),
    FOREIGN KEY (UserId) REFERENCES User(Id),
    FOREIGN KEY (StorageId) REFERENCES Storage(Id)
);


DROP TABLE IF EXISTS Bill;
CREATE TABLE Bill(
    Id int NOT NULL AUTO_INCREMENT,
    UserId int NOT NULL,
    StorageId int NULL,
    DomainId int NULL,
    Date datetime NOT NULL DEFAULT NOW(),
    Deadline datetime NOT NULL DEFAULT DATE_ADD(NOW(), INTERVAL 1 MONTH),
    Cost decimal NOT NULL,
    BillId varchar(100) NOT NULL,
    PRIMARY KEY (Id),
    UNIQUE KEY (BillId),
    FOREIGN KEY (UserId) REFERENCES User(Id),
    FOREIGN KEY (StorageId) REFERENCES Storage(Id),
    FOREIGN KEY (DomainId) REFERENCES Domain(Id)
);

DROP TABLE IF EXISTS Payment;
CREATE TABLE Payment(
    Id int NOT NULL AUTO_INCREMENT,
    UserId int NOT NULL,
    Date datetime NOT NULL DEFAULT NOW(),
    TransactionId varchar(100) NOT NULL,
    BillId int NOT NULL,
    PRIMARY KEY (Id),
    UNIQUE KEY (TransactionId),
    FOREIGN KEY (UserId) REFERENCES User(Id),
    FOREIGN KEY (BillId) REFERENCES Bill(Id)
);

DROP TABLE IF EXISTS Statistic;
CREATE TABLE Statistic(
    Id int NOT NULL AUTO_INCREMENT,
    DomainId int NOT NULL,
    Month DATE NOT NULL,
    Views int NOT NULL DEFAULT 0,
    UniqueViewers int NOT NULL DEFAULT 0,
    PRIMARY KEY (Id),
    UNIQUE KEY (DomainId, Month),
    FOREIGN KEY (DomainId) REFERENCES Domain(Id)
);

DROP TABLE IF EXISTS Notification;
CREATE TABLE Notification(
    Id int NOT NULL AUTO_INCREMENT,
    UserId int NOT NULL,
    StorageId int NULL,
    DomainId int NULL,
    Creation datetime NOT NULL DEFAULT NOW(),
    TimeFrameStart datetime NULL,
    TimeFrameEnd datetime NULL,
    Title varchar(100) NOT NULL,
    Message longtext NOT NULL,
    PRIMARY KEY (Id),
    FOREIGN KEY (UserId) REFERENCES User(Id),
    FOREIGN KEY (StorageId) REFERENCES Storage(Id),
    FOREIGN KEY (DomainId) REFERENCES Domain(Id)
);