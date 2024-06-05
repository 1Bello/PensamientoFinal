import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class VideoData {
  static final Map<String, String> videos = {
    "carton": "https://www.youtube.com/watch?v=pftqFMPui58",
    "plastico": "https://www.youtube.com/watch?v=4mIIgkPLD2I",
    "papel": "https://www.youtube.com/watch?v=VIDEO_ID3",
    "metal": "https://www.youtube.com/watch?v=75B8pGCk4Y4",
    // Añade más tipos de basura y sus URLs de YouTube aquí
  };

  static Widget getVideoWidget(String label) {
    if (videos.containsKey(label)) {
      return YoutubePlayerWidget(videoUrl: videos[label]!);
    } else {
      return Text('No video available for this type of waste.');
    }
  }
}

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerWidget({required this.videoUrl});

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    _controller.addListener(_onFullScreenChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onFullScreenChanged);
    _controller.dispose();
    super.dispose();
  }

  void _launchURL() async {
    final url = widget.videoUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onFullScreenChanged() {
    if (_controller.value.isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Container(
        width: double.infinity,
        color: Colors.green, // Fondo verde
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            _controller.addListener(() {});
          },
          onEnded: (YoutubeMetaData data) {
            _controller.reset();
          },
        ),
      ),
    );
  }
}
