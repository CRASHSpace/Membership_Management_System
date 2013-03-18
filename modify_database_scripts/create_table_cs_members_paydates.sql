# create table cs_members.paydates

drop table if exists cs_members.paydates;
create table IF NOT EXISTS cs_members.paydates
(
id bigint(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
firstName varchar(50) NOT NULL,
lastName varchar(50) NOT NULL,
paypalName varchar(100),
emailPaypal varchar(100),
memberType enum('OWNER','ORIGINAL','LIFETIME','SUPER','MEMBER','BASIC-PLUS','INTERN'),
paymentDuration enum('MONTHLY','6MONTH','YEARLY','LIFETIME'),
hasKey tinyint(1) NOT NULL, 
isGrandfathered tinyint(1) NOT NULL,
firstPayment datetime NOT NULL,
lastPayment datetime NOT NULL,
paymentDue datetime NOT NULL,
paymentMethod enum('CASH','PAYPAL','AMAZON','CHECK','SQUARE','GOODS','INTERNSHIP','OTHER'),
accountStatus enum('INFO_REQUEST','ACTIVE','LIFETIME','WARNING1','WARNING2','IGNORE','SUSPENDED','DISABLED'),
accountActivityDate datetime
)
ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



