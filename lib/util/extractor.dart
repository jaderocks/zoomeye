// use dart to extract chinese from text
import 'package:zoomeye/model/model.dart';
import 'package:zoomeye/util/db_helper.dart';

Future<String> extractChinese(String? text) async{
  if (text == null) return '';

  RegExp pattern = RegExp(r'[\u4e00-\u9fa5]+');
  Iterable<RegExpMatch> matches = pattern.allMatches(text);

  List<String> results = [];

  for(final match in matches) {
    if(match[0] == null) continue;
    print("Found: "+ match[0]!);

    Additive? addi = await findAdditive(match[0]!);

    if(addi != null) {
      results.add(match[0]! + ' - '+ addi.name!);
    } 
  }

  return results.join(',');
}

Future<Additive?> findAdditive(String? text) async {
   final additivesData = await Additive()
          .select(getIsDeleted: false)
          .startBlock
          .name
          .startsWith(text)
          .endBlock
          // .price
          // .between(SearchFilterAdditive.getValues.minPrice,
          //     SearchFilterAdditive.getValues.maxPrice)
          // .and
          // .isActive
          // .equals(SearchFilterAdditive.getValues.isActive)
          .top(1)
          .orderBy('name asc')
          .toList();

    return additivesData.firstOrNull;
}