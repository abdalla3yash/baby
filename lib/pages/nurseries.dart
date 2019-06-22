import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/nurseries/nurseries.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../scoped-models/main.dart';

class NurseriesPage extends StatefulWidget {
  final MainModel model;

  NurseriesPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _NurseriesPageState();
  }
}

class _NurseriesPageState extends State<NurseriesPage> {
  @override
  initState() {
    widget.model.fetchNurseries();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String doctorCode = '0000';
  String enterCode;

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Nurseries'),
            onTap: () => _asyncInputDialog(context),
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }

  Widget _buildNurseriesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Nursery Found!'));
        if (model.displayedNurseries.length > 0 && !model.isLoading) {
          content = Nurseries();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: model.fetchNurseries,
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('health care'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.add_circle
                    : Icons.control_point),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: _buildNurseriesList(),
    );
  }

  _changeCode() {
    _formKey.currentState.save();
    _formKey.currentState.validate();
    setState(() async {
      if (doctorCode != enterCode) {
        return 'ID must be 4 character';
      } else {
        Navigator.pushReplacementNamed(context, '/admin');
      }
    });
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        // dialog is dismissible with a tap on the barrier
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text('welcome Doctor'),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'enter your code', hintText: 'X-X-X-X'),
                    onChanged: (value) {
                      enterCode = value;
                    },
                  ))
                ],
              ),
              actions: <Widget>[
                ScopedModelDescendant<MainModel>(builder:
                    (BuildContext context, Widget child, MainModel model) {
                  return model.isLoading
                      ? CircularProgressIndicator()
                      : FlatButton(
                          child: Text('Ok'),
                          onPressed: _changeCode,
                        );
                }),
              ],
            ),
          );
        });
  }
}
