import 'package:flutter/material.dart';
import './nursery_edit.dart';
import './nursery_list.dart';
import '../widgets/ui_elements/logout_list_tile.dart';
import '../scoped-models/main.dart';

class NurseriesAdminPage extends StatelessWidget {
  final MainModel model;

  NurseriesAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Nurseries'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Manage Nurseries'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Nursery',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Nurseries',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[NurseryEditPage(), NurseryListPage(model)],
        ),
      ),
    );
  }
}
