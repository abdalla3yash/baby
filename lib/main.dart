import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/nurseries_admin.dart';
import './pages/nurseries.dart';
import './pages/nursery.dart';
import './scoped-models/main.dart';
import './models/nursery.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building main page');
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            accentColor: Colors.redAccent,
            buttonColor: Colors.red),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : NurseriesPage(_model),
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : NurseriesAdminPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'nursery') {
            final String nurseryId = pathElements[2];
            final Nursery nursery =
                _model.allNurseries.firstWhere((Nursery nursery) {
              return nursery.id == nurseryId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : NurseryPage(nursery),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : NurseriesPage(_model));
        },
      ),
    );
  }
}
