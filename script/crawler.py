import requests
from requests_html import AsyncHTMLSession
import asyncio
import sqlite3
import re

session = AsyncHTMLSession()


async def parse(isCN=False):
    r = await session.get('https://www.fao.org/gsfaonline/additives/index.html?lang=zh')
    results = []
    # 获取首页新闻标签、图片、标题、发布时间
    for x in r.html.find('.zhList'):
        results.append({
            'text': x.text,
            'link': x.attrs['href']
        })

        print("Start to fetch {}, {}...", x.text, x.attrs['href'])
        await getCSVOfAdditive(x.text, 'https://www.fao.org' + x.attrs['href'], isCN=isCN)


async def getCSVOfAdditive(name, link, isCN=False):
    targetURL = link + '&lang=zh' if isCN else '&csv=1'
    filename= './csv/{0}{1}.csv'.format('cn/' if isCN else '', name)

    print("Start to genenrate: ", filename)
    if isCN:
        r = await session.get(targetURL)
        csvString = []
        tableSource = r.html.find("#allowances")
        if tableSource:
            for tr in tableSource[0].find("tr"):
                content = re.sub(r'(\n+)', r',', tr.text)
                
                csvString.append(content)

                if content:
                    with open(filename, 'w', encoding="utf-8") as file:
                        file.write('\n'.join(csvString))
    else:
        sess = requests.Session()
        adapter = requests.adapters.HTTPAdapter(max_retries= 20)
        sess.mount('http://', adapter)

        r = requests.get(targetURL)
        r.encoding = r.apparent_encoding
        if r.content:
            with open(filename, 'w', encoding="utf-8") as file:
                file.write(r.text)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(parse(isCN=True))
