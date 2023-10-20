// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SqfEntityFormGenerator
// **************************************************************************

part of 'model.dart';

class AdditiveAdd extends StatefulWidget {
  AdditiveAdd(this._additive);
  final dynamic _additive;
  @override
  State<StatefulWidget> createState() =>
      AdditiveAddState(_additive as Additive);
}

class AdditiveAddState extends State {
  AdditiveAddState(this.additive);
  Additive additive;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtSerial_no = TextEditingController();
  final TextEditingController txtCategory = TextEditingController();
  final TextEditingController txtMax = TextEditingController();
  final TextEditingController txtNote = TextEditingController();

  final TextEditingController txtDateCreated = TextEditingController();
  final TextEditingController txtTimeForDateCreated = TextEditingController();

  @override
  void initState() {
    txtName.text = additive.name == null ? '' : additive.name.toString();
    txtSerial_no.text =
        additive.serial_no == null ? '' : additive.serial_no.toString();
    txtCategory.text =
        additive.category == null ? '' : additive.category.toString();
    txtMax.text = additive.max == null ? '' : additive.max.toString();
    txtNote.text = additive.note == null ? '' : additive.note.toString();

    txtDateCreated.text = additive.dateCreated == null
        ? ''
        : UITools.convertDate(additive.dateCreated!);
    txtTimeForDateCreated.text = additive.dateCreated == null
        ? ''
        : UITools.convertTime(additive.dateCreated!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (additive.id == null)
            ? Text('Add a new additive')
            : Text('Edit additive'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    buildRowName(),
                    buildRowSerial_no(),
                    buildRowCategory(),
                    buildRowMax(),
                    buildRowNote(),
                    buildRowIsActive(),
                    buildRowDateCreated(),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
                        }
                      },
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowName() {
    return TextFormField(
      controller: txtName,
      decoration: InputDecoration(labelText: 'Name'),
    );
  }

  Widget buildRowSerial_no() {
    return TextFormField(
      controller: txtSerial_no,
      decoration: InputDecoration(labelText: 'Serial_no'),
    );
  }

  Widget buildRowCategory() {
    return TextFormField(
      controller: txtCategory,
      decoration: InputDecoration(labelText: 'Category'),
    );
  }

  Widget buildRowMax() {
    return TextFormField(
      controller: txtMax,
      decoration: InputDecoration(labelText: 'Max'),
    );
  }

  Widget buildRowNote() {
    return TextFormField(
      controller: txtNote,
      decoration: InputDecoration(labelText: 'Note'),
    );
  }

  Widget buildRowIsActive() {
    return Row(
      children: <Widget>[
        Text('IsActive?'),
        Checkbox(
          value: additive.isActive ?? false,
          onChanged: (bool? value) {
            setState(() {
              additive.isActive = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildRowDateCreated() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => UITools.showDateTimePicker(context,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtDateCreated.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtDateCreated.text) ??
                  additive.dateCreated ??
                  DateTime.now();
              additive.dateCreated = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtDateCreated.text) ??
                  additive.dateCreated ??
                  DateTime.now()),
          controller: txtDateCreated,
          decoration: InputDecoration(labelText: 'DateCreated'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => UITools.showDateTimePicker(context,
                onConfirm: (sqfSelectedDate) {
              txtTimeForDateCreated.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtDateCreated.text) ??
                    additive.dateCreated ??
                    DateTime.now();
                additive.dateCreated = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtDateCreated.text =
                    UITools.convertDate(additive.dateCreated!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForDateCreated.text}') ??
                    additive.dateCreated ??
                    DateTime.now()),
            controller: txtTimeForDateCreated,
            decoration: InputDecoration(labelText: 'time'),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _dateCreated = DateTime.tryParse(txtDateCreated.text);
    final _dateCreatedTime = DateTime.tryParse(txtTimeForDateCreated.text);
    if (_dateCreated != null && _dateCreatedTime != null) {
      _dateCreated = _dateCreated.add(Duration(
          hours: _dateCreatedTime.hour,
          minutes: _dateCreatedTime.minute,
          seconds: _dateCreatedTime.second));
    }

    additive
      ..name = txtName.text
      ..serial_no = txtSerial_no.text
      ..category = txtCategory.text
      ..max = txtMax.text
      ..note = txtNote.text
      ..dateCreated = _dateCreated;
    await additive.save();
    if (additive.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(additive.saveResult.toString(),
          title: 'save Additive Failed!', callBack: () {});
    }
  }
}
