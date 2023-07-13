import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trinetraflutter/theme_provider.dart';
import 'package:trinetraflutter/widgets/heart_chart.dart';
import 'package:wakelock/wakelock.dart';

class HeartBeat extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HeartBeat({Key? key, required this.cameras}) : super(key: key);

  @override
  State<HeartBeat> createState() => _HeartBeatState();
}

class _HeartBeatState extends State<HeartBeat> {
  List<SensorValue> alldata = [];
  bool toggled = false;
  late CameraController _cameraController = CameraController(
    widget.cameras[0],
    ResolutionPreset.max,
  );
  bool _processing = false;
  String _start = 'Start';
  double bpm = 0;

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            TweenAnimationBuilder(
              builder: (BuildContext context, double value, Widget? child) {
                return Opacity(
                  opacity: value,
                  child: Padding(
                    padding: EdgeInsets.only(top: value * 20),
                    child: child,
                  ),
                );
              },
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0, end: 1),
              child: Consumer<ThemeProvider>(
                builder: (context, value, child) {
                  return Text(
                    "Calculate Heart Beat",
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
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: Text(
                'Ensure that place your finger on torch and camera before starting.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (toggled) {
                          _cameraController.dispose();
                          Wakelock.disable();
                          setState(() {
                            toggled = false;
                            _processing = false;
                            _start = 'Start Again';
                          });
                        } else {
                          _start = 'Stop';
                          _initController().then((onValue) {
                            Wakelock.enable();
                            setState(() {
                              toggled = true;
                              _processing = false;
                            });
                            _updateBPM();
                          });
                        }
                      },
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Text(
                            "${_start}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: value.themeMode == ThemeMode.light
                                  ? Colors.deepPurple
                                  : Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, value, child) {
                    return Icon(
                      Icons.favorite,
                      size: 100,
                      color: value.themeMode == ThemeMode.light
                          ? Colors.red.shade400
                          : Colors.grey.shade300,
                    );
                  },
                ),
                const SizedBox(width: 30),
                Text(
                  (bpm > 30 && bpm < 150 ? bpm.round().toString() : '0'),
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w500,
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
                const Text(
                  " bpm",
                  style: TextStyle(
                    textBaseline: TextBaseline.ideographic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<ThemeProvider>(
                builder: (context, value, child) {
                  return Container(
                    margin: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: value.themeMode == ThemeMode.light
                          ? const Color.fromRGBO(255, 0, 0, .2)
                          : Colors.grey.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ChartComp(allData: alldata),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _updateBPM() async {
    List<SensorValue> values;
    double avg;
    int n;
    double m;
    double threshold;
    double _bpm;
    int counter;
    int previous;
    while (toggled) {
      values = List.from(alldata);
      avg = 0;
      n = values.length;
      m = 0;

      for (var value in values) {
        avg += value.value / n;
        if (value.value > m) m = value.value;
      }

      threshold = (m + avg) / 2;
      _bpm = 0;
      counter = 0;
      previous = 0;
      
      for (int i = 1; i < n; i++) {
        if (values[i - 1].value < threshold &&
            values[i].value > threshold) {
          if (previous != 0) {
            counter++;
            _bpm +=
                60000 / (values[i].time.millisecondsSinceEpoch - previous);
          }
          previous = values[i].time.millisecondsSinceEpoch;
        }
      }
      if (counter > 0) {
        _bpm = _bpm / counter;
        setState(() {
          bpm = _bpm;
        });
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.max,
      );
      await _cameraController.initialize();
      Future.delayed(const Duration(milliseconds: 500)).then((onValue) {
        _cameraController.setFlashMode(FlashMode.torch);
      });
      _cameraController.startImageStream((CameraImage image) {
        if (!_processing) {
          setState(() {
            _processing = true;
          });
          double avg = image.planes.first.bytes
                  .reduce((value, element) => value + element) /
              image.planes.first.bytes.length;

          if (alldata.length >= 50) {
            alldata.removeAt(0);
          }
          setState(() {
            alldata.add(SensorValue(DateTime.now(), avg));
          });

          Future.delayed(const Duration(milliseconds: 1000 ~/ 30))
              .then((onValue) {
            setState(() {
              _processing = false;
            });
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
