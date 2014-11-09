-- MySQL Script generated by MySQL Workbench
-- 11/08/14 18:48:47
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema powon
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema powon
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `powon` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `powon` ;

-- -----------------------------------------------------
-- Table `powon`.`member`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`member` (
  `powon_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `address` MEDIUMTEXT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `dob` DATE NOT NULL,
  `description` LONGTEXT NULL,
  `status` ENUM('active','inactive','suspended') NOT NULL DEFAULT 'active',
  `privilege` ENUM('member','admin') NOT NULL DEFAULT 'member',
  PRIMARY KEY (`powon_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `powon_id_UNIQUE` (`powon_id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`message_recieved`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`message_recieved` (
  `message_id` INT NOT NULL AUTO_INCREMENT,
  `content` LONGTEXT NULL,
  `date` DATETIME NOT NULL,
  `reciever_powon_id` INT NOT NULL,
  `sender_powon_id` INT NOT NULL,
  PRIMARY KEY (`message_id`, `reciever_powon_id`),
  INDEX `fk_message_recieved_member1_idx` (`reciever_powon_id` ASC),
  CONSTRAINT `fk_message_recieved_member1`
    FOREIGN KEY (`reciever_powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`group` (
  `group_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `powon_id` INT NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`member_of_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`member_of_group` (
  `group_id` INT NOT NULL,
  `powon_id` INT NOT NULL,
  PRIMARY KEY (`group_id`, `powon_id`),
  INDEX `fk_group_has_member_member1_idx` (`powon_id` ASC),
  INDEX `fk_group_has_member_group1_idx` (`group_id` ASC),
  CONSTRAINT `fk_group_has_member_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `powon`.`group` (`group_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_member_member1`
    FOREIGN KEY (`powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`thread`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`thread` (
  `thread_id` INT NOT NULL AUTO_INCREMENT,
  `thead_name` VARCHAR(75) NULL,
  `group_id` INT NOT NULL,
  `powon_id` INT NOT NULL,
  PRIMARY KEY (`thread_id`, `group_id`, `powon_id`),
  INDEX `fk_thread_group1_idx` (`group_id` ASC),
  INDEX `fk_thread_member1_idx` (`powon_id` ASC),
  CONSTRAINT `fk_thread_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `powon`.`group` (`group_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_thread_member1`
    FOREIGN KEY (`powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`member_has_thread_access`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`member_has_thread_access` (
  `powon_id` INT NOT NULL,
  `thread_id` INT NOT NULL,
  `restriction` ENUM('restricted','unrestricted_comment','unrestricted_no_comment') NOT NULL DEFAULT 'unrestricted_no_comment',
  PRIMARY KEY (`powon_id`, `thread_id`),
  INDEX `fk_member_has_thread_thread1_idx` (`thread_id` ASC),
  INDEX `fk_member_has_thread_member1_idx` (`powon_id` ASC),
  CONSTRAINT `fk_member_has_thread_member1`
    FOREIGN KEY (`powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_member_has_thread_thread1`
    FOREIGN KEY (`thread_id`)
    REFERENCES `powon`.`thread` (`thread_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`post` (
  `post_id` INT NOT NULL AUTO_INCREMENT,
  `content` LONGTEXT NULL,
  `date` DATETIME NOT NULL,
  `powon_id` INT NOT NULL,
  `thread_id` INT NOT NULL,
  PRIMARY KEY (`post_id`, `powon_id`, `thread_id`),
  INDEX `fk_post_member1_idx` (`powon_id` ASC),
  INDEX `fk_post_thread1_idx` (`thread_id` ASC),
  CONSTRAINT `fk_post_member1`
    FOREIGN KEY (`powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_thread1`
    FOREIGN KEY (`thread_id`)
    REFERENCES `powon`.`thread` (`thread_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`join_request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`join_request` (
  `group_id` INT NOT NULL,
  `powon_id` INT NOT NULL,
  PRIMARY KEY (`group_id`, `powon_id`),
  INDEX `fk_group_has_member1_member1_idx` (`powon_id` ASC),
  INDEX `fk_group_has_member1_group1_idx` (`group_id` ASC),
  CONSTRAINT `fk_group_has_member1_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `powon`.`group` (`group_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_member1_member1`
    FOREIGN KEY (`powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`member_relates_member`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`member_relates_member` (
  `powon_id` INT NOT NULL,
  `relates_powon_id` INT NOT NULL,
  `family` TINYINT(1) NOT NULL DEFAULT 0,
  `friend` TINYINT(1) NOT NULL DEFAULT 0,
  `colleague` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`powon_id`, `relates_powon_id`),
  INDEX `fk_member_has_member_member2_idx` (`relates_powon_id` ASC),
  INDEX `fk_member_has_member_member1_idx` (`powon_id` ASC),
  CONSTRAINT `fk_member_has_member_member1`
    FOREIGN KEY (`powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_member_has_member_member2`
    FOREIGN KEY (`relates_powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`message_sent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`message_sent` (
  `message_sent_id` INT NOT NULL AUTO_INCREMENT,
  `content` LONGTEXT NULL,
  `date` DATETIME NULL,
  `sender_powon_id` INT NOT NULL,
  `reciever_powon_id` INT NOT NULL,
  PRIMARY KEY (`message_sent_id`, `sender_powon_id`),
  INDEX `fk_message_sent_member1_idx` (`sender_powon_id` ASC),
  CONSTRAINT `fk_message_sent_member1`
    FOREIGN KEY (`sender_powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `powon`.`public_post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `powon`.`public_post` (
  `public_post_id` INT NOT NULL AUTO_INCREMENT,
  `content` LONGTEXT NULL,
  `date` DATETIME NOT NULL,
  `powon_id` INT NOT NULL,
  PRIMARY KEY (`public_post_id`, `powon_id`),
  INDEX `fk_public_post_member1_idx` (`powon_id` ASC),
  CONSTRAINT `fk_public_post_member1`
    FOREIGN KEY (`powon_id`)
    REFERENCES `powon`.`member` (`powon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
