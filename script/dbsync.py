
import sqlite3


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


def insert_table_data(tables: list[Additive], db: sqlite3.Connection) -> None:
    # 创建一个 SQL 语句
    sql = "INSERT INTO tables (id, name, data) VALUES (?, ?, ?)"

    # 遍历表格数据
    for table in tables:
        # 创建一个绑定参数列表
        bindings = [table.id, table.name, table.data]

        # 执行 SQL 语句
        db.execute(sql, bindings)

def updateCN():
      # # 创建 SQLite 数据库
    db = sqlite3.connect("food_cn.db")

    # # 将表格数据插入到 SQLite 数据库中
    insert_table_data(tables, db)

    # # 关闭 SQLite 数据库
    db.close()

def updateEN():
      # # 创建 SQLite 数据库
    db = sqlite3.connect("food_en.db")

    # # 将表格数据插入到 SQLite 数据库中
    insert_table_data(tables, db)

    # # 关闭 SQLite 数据库
    db.close()

if __name__ == '__main__':
    updateCN()
    updateEN()