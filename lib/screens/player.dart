import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:trinetraflutter/controllers/player_controller.dart';
import 'package:trinetraflutter/widgets/text_style.dart';

// ignore: must_be_immutable
class Player extends StatelessWidget {
  final List<SongModel> songModel;
  final int index;
  Player({super.key, required this.songModel, required this.index});

  var controller = Get.put(PlayerController());

  static const bgcolor = Color(0xff1F212C);
  static const whitecolor = Color(0xffFFFFFF);
  static const slidercolor = Color(0xff7E70FF);
  static const buttoncolor = Color(0xff60E950);
  static const bgDarkcolor = Color(0xff070B11);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Obx(() {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        QueryArtworkWidget(
                          id: songModel[controller.playindex.value].id,
                          type: ArtworkType.AUDIO,
                          artworkHeight: double.infinity,
                          artworkWidth: double.infinity,
                          nullArtworkWidget: const Icon(
                            Icons.music_note_rounded,
                            color: whitecolor,
                            size: 20,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            radius: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          songModel[controller.playindex.value]
                              .displayNameWOExt,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: ourTextStyle(
                            family: "font3",
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          songModel[controller.playindex.value]
                              .artist
                              .toString(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: ourTextStyle(
                            family: "one",
                            size: 15,
                            color: bgDarkcolor,
                            weight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          return Row(
                            children: [
                              Text(
                                controller.position.value,
                                style: ourTextStyle(
                                  color: bgDarkcolor,
                                  size: 14,
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  thumbColor: slidercolor,
                                  activeColor: slidercolor,
                                  inactiveColor: bgcolor,
                                  value: controller.value.value,
                                  max: controller.max.value,
                                  min: const Duration(seconds: 0)
                                      .inSeconds
                                      .toDouble(),
                                  onChanged: (newValue) {
                                    controller.changeDurationToSeconds(
                                        newValue.toInt());
                                  },
                                ),
                              ),
                              Text(
                                controller.duration.value,
                                style: ourTextStyle(
                                  color: bgDarkcolor,
                                  size: 14,
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.playsong(
                                  songModel[controller.playindex.value - 1]
                                      .uri
                                      .toString(),
                                  controller.playindex.value - 1,
                                );
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 40,
                                color: bgDarkcolor,
                              ),
                            ),
                            Obx(() {
                              return CircleAvatar(
                                radius: 35,
                                backgroundColor: bgDarkcolor,
                                child: Transform.scale(
                                  scale: 1.5,
                                  child: IconButton(
                                    onPressed: () {
                                      if (controller.isPlaying.value == true) {
                                        controller.audioPlayer.pause();
                                        controller.isPlaying(false);
                                      } else {
                                        controller.audioPlayer.play();
                                        controller.isPlaying(true);
                                        controller.playindex.value =
                                            controller.playindex.value;
                                        controller.updatePostiion();
                                      }
                                    },
                                    icon: !controller.isPlaying.value
                                        ? const Icon(
                                            Icons.play_arrow_rounded,
                                            size: 40,
                                            color: whitecolor,
                                          )
                                        : const Icon(
                                            Icons.pause_rounded,
                                            size: 40,
                                            color: whitecolor,
                                          ),
                                  ),
                                ),
                              );
                            }),
                            IconButton(
                              onPressed: () {
                                controller.playsong(
                                  songModel[controller.playindex.value + 1]
                                      .uri
                                      .toString(),
                                  controller.playindex.value + 1,
                                );
                              },
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 40,
                                color: bgDarkcolor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }
}
