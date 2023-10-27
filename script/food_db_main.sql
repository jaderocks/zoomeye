/*
 Navicat Premium Data Transfer

 Source Server         : food
 Source Server Type    : SQLite
 Source Server Version : 3035005 (3.35.5)
 Source Schema         : main

 Target Server Type    : SQLite
 Target Server Version : 3035005 (3.35.5)
 File Encoding         : 65001

 Date: 26/10/2023 00:02:50
*/

PRAGMA foreign_keys = false;

-- ----------------------------
-- Table structure for additive
-- ----------------------------
DROP TABLE IF EXISTS "additive";
CREATE TABLE "additive" (
  "id" text NOT NULL,
  "name" TEXT,
  "serial_no" text,
  "category" TEXT,
  "max" TEXT,
  "note" TEXT,
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS "category";
CREATE TABLE "category" (
  "id" text NOT NULL,
  "name" text,
  "desc" TEXT,
  "additives" JSON,
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Table structure for disease
-- ----------------------------
DROP TABLE IF EXISTS "disease";
CREATE TABLE "disease" (
  "id" text NOT NULL,
  "name" TEXT,
  "harm" TEXT,
  "level" TEXT,
  "source" TEXT,
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Table structure for enzyme
-- ----------------------------
DROP TABLE IF EXISTS "enzyme";
CREATE TABLE "enzyme" (
  "id" text NOT NULL,
  "cn_name" TEXT,
  "en_name" TEXT,
  "source" TEXT,
  "donor" TEXT,
  "note" TEXT,
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Table structure for forbid
-- ----------------------------
DROP TABLE IF EXISTS "forbid";
CREATE TABLE "forbid" (
  "id" text NOT NULL,
  "name" TEXT,
  "food" TEXT,
  "check_method" TEXT,
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Table structure for processing
-- ----------------------------
DROP TABLE IF EXISTS "processing";
CREATE TABLE "processing" (
  "id" text NOT NULL,
  "cn_name" TEXT,
  "en_name" TEXT,
  "function" TEXT,
  "scope" TEXT,
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Table structure for spices
-- ----------------------------
DROP TABLE IF EXISTS "spices";
CREATE TABLE "spices" (
  "id" text NOT NULL,
  "type" TEXT,
  "name" TEXT,
  PRIMARY KEY ("id")
);

PRAGMA foreign_keys = true;
