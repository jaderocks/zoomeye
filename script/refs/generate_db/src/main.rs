use std::path::Path;
// use anyhow::Error;

use std::env::args;
use std::time::SystemTime;
use std::fs;
use std::collections::HashMap;

use pdf::file::{FileOptions};
use pdf::object::*;
use pdf::primitive::Primitive;
use pdf::error::PdfError;
use pdf::enc::StreamFilter;

struct Table {
    id: i64,
    name: String,
    data: String,
}

fn read_pdf(path: &str) -> Result<(), PdfError>{
    let path = args().nth(1).expect("no file given");
    println!("read: {}", path);
    let now = SystemTime::now();

    let file = FileOptions::cached().open(&path).unwrap();
    if let Some(ref info) = file.trailer.info_dict {
        let title = info.get("Title").and_then(|p| p.to_string_lossy().ok());
        let author = info.get("Author").and_then(|p| p.to_string_lossy().ok());

        let descr = match (title, author) {
            (Some(title), None) => title,
            (None, Some(author)) => format!("[no title] – {}", author),
            (Some(title), Some(author)) => format!("{} – {}", title, author),
            _ => "PDF".into()
        };
        println!("{}", descr);
    }

    let mut images: Vec<_> = vec![];
    let mut fonts = HashMap::new();

    for page in file.pages() {
        let page = page.unwrap();
        let resources = page.resources().unwrap();
        
        for (i, font) in resources.fonts.values().enumerate() {
            let name = match &font.name {
                Some(name) => name.as_str().into(),
                None => i.to_string(),
            };
            fonts.insert(name, font.clone());
        }
        images.extend(resources.xobjects.iter().map(|(_name, &r)| file.get(r).unwrap())
            .filter(|o| matches!(**o, XObject::Image(_)))
        );
    }

    for (i, o) in images.iter().enumerate() {
        let img = match **o {
            XObject::Image(ref im) => im,
            _ => continue
        };
        let (data, filter) = img.raw_image_data(&file)?;
        let ext = match filter {
            Some(StreamFilter::DCTDecode(_)) => "jpeg",
            Some(StreamFilter::JBIG2Decode) => "jbig2",
            Some(StreamFilter::JPXDecode) => "jp2k",
            _ => continue,
        };

        let fname = format!("extracted_image_{}.{}", i, ext);
        
        fs::write(fname.as_str(), data).unwrap();
        println!("Wrote file {}", fname);
    }
    println!("Found {} image(s).", images.len());


    // for (name, font) in fonts.iter() {
    //     let fname = format!("font_{}", name);
    //     if let Some(Ok(data)) = font.embedded_data(&file) {
    //         fs::write(fname.as_str(), data).unwrap();
    //         println!("Wrote file {}", fname);
    //     }
    // }
    println!("Found {} font(s).", fonts.len());

    if let Some(ref forms) = file.get_root().forms {
        println!("Forms:");
        for field in forms.fields.iter() {
            print!("  {:?} = ", field.name);
            match field.value {
                Primitive::String(ref s) => println!("{}", s.to_string_lossy()),
                Primitive::Integer(i) => println!("{}", i),
                Primitive::Name(ref s) => println!("{}", s),
                ref p => println!("{:?}", p),
            }
        }
    }

    if let Ok(elapsed) = now.elapsed() {
        println!("Time: {}s", elapsed.as_secs() as f64
                 + elapsed.subsec_nanos() as f64 * 1e-9);
    }
    Ok(())
}

// fn parse_table_data(pdf_file: &Path) -> Result<Vec<Table>, anyhow::Error> {
//     // 打开 PDF 文件
//     let mut reader = pdf::Reader::open(pdf_file)?;

//     // 创建一个表格数据列表
//     let mut tables = Vec::new();

//     // 遍历 PDF 中的所有页面
//     for page in reader.pages() {
//         // 遍历页面中的所有表格
//         for table in page.tables() {
//             // 创建一个新的表格数据对象
//             let table_data = Table {
//                 id: tables.len() as i64 + 1,
//                 name: table.name(),
//                 data: table.data().join("\n"),
//             };

//             // 将表格数据添加到列表中
//             tables.push(table_data);
//         }
//     }

//     // 关闭 PDF 文件
//     reader.close()?;

//     Ok(tables)
// }

// fn insert_table_data(tables: Vec<Table>, db: &sqlite3::Connection) -> Result<(), anyhow::Error> {
//     // 创建一个 SQL 语句
//     let sql = "INSERT INTO tables (id, name, data) VALUES (?, ?, ?)";

//     // 遍历表格数据
//     for table in tables {
//         // 创建一个绑定参数列表
//         let bindings = [
//             table.id,
//             table.name,
//             table.data,
//         ];

//         // 执行 SQL 语句
//         db.execute(sql, &bindings)?;
//     }

//     Ok(())
// }

fn main() {
    // 获取 PDF 文件
    let pdf_file = "pdf-sample.pdf";

    read_pdf(pdf_file);
    // // 解析 PDF 中的表格数据
    // let tables = parse_table_data(pdf_file)?;

    // // 创建 SQLite 数据库
    // let db = sqlite3::open("food");

    // // 将表格数据插入到 SQLite 数据库中
    // insert_table_data(tables, &db);

    // 关闭 SQLite 数据库
    // db.close()?;
}
