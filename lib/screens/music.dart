import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:trinetraflutter/controllers/player_controller.dart';
import 'package:trinetraflutter/screens/player.dart';
import 'package:trinetraflutter/screens/profileScreen.dart';
import 'package:trinetraflutter/theme_provider.dart';
import 'package:trinetraflutter/widgets/text_style.dart';

// ignore: must_be_immutable
class Music extends StatelessWidget {
  Music({super.key});

  var controller = Get.put(PlayerController());
  List<SongModel> originalSnapshot = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: true,
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          ignoreCase: true,
          uriType: UriType.EXTERNAL,
          sortType: null,
        ),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No download songs found",
                style: ourTextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          } else {
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (snapshot.data![i].fileExtension == "mp3" &&
                  snapshot.data![i].artist != "<unknown>") {
                originalSnapshot.add(snapshot.data![i]);
              }
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                primary: true,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<ThemeProvider>(
                            builder: (context, value, child) {
                              return Text(
                                "Music Beats",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "font6",
                                  color: value.themeMode == ThemeMode.light
                                      ? Colors.deepPurple
                                      : Colors.white,
                                ),
                              );
                            },
                          ),
                          Container(
                            width: 40,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/images/male.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: originalSnapshot.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            tileColor: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.5),
                            title: Text(
                              originalSnapshot[index].displayNameWOExt,
                              style: ourTextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                family: "font3",
                                size: 15,
                                letterSpacing: 1,
                              ),
                            ),
                            subtitle: Text(
                              "${originalSnapshot[index].artist}",
                              style: ourTextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                family: "font2",
                                size: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                            leading: QueryArtworkWidget(
                              id: originalSnapshot[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Icon(
                                Icons.music_note_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 32,
                              ),
                            ),
                            trailing: Obx(() {
                              if (controller.playindex.value == index &&
                                  controller.isPlaying.value == true) {
                                return IconButton(
                                  onPressed: () {
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  },
                                  icon: Icon(
                                    Icons.pause_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 26,
                                  ),
                                );
                              } else {
                                return IconButton(
                                  onPressed: () {
                                    if (controller.playindex.value == index) {
                                      controller.audioPlayer.play();
                                      controller.isPlaying(true);
                                      controller.updatePostiion();
                                    } else {
                                      controller.playsong(
                                        originalSnapshot[index].uri.toString(),
                                        index,
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.play_arrow_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 26,
                                  ),
                                );
                              }
                            }),
                            onTap: () {
                              if (controller.playindex.value == index &&
                                  controller.isPlaying.value == true) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Player(
                                            songModel: originalSnapshot,
                                            index: index)));
                                // Get.to(
                                //   () => Player(
                                //     songModel: originalSnapshot,
                                //     index: index,
                                //   ),
                                //   transition: Transition.native,
                                //   duration: const Duration(milliseconds: 500),
                                // );
                              } else {
                                if (!controller.isPlaying.value) {
                                  if (controller.playindex.value == index) {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                    controller.updatePostiion();
                                  } else {
                                    controller.playsong(
                                      originalSnapshot[index].uri.toString(),
                                      index,
                                    );
                                  }
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Player(
                                            songModel: originalSnapshot,
                                            index: index)));
                                // Get.to(
                                //   () => Player(
                                //     songModel: originalSnapshot,
                                //     index: index,
                                //   ),
                                //   transition: Transition.native,
                                //   duration: const Duration(milliseconds: 500),
                                // );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
