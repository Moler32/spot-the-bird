import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

import '../bloc/bird_post_cubit.dart';
import '../models/bird_post_model.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;
  final File image;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  final _formKey = GlobalKey<FormState>();
  late final FocusNode _descriptionFocusNode;
  String? name;
  String? description;

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final BirdModel birdModel = BirdModel(
        birdName: name,
        birdDescription: description,
        latitude: widget.latLng.latitude,
        longitude: widget.latLng.longitude,
        image: widget.image);

    context.read<BirdPostCubit>().addBirdPost(birdModel);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bird'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: FileImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter a bird name'),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    name = value!.trim();
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Pleas enter a name...';
                    }
                    if (value.length < 2) {
                      return 'Please enter a longer name...';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  decoration:
                      InputDecoration(hintText: 'Enter a bird description'),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    _submit(context);
                  },
                  onSaved: (value) {
                    description = value!.trim();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Pleas enter a description...';
                    }
                    if (value.length < 2) {
                      return 'Please enter a longer description...';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _submit(context);
        },
        child: Icon(
          Icons.check,
          size: 30,
        ),
      ),
    );
  }
}
