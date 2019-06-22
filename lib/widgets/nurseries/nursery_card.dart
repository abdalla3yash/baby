import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './age_tag.dart';
import './address_tag.dart';
import '../../models/nursery.dart';
import '../../scoped-models/main.dart';

class NurseryCard extends StatelessWidget {
  final Nursery nursery;
  final int nurseryIndex;

  NurseryCard(this.nursery, this.nurseryIndex);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            nursery.title,
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            width: 8.0,
          ),
          AgeTag(nursery.age.toString())
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/nursery/' + model.allNurseries[nurseryIndex].id),
              ),
              IconButton(
                icon: Icon(model.allNurseries[nurseryIndex].isFavorite
                    ? Icons.add_circle
                    : Icons.add_circle_outline),
                color: Colors.red,
                onPressed: () {
                  model.selectNursery(model.allNurseries[nurseryIndex].id);
                  model.toggleNurseryFavoriteStatus();
                },
              ),
            ]);
      },
    );
  }

  Widget image_carousel = new Container(
    height: 200.0,
    child: new Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('assets/nursery3.jpg'),
        AssetImage('assets/nursery2.jpg'),
        AssetImage('assets/nursery1.jpg'),
        AssetImage('assets/nursery4.jpg'),
        AssetImage('assets/nursery5.jpg'),
      ],
      autoplay: true,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 4.0,
      indicatorBgPadding: 5.0,
      dotBgColor: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          image_carousel,
          _buildTitlePriceRow(),
          AddressTag('your child in our eyes'),
          Text(nursery.userEmail),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
