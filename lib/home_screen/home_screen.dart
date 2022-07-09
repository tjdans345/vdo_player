import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vdo_player/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(video: video!,), // video 가 null 이 아닐때만 renderVideo 가 호출되기 때문에 !를 붙여준다.
    );
  }

  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
              onTap: onLogoTap,
          ),
          SizedBox(
            height: 30.0,
          ), // 간단하게 간격을 줄 때 사이즈드 박스 사용 !!! 패딩은 한번 감싸야한다는 특징이 있다.
          _AppName()
        ],
      ),
    );
  }

  void onLogoTap() async {
    final video = await ImagePicker().pickVideo(
        source: ImageSource.gallery
    );

    if(video != null) {
      setState( ()  {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration() {
    return const BoxDecoration(
        color: Colors.black,
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A3A7C), Color(0xFF000118)]));
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset("asset/image/logo.png"),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w300);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "VIDEO",
          style: textStyle,
        ),
        Text("PLAYER", style: textStyle.copyWith(fontWeight: FontWeight.w700)) // 다른 스타일은 유지하고 한가지 특성만 변경하려고 할 때 copyWith 를 사용한다.
      ],
    );
  }
}
