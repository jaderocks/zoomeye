from pypdf import PdfReader

reader = PdfReader("./21_2632_00_x.pdf")
parts = []

def visitor_body(text, cm, tm, font_dict, font_size):
    content = text.strip()

    if content:
        parts.append(content)
        print('text: ' + content, ', fontsize: ' + str(font_size))

for page in reader.pages:
    if(page.page_number < 5):
        continue
    
    if page.page_number == 5:
        print(page.page_number)

        page.extract_text(visitor_text=visitor_body)
    else:
        continue


print("\n".join(parts))