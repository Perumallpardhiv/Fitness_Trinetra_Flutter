import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  var playindex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  updatePostiion() {
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });

    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playsong(String uri, int index) {
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri)),
      );
      playindex.value = index;
      isPlaying(true);
      audioPlayer.play();
      updatePostiion();
    } catch (e) {
      print(e);
    }
  }

  pauseSong() {
    try {
      isPlaying(false);
      audioPlayer.pause();
    } catch (e) {
      print(e);
    }
  }

  checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isDenied) {
      checkPermission();
    } else if (perm.isGranted) {}
  }
}
