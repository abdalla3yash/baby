import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './nursery_edit.dart';
import '../scoped-models/main.dart';

class NurseryListPage extends StatefulWidget {
  final MainModel model;

  NurseryListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _NurseryListPageState();
  }
}

class _NurseryListPageState extends State<NurseryListPage> {
  @override
  initState() {
    widget.model.fetchNurseries(onlyForUser: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectNursery(model.allNurseries[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return NurseryEditPage();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.displayedNurseries.length <= 0
            ? Center(child: Text('you don\'t add nurseries yet!'))
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(model.allNurseries[index].title),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('DELETING ITEM!'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'are you sure to delete this nursery?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('no'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                FlatButton(
                                    child: Text(
                                      'yes',
                                    ),
                                    onPressed: () {
                                      model.selectNursery(
                                          model.allNurseries[index].id);
                                      model.deleteNursery();
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            );
                          },
                        );
                      } else if (direction == DismissDirection.startToEnd) {
                        print('Swiped start to end');
                      } else {
                        print('Other swiping');
                      }
                    },
                    background: Container(
                        color: Colors.red, child: Icon(Icons.delete_forever)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/baby.jpg'),
                          ),
                          title: Text(model.allNurseries[index].title),
                          subtitle: Text(
                              '${model.allNurseries[index].age.toString()}' +
                                  'm'),
                          trailing: _buildEditButton(context, index, model),
                        ),
                        Divider()
                      ],
                    ),
                  );
                },
                itemCount: model.allNurseries.length,
              );
      },
    );
  }
}
