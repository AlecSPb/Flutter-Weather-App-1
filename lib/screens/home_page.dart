import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'package:weather/provider/hive_db_provider.dart';
import 'package:weather/provider/weather_provider.dart';
import 'package:weather/screens/main_page.dart';
import 'package:weather/screens/splash_screen.dart';
import 'package:weather/widgets/custom_search_delegate.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final wProvider = Provider.of<WeatherProvider>(context);
    final hProvider = Provider.of<HiveDbProvider>(context);
    final future = useMemoized(() => wProvider.checkFirstRun());

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (snapshot.hasError && hProvider.items.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => showSearch(
                      context: context, delegate: CustomSearchDelegate()),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  snapshot.error.toString().toUpperCase(),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: PageView.builder(
              itemCount: hProvider.items.length,
              itemBuilder: (context, index) {
                return MainPage(index: index);
              },
            ),
          ),
        );
      },
    );
  }
}
