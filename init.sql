SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
CREATE DATABASE IF NOT EXISTS `Dioneo` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `Dioneo`;

DELIMITER $$
DROP PROCEDURE IF EXISTS `RegisterUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RegisterUser`(IN `EmailAddress` VARCHAR(100), IN `Username` VARCHAR(32), IN `Password` TEXT)
    NO SQL
    DETERMINISTIC
INSERT INTO `Users` (`EmailAddress`, `Username`, `Password`)
VALUES (`EmailAddress`, `Username`, SHA2(`Password`, 256))$$

DROP FUNCTION IF EXISTS `Login`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Login`(`Identifier` VARCHAR(100), `Password` TEXT) RETURNS tinyint(1)
    NO SQL
    DETERMINISTIC
RETURN (SELECT `ID`, `Username`
FROM `Users`
WHERE (`Identifier` = `Users`.`EmailAddress`
    OR `Identifier` = `Users`.`Username`)
    AND SHA2(`Password`, 256) = `Users`.`Password`)$$

DROP FUNCTION IF EXISTS `TestEmailAddress`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `TestEmailAddress`(`EmailAddress` VARCHAR(100) CHARSET ascii) RETURNS tinyint(1)
    NO SQL
    DETERMINISTIC
RETURN (`EmailAddress` IN (
    SELECT `EmailAddress`
    FROM `Users`))$$

DROP FUNCTION IF EXISTS `TestUsername`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `TestUsername`(`Username` VARCHAR(32) CHARSET ascii) RETURNS tinyint(1)
    NO SQL
    DETERMINISTIC
RETURN (`Username` IN (
    SELECT `Username`
    FROM `Users`))$$

DELIMITER ;

DROP TABLE IF EXISTS `Advertisements`;
CREATE TABLE IF NOT EXISTS `Advertisements` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL,
  `Type` enum('ESCORT','MASSAGE','DOMINATION') CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `Name` varchar(100) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `Active` tinyint(1) NOT NULL,
  `Gender` enum('FEMALE','MALE','TS','TV') CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `Age` int(10) unsigned DEFAULT NULL,
  `AgeVerified` tinyint(1) NOT NULL DEFAULT '0',
  `NationalityID` int(10) unsigned NOT NULL,
  `NationalityVerified` tinyint(1) NOT NULL DEFAULT '0',
  `Introduction` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UserAndType` (`UserID`,`Type`),
  KEY `UserID` (`UserID`),
  KEY `Active` (`Active`),
  KEY `Gender` (`Gender`),
  KEY `Age` (`Age`),
  KEY `VerifiedAge` (`Age`,`AgeVerified`),
  KEY `NationalityID` (`NationalityID`),
  KEY `VerifiedNationality` (`NationalityID`,`NationalityVerified`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `BlockedUsers`;
CREATE TABLE IF NOT EXISTS `BlockedUsers` (
  `UserID` int(10) unsigned NOT NULL,
  `BlockedID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`UserID`),
  KEY `BlockedID` (`BlockedID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `BlogComments`;
CREATE TABLE IF NOT EXISTS `BlogComments` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `PostID` int(10) unsigned NOT NULL,
  `UserID` int(10) unsigned NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Content` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `PostID` (`PostID`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `BlogPosts`;
CREATE TABLE IF NOT EXISTS `BlogPosts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL,
  `Title` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Content` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `DiscussionNotifications`;
CREATE TABLE IF NOT EXISTS `DiscussionNotifications` (
  `UserID` int(10) unsigned NOT NULL,
  `PostID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`UserID`,`PostID`),
  KEY `UserID` (`UserID`),
  KEY `PostID` (`PostID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `Favorites`;
CREATE TABLE IF NOT EXISTS `Favorites` (
  `UserID` int(10) unsigned NOT NULL,
  `AdvertisementID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`UserID`,`AdvertisementID`),
  KEY `UserID` (`UserID`),
  KEY `AdvertisementID` (`AdvertisementID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ForumDiscussions`;
CREATE TABLE IF NOT EXISTS `ForumDiscussions` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `SectionID` int(10) unsigned NOT NULL,
  `Emoji` char(1) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SectionID` (`SectionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `ForumPosts`;
CREATE TABLE IF NOT EXISTS `ForumPosts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL,
  `SectionID` int(10) unsigned NOT NULL,
  `DiscussionID` int(10) unsigned NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Title` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Content` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Edited` tinyint(1) NOT NULL DEFAULT '0',
  `Editor` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SectionID` (`SectionID`),
  KEY `UserID` (`UserID`),
  KEY `DiscussionID` (`DiscussionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `ForumSections`;
CREATE TABLE IF NOT EXISTS `ForumSections` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `OrderNumber` int(11) NOT NULL,
  `ParentID` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `ParentID` (`ParentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `ForumSubscriptions`;
CREATE TABLE IF NOT EXISTS `ForumSubscriptions` (
  `UserID` int(10) unsigned NOT NULL,
  `DiscussionID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`UserID`,`DiscussionID`),
  KEY `UserID` (`UserID`),
  KEY `DiscussionID` (`DiscussionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `Nationalities`;
CREATE TABLE IF NOT EXISTS `Nationalities` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `Permissions`;
CREATE TABLE IF NOT EXISTS `Permissions` (
  `UserID` int(10) unsigned NOT NULL,
  `Permission` enum('POST','EDIT','DELETE','PERMISSIONS') CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT 'POST = post to forums. EDIT = edit other users'' posts. DELETE = delete other users'' posts. PERMISSIONS = change other users'' permissions (not own).',
  PRIMARY KEY (`UserID`,`Permission`),
  KEY `UserID` (`UserID`),
  KEY `Permission` (`Permission`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `Photos`;
CREATE TABLE IF NOT EXISTS `Photos` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned NOT NULL,
  `Data` blob NOT NULL,
  `Type` char(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `Approved` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `UserID` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `PrivateMessageNotifications`;
CREATE TABLE IF NOT EXISTS `PrivateMessageNotifications` (
  `UserID` int(10) unsigned NOT NULL,
  `MessageID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`UserID`,`MessageID`),
  KEY `UserID` (`UserID`),
  KEY `MessageID` (`MessageID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `PrivateMessages`;
CREATE TABLE IF NOT EXISTS `PrivateMessages` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `SenderID` int(10) unsigned NOT NULL,
  `RecipientID` int(10) unsigned NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Content` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Read` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `PairID` (`SenderID`,`RecipientID`),
  KEY `SenderID` (`SenderID`),
  KEY `RecipientID` (`RecipientID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `ProfilePictures`;
CREATE TABLE IF NOT EXISTS `ProfilePictures` (
  `UserID` int(10) unsigned NOT NULL,
  `Data` blob NOT NULL,
  `Type` char(16) NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `Users`;
CREATE TABLE IF NOT EXISTS `Users` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `EmailAddress` varchar(100) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `Username` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `Password` binary(32) NOT NULL,
  `RecoveryCode` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `RecoveryRequestTime` timestamp NULL DEFAULT NULL,
  `Incognito` tinyint(1) NOT NULL DEFAULT '0',
  `EnablePrivateMessages` tinyint(1) NOT NULL DEFAULT '1',
  `LastAccess` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Username` (`Username`),
  UNIQUE KEY `EmailAddress` (`EmailAddress`),
  UNIQUE KEY `RecoveryCode` (`RecoveryCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `Advertisements`
  ADD CONSTRAINT `Advertisements_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Advertisements_ibfk_2` FOREIGN KEY (`NationalityID`) REFERENCES `Nationalities` (`ID`);

ALTER TABLE `BlockedUsers`
  ADD CONSTRAINT `BlockedUsers_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `BlockedUsers_ibfk_2` FOREIGN KEY (`BlockedID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `BlogComments`
  ADD CONSTRAINT `BlogComments_ibfk_1` FOREIGN KEY (`PostID`) REFERENCES `BlogPosts` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `BlogComments_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `BlogPosts`
  ADD CONSTRAINT `BlogPosts_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `DiscussionNotifications`
  ADD CONSTRAINT `DiscussionNotifications_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `DiscussionNotifications_ibfk_2` FOREIGN KEY (`PostID`) REFERENCES `ForumPosts` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Favorites`
  ADD CONSTRAINT `Favorites_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Favorites_ibfk_2` FOREIGN KEY (`AdvertisementID`) REFERENCES `Advertisements` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `ForumDiscussions`
  ADD CONSTRAINT `ForumDiscussions_ibfk_1` FOREIGN KEY (`SectionID`) REFERENCES `ForumSections` (`ID`);

ALTER TABLE `ForumPosts`
  ADD CONSTRAINT `ForumPosts_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ForumPosts_ibfk_2` FOREIGN KEY (`SectionID`) REFERENCES `ForumSections` (`ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `ForumPosts_ibfk_3` FOREIGN KEY (`DiscussionID`) REFERENCES `ForumDiscussions` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `ForumSections`
  ADD CONSTRAINT `ForumSections_ibfk_1` FOREIGN KEY (`ParentID`) REFERENCES `ForumSections` (`ID`) ON UPDATE CASCADE;

ALTER TABLE `ForumSubscriptions`
  ADD CONSTRAINT `ForumSubscriptions_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ForumSubscriptions_ibfk_2` FOREIGN KEY (`DiscussionID`) REFERENCES `ForumDiscussions` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Permissions`
  ADD CONSTRAINT `Permissions_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Photos`
  ADD CONSTRAINT `Photos_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `PrivateMessageNotifications`
  ADD CONSTRAINT `PrivateMessageNotifications_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `PrivateMessageNotifications_ibfk_2` FOREIGN KEY (`MessageID`) REFERENCES `PrivateMessages` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `PrivateMessages`
  ADD CONSTRAINT `PrivateMessages_ibfk_1` FOREIGN KEY (`SenderID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `PrivateMessages_ibfk_2` FOREIGN KEY (`RecipientID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `ProfilePictures`
  ADD CONSTRAINT `ProfilePictures_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `Users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE;
