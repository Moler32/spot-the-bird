import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import '../models/bird_post_model.dart';
import 'add_bird_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'bird_info_screen.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  final MapController _mapController = MapController();

  Future<void> _pickImageAndCreatePost(
      {required LatLng latLng, required BuildContext context}) async {
    File? image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddBirdScreen(latLng: latLng, image: image!)));
    } else {
      print('Выберите изображение');
    }
  }

  List<Marker> _buildMarkers(BuildContext context, List<BirdModel> birdPosts) {
    List<Marker> markers = [];
    birdPosts.forEach((post) {
      markers.add(Marker(
          width: 55,
          height: 55,
          point: LatLng(post.latitude, post.longitude),
          builder: (ctx) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BirdPostInfoScreen(
                        birdModel: post,
                      ),
                    ),
                  );
                },
                child: Container(
                  child: Image.asset('assets/bird_icon.png'),
                ),
              )));
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (previousState, currentState) {
          if (currentState is LocationLoaded) {
            _mapController.onReady.then((_) => _mapController.move(
                LatLng(currentState.latitude, currentState.longitude), 14));
          }

          if (currentState is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red.withOpacity(0.6),
            ));
          }
        },
        child: BlocBuilder<BirdPostCubit, BirdPostState>(
            buildWhen: (prevState, currentState) =>
                (prevState.status != currentState.status),
            builder: (context, birdPostState) {
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  onLongPress: (tapPos, latLng) {
                    _pickImageAndCreatePost(latLng: latLng, context: context);
                  },
                  center: LatLng(0, 0),
                  zoom: 15.3,
                  maxZoom: 17,
                  minZoom: 3.5,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    retinaMode: true,
                  ),
                  MarkerLayerOptions(
                    markers: _buildMarkers(context, birdPostState.birdPosts),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
