
import csv
import os
import re
import sqlite3
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


class Eazyme:
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
        
def insert_additive_data(db: sqlite3.Connection) -> None:
    cursor = db.cursor()
    cursor.execute("DELETE from additive")

    # 创建一个 SQL 语句
    sql = "INSERT INTO additive (id, name, serial_no, category, max, note) VALUES (?, ?, ?, ?, ?, ?)"
    
    tables: list[Additive] = []

    # read additive data from csv files inside additive folder  
    rootdir = 'csv/additive/cn'
    for subdir, dirs, files in os.walk(rootdir):
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
                    tables.append(Additive(
                        str(uuid.uuid4()), add_name, ensure_row.get(0), ensure_row.get(1),  ensure_row.get(2),  ensure_row.get(3)
                    ))
    # 遍历表格数据
    for table in tables:
        # 创建一个绑定参数列表
        bindings = [table.id, table.name, table.serial_no, table.category, table.max, table.note]

        print(bindings)

        # 执行 SQL 语句
        cursor.execute(sql, bindings)

def updateCN():
      # # 创建 SQLite 数据库
    db = sqlite3.connect("food_cn.db")

    # # 将表格数据插入到 SQLite 数据库中
    insert_additive_data(db)
    
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