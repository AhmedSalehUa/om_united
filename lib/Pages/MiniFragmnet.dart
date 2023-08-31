 import 'package:flutter/material.dart';

class MiniFragmnet extends StatefulWidget {

  final Widget content;

  const MiniFragmnet({Key? key,  required this.content })
      : super(key: key);

  @override
  State<MiniFragmnet> createState() => _MiniFragmnet();
}

class _MiniFragmnet extends State<MiniFragmnet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(26, 26, 36, 1),
            image: DecorationImage(
              image: AssetImage("assets/images/ContainerBackground.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: widget.content
      ),
    );
  }
}
