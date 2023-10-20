import 'package:flutter/material.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import '../../model/model.dart';
import '../../util/db_helper.dart';
import '../../util/slide_menu.dart';
import 'additive_detail.dart';
import 'additive_filter.dart';
import 'search_filter.dart';

class AdditiveList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdditiveListState();
}

class AdditiveListState extends State {
  AdditiveListState();

  List<Additive>? additives;
  OrderBy orderRadioValue = OrderBy.None;
  String? orderBy;
  @override
  void initState() {
    SearchFilterAdditive.showIsDeleted = false;
    super.initState();
    return;
  }

  //int count = 0;
  @override
  Widget build(BuildContext context) {
    void getData() async {
      // Set category id parameter
      // final int? selectedCategoryId =
      //     SearchFilterAdditive.getValues.selectedCategoryId;

      /*

     final additivesData = await Additive()
                          .select(getIsDeleted: showIsDeleted)
                          .categoryId.equals(selectedCategoryId)
                          .and
                          .startBlock
                            .name.startsWith(SearchFilterAdditive.getValues.nameStartsWith)
                            .or.name.contains(SearchFilterAdditive.getValues.nameContains)
                            .or.name.endsWith(SearchFilterAdditive.getValues.nameEndsWith)
                          .endBlock
                          .and.description.contains(SearchFilterAdditive.getValues.descriptionContains)
                          .and.price.between(SearchFilterAdditive.getValues.minPrice, SearchFilterAdditive.getValues.maxPrice)
                          .and.isActive.equals(SearchFilterAdditive.getValues.isActive)
                          .orderBy(orderBy)
                          .toList();


     */
      final additivesData = await Additive()
          .select(getIsDeleted: SearchFilterAdditive.showIsDeleted)
          // .categoryId
          // .equals(selectedCategoryId)
          // .and
          .startBlock
          .name
          .startsWith(SearchFilterAdditive.getValues.nameStartsWith)
          .or
          .name
          .contains(SearchFilterAdditive.getValues.nameContains)
          .or
          .name
          .endsWith(SearchFilterAdditive.getValues.nameEndsWith)
          .endBlock
          .and
          .note
          .contains(SearchFilterAdditive.getValues.noteContains)
          .and
          // .price
          // .between(SearchFilterAdditive.getValues.minPrice,
          //     SearchFilterAdditive.getValues.maxPrice)
          // .and
          // .isActive
          // .equals(SearchFilterAdditive.getValues.isActive)
          .orderBy(orderBy)
          .toList();
      setState(() {
        additives = additivesData;
        //   count = additivesData.length;
      });
    }

    if (additives == null) {
      additives = <Additive>[];
      getData();
    }
    void goToDetail(Additive additive) async {
      final bool? result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => AdditiveDetail(additive)));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    void goToAdditiveAdd(Additive additive) async {
      final bool? result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => AdditiveAdd(additive)));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    void select(Choice choice, Additive additive) async {
      BoolResult result;
      switch (choice) {
        case Choice.Delete:
          final confirm = await UITools(context).confirmDialog(
              'Delete \'${additive.name}\'?',
              '${(additive.isDeleted! ? 'Hard ' : '')}Delete Additive');
          if (confirm!) {
            result = await additive.delete();
            if (result.success) {
              UITools(context).alertDialog('${additive.name} deleted',
                  title:
                      '${(additive.isDeleted! ? 'Hard ' : '')}Delete Additive',
                  callBack: () {
                //Navigator.pop(context, true);
                getData();
              });
            }
          }
          break;
        case Choice.Recover:
          final confirm = await UITools(context).confirmDialog(
              'Recover \'${additive.name}\'?', 'Recover Additive');
          if (confirm!) {
            result = await additive.recover();
            if (result.success) {
              UITools(context).alertDialog('${additive.name} recovered',
                  title: 'Recover Additive', callBack: () {
                //  Navigator.pop(context, true);
                getData();
              });
            }
          }
          break;
        case Choice.Update:
          goToAdditiveAdd(additive);
          break;
        default:
      }
    }

    void selectOrderBy(OrderBy value) {
      String? _orderBy;
      switch (value) {
        case OrderBy.NameAsc:
          _orderBy = 'name';
          break;
        case OrderBy.NameDesc:
          _orderBy = 'name desc';
          break;
        case OrderBy.PriceAsc:
          _orderBy = 'price';
          break;
        case OrderBy.PriceDesc:
          _orderBy = 'price desc';
          break;
        case OrderBy.None:
          _orderBy = null;
          break;
        default:
      }
      setState(() {
        orderBy = _orderBy;
        orderRadioValue = value;
        getData();
      });
    }

    ListTile makeAdditiveListTile(Additive additive) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          // leading: Container(
          //   padding: EdgeInsets.only(right: 12.0),
          //   decoration: BoxDecoration(
          //       border: Border(
          //           right: BorderSide(width: 1.0, color: Colors.white24))),
          //   child: SizedBox(
          //     width: UITools(context).scaleWidth(60),
          //     height: UITools(context).scaleHeight(50),
          //     child: UITools.imageFromNetwork(additive.imageUrl!),
          //   ),
          // ),
          title: Text(
            additive.name!,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration:
                    additive.isDeleted! ? TextDecoration.lineThrough : null,
                fontSize: UITools(context).scaleWidth(24)),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(additive.note ?? '',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, .5),
                            decoration: additive.isDeleted!
                                ? TextDecoration.lineThrough
                                : null,
                            fontSize: UITools(context).scaleWidth(18))),
                  )
                ],
              ),
              // Row(
              //   children: <Widget>[
              //     Text(
              //         '\$ ${additive.price != null ? priceFormat.format(additive.price) : '-'}',
              //         style: TextStyle(
              //             color: Color.fromRGBO(195, 255, 155, .8),
              //             fontSize: UITools(context).scaleWidth(14)))
              //   ],
              // )
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right,
              color: Colors.white, size: UITools(context).scaleHeight(30.0)),
          onTap: () {
            goToDetail(additive);
          },
        );

    void goToAdditiveFilter() async {
      final bool? result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => AdditiveFilterWindow()));
      if (result != null) {
        if (result) {
          getData();
        }
      }
    }

    Card makeAdditiveCart(Additive additive) => Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: additive.isDeleted!
                ? BoxDecoration(color: Color.fromRGBO(111, 14, 33, .9))
                : additive.isActive!
                    ? BoxDecoration(color: Color.fromRGBO(111, 84, 133, .9))
                    : BoxDecoration(color: Color.fromRGBO(111, 84, 113, .5)),
            child: makeAdditiveListTile(additive),
          ),
        );

    final makeAdditiveList = ListView(
      children: ListTile.divideTiles(
        context: this.context,
        tiles: List.generate(additives!.length, (index) {
          if (additives![index].id == 0) {
            return makeAdditiveCart(additives![
                index]); // 'List All' item has no delete/info actions
          } else {
            return SlideMenu(
              child: makeAdditiveCart(additives![index]),
              menuItems: <Widget>[
                Container(
                  //decoration:  BoxDecoration(color: Color.fromRGBO(111, 84, 133, .9)),
                  child: IconButton(
                      icon: Icon(
                        additives![index].isDeleted!
                            ? Icons.delete_forever
                            : Icons.delete_outline,
                        color: Colors.pinkAccent,
                      ),
                      onPressed: () {
                        select(Choice.Delete, additives![index]);
                      }),
                ),
                Container(
                  child: IconButton(
                      icon: Icon(
                        additives![index].isDeleted!
                            ? Icons.restore_from_trash
                            : Icons.edit,
                        color: Colors.tealAccent,
                      ),
                      onPressed: () {
                        select(
                            additives![index].isDeleted!
                                ? Choice.Recover
                                : Choice.Update,
                            additives![index]);
                      }),
                ),
              ],
            );
          } // end if
        }),
      ).toList(),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(95, 66, 119, 1.0),
      body: makeAdditiveList,
      bottomNavigationBar: UITools(context).makeBottomAlert(
          'on Tap -> Go to detail\nSwap Left -> Delete/Edit additive)'),
      //body: additiveListItems(),

      appBar: AppBar(
        elevation: 1,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {
            goToAdditiveFilter();
          },
        ),
        title: Text(
          '(${additives!.length} items)',
          textAlign: TextAlign.left,
        ),
        actions: <Widget>[
          //actionBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Checkbox(
                  activeColor: Color.fromRGBO(52, 20, 86, 1),
                  value: SearchFilterAdditive.showIsDeleted,
                  onChanged: (value) {
                    setState(() {
                      SearchFilterAdditive.showIsDeleted = value!;
                      getData();
                    });
                  },
                ),
                Text(
                  'Show\ndeleted',
                  style: TextStyle(
                      fontSize: UITools(context).scaleWidth(14),
                      color: Color.fromRGBO(192, 160, 226, 1)),
                ),
                PopupMenuButton<OrderBy>(
                  tooltip: 'order by',
                  elevation: 8,
                  icon: Icon(
                    Icons.text_rotate_vertical,
                    size: 30,
                  ),
                  onSelected: selectOrderBy,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<OrderBy>>[
                    PopupMenuItem<OrderBy>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.NameAsc,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('name Ascending'),
                        ],
                      ),
                      value: OrderBy.NameAsc,
                    ),
                    PopupMenuItem<OrderBy>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.NameDesc,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('name Descending'),
                        ],
                      ),
                      value: OrderBy.NameDesc,
                    ),
                    PopupMenuItem<OrderBy>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.PriceAsc,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('price Ascending'),
                        ],
                      ),
                      value: OrderBy.PriceAsc,
                    ),
                    PopupMenuItem<OrderBy>(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.PriceDesc,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('price Descending'),
                        ],
                      ),
                      value: OrderBy.PriceDesc,
                    ),
                    PopupMenuItem<OrderBy>(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: OrderBy.None,
                            activeColor: Color.fromRGBO(52, 20, 86, 1),
                            groupValue: orderRadioValue,
                            onChanged: (value) => {},
                          ),
                          Text('none'),
                        ],
                      ),
                      value: OrderBy.None,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(52, 20, 86, 1),
        onPressed: () {
          goToAdditiveAdd(Additive());
        },
        tooltip: 'add new additive',
        child: Icon(Icons.add),
      ),
    );
  }
}
