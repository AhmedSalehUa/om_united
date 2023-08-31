import 'package:flutter/cupertino.dart';

class LoginWeb extends StatefulWidget {
  const LoginWeb({Key? key}) : super(key: key);

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(11, 78, 142, 1),
            Color.fromRGBO(3, 158, 218, 1)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Stack(
            children: [
              Image(
                fit: BoxFit.fill,
                image: const AssetImage("assets/images/FrameBackground.png"),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Image.asset("assets/images/Vector.png"),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Image.asset("assets/images/Group.png"),
              ),
            ],
          )),
    );
  }
}
