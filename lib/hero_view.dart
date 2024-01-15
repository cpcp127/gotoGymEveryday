

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeroView extends StatefulWidget {
  final String? photoUrl;
  const HeroView({super.key,this.photoUrl});

  @override
  State<HeroView> createState() => _HeroViewState();
}

class _HeroViewState extends State<HeroView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              context.pop();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Center(
          child: Hero(
            tag: widget.photoUrl!,
            child: Image(
              image: CachedNetworkImageProvider(widget.photoUrl!),
            ),
          ),
        ),
      ),
    );
  }
}
