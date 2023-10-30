SELECT json('[ 9, 4, 7 ]');

insert into category (id, name, 'desc', 'additives') values ('2','1','1',json('[ "9", 4, 7 ]'))

insert into category (id, name, 'desc', 'additives') 
values ('d09f2c8b-8285-4196-86a2-2bb3b12ec4a7', 
	'着色剂', '着色剂又称食品色素，是以食品着色为主要目的，使食品赋予色泽和改善食品色泽的物质', 
	json(['甜菜红', '姜黄', 'β-胡萝卜素', '叶绿素', '紫胶红', '胭脂虫红', '红曲红', '苋菜红', '胭脂红', '日落黄', '柠檬黄', '新红', '诱惑红', '酸性红', '赤藓红', '亮蓝', '靛蓝'])
);


select category.* from category, json_each(category.additives) where     
json_each.value = '阿斯巴甜'
