struct Table {
    id: i64,
    name: String,
    data: String,
}

fn parse_table_data(pdf_file: &Path) -> Result<Vec<Table>, anyhow::Error> {
    // 打开 PDF 文件
    let mut reader = pdf::Reader::open(pdf_file)?;

    // 创建一个表格数据列表
    let mut tables = Vec::new();

    // 遍历 PDF 中的所有页面
    for page in reader.pages() {
        // 遍历页面中的所有表格
        for table in page.tables() {
            // 创建一个新的表格数据对象
            let table_data = Table {
                id: tables.len() as i64 + 1,
                name: table.name(),
                data: table.data().join("\n"),
            };

            // 将表格数据添加到列表中
            tables.push(table_data);
        }
    }

    // 关闭 PDF 文件
    reader.close()?;

    Ok(tables)
}

fn insert_table_data(tables: Vec<Table>, db: &sqlite3::Connection) -> Result<(), anyhow::Error> {
    // 创建一个 SQL 语句
    let sql = "INSERT INTO tables (id, name, data) VALUES (?, ?, ?)";

    // 遍历表格数据
    for table in tables {
        // 创建一个绑定参数列表
        let bindings = [
            table.id,
            table.name,
            table.data,
        ];

        // 执行 SQL 语句
        db.execute(sql, &bindings)?;
    }

    Ok(())
}

fn main() {
    // 获取 PDF 文件
    let pdf_file = Path::new("../21_2632_00_x.pdf");

    // 解析 PDF 中的表格数据
    let tables = parse_table_data(pdf_file)?;

    // 创建 SQLite 数据库
    // let db = sqlite3::open_in_memory()?;

    // 将表格数据插入到 SQLite 数据库中
    // insert_table_data(tables, &db)?;

    // 关闭 SQLite 数据库
    // db.close()?;

    Ok(())
}
