import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';

import 'screens/map_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit()..getLocation(),
        ),
        BlocProvider<BirdPostCubit>(create: (context) => BirdPostCubit()..loadPosts()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          //app bar
          primaryColor: Color(0xFF495371),
          colorScheme: ColorScheme.light().copyWith(
            //text Field color
            primary: Color(0xFF98B4AA),
            //floating action button
            secondary: Color(0xFF74959A),
          ),
        ),
        home: MapScreen(),
      ),
    );
  }
}
