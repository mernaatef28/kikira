import 'package:flutter/material.dart';
import 'package:kikira/kiki_app.dart';
import 'routes.dart';


class AppRouter {
   Route generateRoute (RouteSettings settings ){
    switch(settings.name ){
      case Routes.onBordingScreen:
        return MaterialPageRoute(builder: (_)=>  const kiki_Ra_app());
      default :
        return MaterialPageRoute(builder: (_)=> Scaffold(
          body: Center(
            child: Text(" no route defined for this ${settings.name}"),
          ),
        ));
    }

  }
}