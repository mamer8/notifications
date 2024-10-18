import 'package:flutter/material.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen
({super.key, required this.id});
 final String id;
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details screen'),
      ),
      body: Center(
        child: Text(
          'the trip id is $id',
        ),
      ),
    );
  }
}