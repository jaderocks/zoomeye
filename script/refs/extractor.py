from pypdf import PdfReader
import sqlite3

class Table:
    id: int
    name: str
    data: str

    def __init__(self, id: int, name: str, data: str):
        self.id = id
        self.name = name
        self.data = data

def insert_table_data(tables: list[Table], db: sqlite3.Connection) -> None:
    # 创建一个 SQL 语句
    sql = "INSERT INTO tables (id, name, data) VALUES (?, ?, ?)"

    # 遍历表格数据
    for table in tables:
        # 创建一个绑定参数列表
        bindings = [table.id, table.name, table.data]

        # 执行 SQL 语句
        db.execute(sql, bindings)

def process(filePath):
    reader = PdfReader(filePath)
    parts = []

    def visitor_body(text, cm, tm, font_dict, font_size):
        content = text.strip()

        if content:
            parts.append(text)
            print('text: ' + text, font_dict, ', fontsize: ' + str(font_size))

    for page in reader.pages:
        if(page.page_number < 5):
            continue
        
        if page.page_number == 5:
            print(page.page_number)

            page.extract_text(visitor_text=visitor_body)
        else:
            continue

    print("\n".join(parts))

def main() -> None:
    process("./21_2632_00_x.pdf")
    # # 创建 SQLite 数据库
    # db = sqlite3.connect("food.db")

    # # 将表格数据插入到 SQLite 数据库中
    # insert_table_data(tables, db)

    # # 关闭 SQLite 数据库
    # db.close()

if __name__ == "__main__":
    main()

