import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './nursery_card.dart';
import '../../models/nursery.dart';
import '../../scoped-models/main.dart';

class Nurseries extends StatelessWidget {
  Widget _buildNurseryList(List<Nursery> nurseries) {
    Widget nurseryCards;
    if (nurseries.length > 0) {
      nurseryCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            NurseryCard(nurseries[index], index),
        itemCount: nurseries.length,
      );
    } else {
      nurseryCards = Container();
    }
    return nurseryCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[nursery Widget] build()');
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return  _buildNurseryList(model.displayedNurseries);
    },);
  }
}
