import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import '../util/db_helper.dart';
import 'view.list.dart';

part 'model.g.dart';
part 'model.g.view.dart';

// Define the 'tableCategory' constant as SqfEntityTable for the category table
const tableAdditive = SqfEntityTable(
    tableName: 'additive',
    primaryKeyName: 'id',
    // primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    modelName:
        null, // SqfEntity will set it to TableName automatically when the modelName (class name) is null
    // declare fields
    fields: [
      SqfEntityField('name', DbType.text),
      SqfEntityField('serial_no', DbType.text),
      SqfEntityField('category', DbType.text),
      SqfEntityField('max', DbType.text),
      SqfEntityField('note', DbType.text),
      SqfEntityField('isActive', DbType.bool, defaultValue: true),
    ],
    formListSubTitleField: '');

// Define the 'tableEazyme' constant as SqfEntityTable for the category table
const tableEnzyme = SqfEntityTable(
    tableName: 'enzyme',
    primaryKeyName: 'id',
    // primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    primaryKeyType: PrimaryKeyType.text,
    useSoftDeleting: true,
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    modelName:
        null, // SqfEntity will set it to TableName automatically when the modelName (class name) is null
    // declare fields
    fields: [
      SqfEntityField('cn_name', DbType.text),
      SqfEntityField('en_name', DbType.text),
      SqfEntityField('source', DbType.text),
      SqfEntityField('note', DbType.text),
    ],
    formListSubTitleField: '');

// Define the 'tableProcessing' constant as SqfEntityTable for the category table
const tableProcessing = SqfEntityTable(
    tableName: 'processing',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.text,
    // primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    modelName:
        null, // SqfEntity will set it to TableName automatically when the modelName (class name) is null
    // declare fields
    fields: [
      SqfEntityField('cn_name', DbType.text),
      SqfEntityField('en_name', DbType.text),
      SqfEntityField('function', DbType.text),
      SqfEntityField('scope', DbType.text),
    ],
    formListSubTitleField: '');

// Define the 'tableProcessing' constant as SqfEntityTable for the category table
const tableSpices = SqfEntityTable(
    tableName: 'spices',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.text,
    // primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    modelName:
        null, // SqfEntity will set it to TableName automatically when the modelName (class name) is null
    // declare fields
    fields: [
      SqfEntityField('type', DbType.text),
      SqfEntityField('name', DbType.text),
    ],
    formListSubTitleField: '');

// Define the 'identity' constant as SqfEntitySequence.
const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
  //maxValue:  10000, /* optional. default is max int (9.223.372.036.854.775.807) */
  //modelName: 'SQEidentity',
  /* optional. SqfEntity will set it to sequenceName automatically when the modelName is null*/
  //cycle : false,    /* optional. default is false; */
  //minValue = 0;     /* optional. default is 0 */
  //incrementBy = 1;  /* optional. default is 1 */
  // startWith = 0;   /* optional. default is 0 */
);

// STEP 2: Create your Database Model constant instanced from SqfEntityModel
// Note: SqfEntity provides support for the use of multiple databases.
// So you can create many Database Models and use them in the application.
@SqfEntityBuilder(foodModel)
const foodModel = SqfEntityModel(
    modelName: 'FoodModel',
    databaseName: 'food_cn.db',
    password:
        null, // You can set a password if you want to use crypted database (For more information: https://github.com/sqlcipher/sqlcipher)
    // put defined tables into the tables list.
    databaseTables: [tableAdditive, tableEnzyme, tableProcessing, tableSpices],
    // You can define tables to generate add/edit view forms if you want to use Form Generator property
    formTables: [tableAdditive],
    // put defined sequences into the sequences list.
    sequences: [seqIdentity],
    dbVersion: 2,
    // This value is optional. When bundledDatabasePath is empty then
    // EntityBase creats a new database when initializing the database
    bundledDatabasePath: 'script/food_cn.db', //         'assets/sample.db'
    // This value is optional. When databasePath is null then
    // EntityBase uses the default path from sqflite.getDatabasesPath()
    // If you want to set a physically path just set a directory like: '/Volumes/Repo/MyProject/db',
    databasePath: null,
    defaultColumns: [
      SqfEntityField('dateCreated', DbType.datetime,
          defaultValue: 'DateTime.now()'),
    ]);

/* STEP 3: That's All.. 
--> Go Terminal Window and run command below
    flutter pub run build_runner build --delete-conflicting-outputs
  Note: After running the command Please check lib/model/model.g.dart and lib/model/model.g.view.dart (If formTables parameter is defined in the model)
  Enjoy.. Huseyin TOKPINAR
*/