import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import '../../model/model.dart';

import '../../util/db_helper.dart';

class AdditiveDetail extends StatefulWidget {
  AdditiveDetail(this.additive);
  final Additive additive;
  @override
  State<StatefulWidget> createState() => AdditiveDetailState(additive);
}

class AdditiveDetailState extends State {
  AdditiveDetailState(this.additive);
  Additive additive;
  @override
  Widget build(BuildContext context) {
    final additiveName = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(195, 166, 219, .9)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        additive.name ?? "No Name",
        style: TextStyle(
            fontSize: UITools(context).scaleWidth(20.0), color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: UITools(context).scaleHeight(10.0)),
        Text(
          additive.name!,
          style: TextStyle(
              color: Colors.white, fontSize: UITools(context).scaleWidth(24.0)),
        ),
        Container(
          width: UITools(context).scaleWidth(180.0),
          child: Divider(color: Colors.white30),
        ),
        Text(
          additive.note!,
          style: TextStyle(
              color: Color.fromRGBO(195, 166, 219, 1),
              fontSize: UITools(context).scaleHeight(20.0)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: UITools(context).scaleHeight(90),
            ),
            additiveName
          ],
          textDirection: prefix0.TextDirection.rtl,
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/no-picture.png'),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(95, 66, 119, .9)),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    width: UITools(context).scaleWidth(200),
                    child: UITools.imageFromNetwork(
                        'https://source.unsplash.com/random/200x200'),
                  )),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[topContentText],
                ),
              )
            ],
          ),
        ),
      ],
    );

    final bottomContentText = Column(
      children: <Widget>[
        Text(
          '14" Full HD multitouch screen',
          style: TextStyle(fontSize: UITools(context).scaleHeight(20.0)),
        ),
        SizedBox(height: 10.0),
        Text(
          'The 1920 x 1080 resolution boasts impressive color and clarity. IPS technology for wide viewing angles. Energy-efficient WLED backlight.',
          style: TextStyle(fontSize: UITools(context).scaleHeight(16.0)),
        )
      ],
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[bottomContentText],
      ),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(95, 66, 119, 1.0),
      title: Text('Back to List'),
      actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: select,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
            additive.isDeleted!
                ? PopupMenuItem<Choice>(
                    child: Text('Recover additive'),
                    value: Choice.Recover,
                  )
                : PopupMenuItem<Choice>(
                    child: Text('Edit additive'),
                    value: Choice.Update,
                  ),
            PopupMenuItem<Choice>(
              child: additive.isDeleted!
                  ? Text('Hard delete additive')
                  : Text('Delete additive'),
              value: Choice.Delete,
            ),
          ],
        )
      ],
    );
    return Scaffold(
      appBar: topAppBar,
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }

  void select(Choice choice) async {
    BoolResult result;
    switch (choice) {
      case Choice.Delete:
        final confirm = await UITools(context).confirmDialog(
            'Delete \'${additive.name}\'?',
            '${(additive.isInsert! ? 'Hard ' : '')}Delete Additive');
        if (confirm!) {
          result = await additive.delete();
          if (result.success) {
            UITools(context).alertDialog('${additive.name} deleted',
                title: '${(additive.isDeleted! ? 'Hard ' : '')}Delete Additive',
                callBack: () {
              Navigator.pop(context, true);
            });
          }
        }
        break;
      case Choice.Recover:
        final confirm = await UITools(context)
            .confirmDialog('Recover \'${additive.name}\'?', 'Recover Additive');
        if (confirm!) {
          result = await additive.recover();
          if (result.success) {
            UITools(context).alertDialog('${additive.name} recovered',
                title: 'Recover Additive', callBack: () {
              Navigator.pop(context, true);
            });
          }
        }
        break;
      case Choice.Update:
        gotoDetail(additive);
        break;
      default:
    }
  }

  void gotoDetail(Additive additive) async {
    final bool? result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AdditiveAdd(additive)));
    if (result != null) {
      Navigator.pop(context, true);
    }
  }
}
