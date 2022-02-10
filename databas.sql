
drop database 220volt;
create database 220volt;

use 220volt;

CREATE TABLE `competition` (
  `Name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Date` datetime(6) NOT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `construction` (
  `Serial` int NOT NULL,
  `Hardness` int NOT NULL,
  PRIMARY KEY (`Serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `rain` (
  `Type`  varchar(30) CHARACTER SET utf8mb4 NOT NULL,
  `WindSpeed` double NOT NULL,
  PRIMARY KEY (`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `player` (
  `SSNR` bigint NOT NULL,
  `Name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Age` int NOT NULL,
  PRIMARY KEY (`SSNR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `player_competition` (
  `player_SSNR` bigint NOT NULL,
  `competition_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL, 
  CONSTRAINT `player_competition_competion` FOREIGN KEY (`competition_name`) REFERENCES  `competition`(`Name`),
  CONSTRAINT `player_competition_player` FOREIGN KEY (`player_SSNR`) REFERENCES `Player` (`SSNR`),
  CONSTRAINT player_competition_unique unique (player_SSNR,competition_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE `competition_rain` (
  `CompetitionId` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `RainId` varchar(30) NOT NULL,
  `Date` datetime(6) NOT NULL,
  PRIMARY KEY (`CompetitionId`,`RainId`),
  KEY `IX_CompetitionRain_RainId` (`RainId`),
  CONSTRAINT `FK_CompetitionRain_Competitions_CompetitionId` FOREIGN KEY (`CompetitionId`) REFERENCES `competition` (`Name`) ,
  CONSTRAINT `FK_CompetitionRain_Rain_RainId` FOREIGN KEY (`RainId`) REFERENCES `rain` (`Type`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `clubs` (
  `Nr` int NOT NULL,
  `Player` bigint NOT NULL,
  `Material` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ConstructionSerial` int DEFAULT NULL,
  PRIMARY KEY (`Nr`,`Player`),
  KEY `IX_Clubs_ConstructionSerial` (`ConstructionSerial`),
  KEY `IX_Clubs_Player` (`Player`),
  CONSTRAINT `FK_Clubs_Construction_ConstructionSerial` FOREIGN KEY (`ConstructionSerial`) REFERENCES `construction` (`Serial`),
  CONSTRAINT `FK_Clubs_Player_Player` FOREIGN KEY (`Player`) REFERENCES `player` (`SSNR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `jacket` (
  `initialer` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Size` int NOT NULL,
  `Material` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Player` bigint NOT NULL,
  PRIMARY KEY (`initialer`,`player`),
  KEY `IX_Jackets_Player` (`Player`),
  CONSTRAINT `FK_Jackets_Player_Player` FOREIGN KEY (`Player`) REFERENCES `player` (`SSNR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into player(SSNR,Name,age) values (7103031111,"Johan Andersson", 25); 
insert into player(SSNR,Name,age) values (7103041111,"Nicklas Jansson", 50); 
insert into player(SSNR,Name,age) values (7103051111,"Annika Persson", 70);
insert into competition (Name,Date) values ("Big Golf Cup Skövde", DATE('2021-10-6'));

insert into player_competition values(7103031111,"Big Golf Cup Skövde"); 
insert into player_competition values(7103041111,"Big Golf Cup Skövde"); 
insert into player_competition values(7103051111,"Big Golf Cup Skövde"); 

insert into rain values ("Hagel",10);

insert into competition_rain values ("Big Golf Cup Skövde", "Hagel", DATE('2021-10-6'));

-- BLir lite konstigt när initialer och player är primary, man borde ha samma för varje jacka..
insert into jacket values("JA",2,"Fleece",7103031111);
insert into jacket values("JB",2,"Gortech",7103031111);

insert into construction values(1,10);
insert into construction values(2,5);

insert into clubs values(1,7103041111,"trä",1);
insert into clubs values(2,7103051111,"trä",2);
 
 
 select age from player where name like("Johan Andersson");
 select date from competition where name like("Big Golf Cup Skövde");
-- Johan har ingen klubba
select material from clubs where Player = (Select SSNR from player where name like ("Johan Andersson"));
select * from jacket where Player = (Select SSNR from player where name like ("Johan Andersson"));

select * from player where player.ssnr in 
		(select player_SSNR from player_competition where competition_name like ("Big Golf Cup Skövde")); 

select WindSpeed from rain where rain.Type in 
	(select RainID from competition_rain where CompetitionId like("Big Golf Cup Skövde"));
    
    
select * from player where age <30;    

delete from jacket where Player= (select SSNR from player where name like ("Johan Andersson"));

-- SET SQL_SAFE_UPDATES=0;
delete from player_competition where player_SSNR =  (select SSNR from player where name like ("Johan Andersson"));
delete from clubs where player = (select SSNR from player where name like ("Johan Andersson"));

delete from player where name like ("Johan Andersson");
    