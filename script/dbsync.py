
import csv
from enum import Enum
import os
import re
import sqlite3
from typing import Union
import uuid


class Additive:
    id: int
    name: str
    serial_no: str
    category: str
    max: str
    note: str

    def __init__(self, id: int, name: str, serial_no: str, category: str, max: str, note: str):
        self.id = id
        self.name = name
        self.serial_no = serial_no
        self.category = category
        self.max = max
        self.note = note


class Enzyme:
    id: int
    cn_name: str
    en_name: str
    source: str # 来源
    donor: str # 供体
    note: str
    
    def __init__(self, id: int, cn_name: str, en_name:str, source:str, donor: str, note: str):
        self.id = id
        self.cn_name = cn_name
        self.en_name = en_name
        self.source = source
        self.donor = donor
        self.note = note


class Processing:  # 加工助剂
    id: int
    cn_name: str
    en_name: str
    function: str # 功能
    scope: str # 使用范围
    
    def __init__(self, id: int, cn_name: str, en_name:str, function:str, scope: str):
        self.id = id
        self.cn_name = cn_name
        self.en_name = en_name
        self.function = function
        self.scope = scope


class Spices:  # 香料
    id: int
    type: str
    name: str
    
    def __init__(self, id: int, type: str, name:str):
        self.id = id
        self.type = type
        self.name = name

class safelist(list):
    def get(self, index, default=''):
        try:
            return self.__getitem__(index)
        except IndexError:
            return default


class FOOD(Enum):
    ADDI = 1
    ENZYME = 2
    PROCESSING = 3
    SPICES = 4

def prepare_data(type=FOOD.ADDI) -> list[Union[Additive, Enzyme, Processing, Spices]]:
    tables: list = []

    if type == FOOD.ADDI:
        root_dir = 'csv/additive/cn'  
    elif type == FOOD.ENZYME:
        root_dir = 'csv/enzyme'  
    elif type == FOOD.PROCESSING:
        root_dir = 'csv/process'  
    else:
        root_dir = 'csv/spices'  

    # read additive data from csv files inside additive folder  
    for subdir, dirs, files in os.walk(root_dir):
        for file in files:
            curr = os.path.join(subdir, file)
            add_name = re.sub(r'([^\(|\)]+)\(.*\)', r'\1', file).replace('.csv', '')

            print(curr, add_name)
            with open(curr, newline='') as csvfile:
                spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
                for idx, row in enumerate(spamreader):
                    if idx == 0:
                        continue
                    ensure_row = safelist(row)

                    if type == FOOD.ADDI:
                        item = Additive(
                            str(uuid.uuid4()), add_name, ensure_row.get(0), ensure_row.get(1),  ensure_row.get(2),  ensure_row.get(3)
                        )
                    elif type == FOOD.ENZYME:
                        item = Enzyme(
                            str(uuid.uuid4()), ensure_row.get(0), ensure_row.get(1),  
                            ensure_row.get(2),  ensure_row.get(3), ensure_row.get(4)
                        )
                    elif type == FOOD.PROCESSING:
                        item = Processing(
                            str(uuid.uuid4()), ensure_row.get(0), ensure_row.get(1),  
                            ensure_row.get(2),  ensure_row.get(3)
                        )
                    else:
                        item = Spices(
                            str(uuid.uuid4()), ensure_row.get(0), ensure_row.get(1)
                        )

                    tables.append(item)
    return tables

def insert_additive_data(db: sqlite3.Connection) -> None:
    cursor = db.cursor()
    cursor.execute("DELETE from additive")

    # 创建一个 SQL 语句
    sql = "INSERT INTO additive (id, name, serial_no, category, max, note) VALUES (?, ?, ?, ?, ?, ?)"
    tables: list[Additive] = prepare_data(FOOD.ADDI)

    # 遍历表格数据
    for table in tables:
        # 创建一个绑定参数列表
        bindings = [table.id, table.name, table.serial_no, table.category, table.max, table.note]

        print(bindings)

        # 执行 SQL 语句
        cursor.execute(sql, bindings)

def insert_enzyme_data(db: sqlite3.Connection) -> None:
    cursor = db.cursor()
    cursor.execute("DELETE from enzyme")

    # 创建一个 SQL 语句
    sql = "INSERT INTO enzyme (id, cn_name, en_name, source, donor, note) VALUES (?, ?, ?, ?, ?, ?)"
    tables: list[Enzyme] = prepare_data(FOOD.ENZYME)

    # 遍历表格数据
    for table in tables:
        # 创建一个绑定参数列表
        bindings = [table.id, table.cn_name, table.en_name, table.source, table.donor, table.note]

        print(bindings)

        # 执行 SQL 语句
        cursor.execute(sql, bindings)

def insert_processing_data(db: sqlite3.Connection) -> None:
    cursor = db.cursor()
    cursor.execute("DELETE from processing")

    # 创建一个 SQL 语句
    sql = "INSERT INTO processing (id, cn_name, en_name, function, scope) VALUES (?, ?, ?, ?, ?)"
    tables: list[Processing] = prepare_data(FOOD.PROCESSING)

    # 遍历表格数据
    for table in tables:
        # 创建一个绑定参数列表
        bindings = [table.id, table.cn_name, table.en_name, table.function, table.scope]

        print(bindings)

        # 执行 SQL 语句
        cursor.execute(sql, bindings)

def insert_spices_data(db: sqlite3.Connection) -> None:
    cursor = db.cursor()
    cursor.execute("DELETE from spices")

    # 创建一个 SQL 语句
    sql = "INSERT INTO spices (id, type, name) VALUES (?, ?, ?)"
    tables: list[Spices] = prepare_data(FOOD.SPICES)

    # 遍历表格数据
    for table in tables:
        # 创建一个绑定参数列表
        bindings = [table.id, table.type, table.name]

        print(bindings)

        # 执行 SQL 语句
        cursor.execute(sql, bindings)

def updateCN():
      # # 创建 SQLite 数据库
    db = sqlite3.connect("food_cn.db")

    # # 将表格数据插入到 SQLite 数据库中
    insert_additive_data(db)
    insert_enzyme_data(db)
    insert_processing_data(db)
    insert_spices_data(db)
    
    db.commit()

    # # 关闭 SQLite 数据库
    db.close()

def updateEN():
    pass
    # # 创建 SQLite 数据库
    # db = sqlite3.connect("food_en.db")

    # # # 将表格数据插入到 SQLite 数据库中
    # insert_table_data(tables, db)

    # # # 关闭 SQLite 数据库
    # db.close()

if __name__ == '__main__':
    updateCN()