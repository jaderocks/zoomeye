import 'dart:io';
import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:dart_pdf_reader/src/model/pdf_page.dart';
import 'package:sqlite3/sqlite3.dart';

class Table {
  int id;
  String name;
  String data;

  Table({required this.id, required this.name, required this.data});
}

// 定义解析 PDF 中的表格数据函数
Future<List<Table>> parseTableData(File pdfFile) async {
  // 打开 PDF 文件
  // 读取 PDF 文件
  final bytes = pdfFile.readAsBytesSync();

  // 创建 PDF 读取器
  final stream = ByteStream(bytes);
  final doc = await PDFParser(stream).parse();
  final catalog = await doc.catalog;
  final pages = await catalog.getPages();
  final outlines = await catalog.getOutlines();
  int pageCount = pages.pageCount;

  print(outlines);

  // 创建一个表格数据列表
  final tables = <Table>[];

  // 遍历 PDF 中的所有页面
  for (var page in Iterable.generate(pageCount)) {
    PDFPageNode? currPage = pages.getPageAtIndex(page);

    while (currPage != null) {
      print(await currPage.resources);
      currPage = currPage.parent;
    }

    // 遍历页面中的所有表格
    // for (var table in page.tables) {
    //   // 创建一个新的表格数据对象
    //   final tableData = Table(
    //     id: table.id,
    //     name: table.name,
    //     data: table.data.join("\n"),
    //   );

    //   // 检查表格数据中的单元格是否为空
    //   for (var row in table.rows) {
    //     for (var cell in row.cells) {
    //       if (cell.text == null) {
    //         cell.text = "";
    //       }
    //     }
    //   }

    //   // 检查表格数据中的行是否为空
    //   if (table.rows.isEmpty) {
    //     tableData.data = "";
    //   }

    //   // 检查表格数据中的页面是否为空
    //   if (page.tables.isEmpty) {
    //     tableData.name = "";
    //   }

    //   // 将表格数据添加到列表中
    //   tables.add(tableData);
    // }
  }

  // 关闭 PDF 文件
  // await pdfOpened.close();

  return tables;
}

// 定义将表格数据插入到 SQLite 数据库中的函数
// Future<void> insertTableData(List<Table> tables, Database db) async {
//   // 创建一个 SQL 语句
//   final sql = "INSERT INTO tables (id, name, data) VALUES (?, ?, ?)";

//   // 遍历表格数据
//   for (var table in tables) {
//     // 创建一个绑定参数列表
//     final bindings = [
//       table.id,
//       table.name,
//       table.data,
//     ];

//     // 检查表格数据中的 id 是否重复
//     final tableExists = await db.query(
//       "SELECT * FROM tables WHERE id = ?",
//       [table.id],
//     );

//     if (tableExists.isEmpty) {
//       // 执行 SQL 语句
//       await db.execute(sql, bindings);
//     }
//   }
// }

// 主函数
void main() async {
  // 获取 PDF 文件
  final pdfFile = File("21_2632_00_x.pdf");

  // 解析 PDF 中的表格数据
  final tables = await parseTableData(pdfFile);

  // 创建 SQLite 数据库
  // final db =
  //     await openDatabase("tables.db", version: 1, onCreate: (db, version) {
  //   // 创建表格
  //   db.execute(
  //       "CREATE TABLE tables (id INTEGER PRIMARY KEY, name TEXT, data TEXT)");
  // });

  // // 将表格数据插入到 SQLite 数据库中
  // await insertTableData(tables, db);

  // // 关闭 SQLite 数据库
  // await db.close();
}
