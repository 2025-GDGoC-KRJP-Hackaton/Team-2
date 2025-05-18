import 'dart:async';
import 'dart:developer';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:remember_me/app/auth/auth_service.dart';
import 'package:remember_me/app/extension/build_context_x.dart';
import 'package:remember_me/app/provider/user/user_provider.dart';
import 'package:remember_me/app/route/router_service.dart';
import 'package:remember_me/app/screens/home/logic/home_provider.dart';
import 'package:remember_me/app/screens/home/logic/home_state.dart';
import 'package:remember_me/app/screens/home/widgets/home_answer_page.dart';
import 'package:remember_me/app/screens/home/widgets/home_bottom_bar.dart';
import 'package:remember_me/app/screens/home/widgets/home_bottom_sheet.dart';
import 'package:remember_me/constants.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? recordedFilePath;
  bool isRecording = false;
  Timer? timer;
  int recordedDuration = 0;
  stt.SpeechToText? speech;
  final TextEditingController _controller = TextEditingController();

  String get formattedDuration {
    final minutes = (recordedDuration / 60000).floor();
    final seconds = ((recordedDuration % 60000) / 1000).floor();
    final milliseconds = (recordedDuration % 1000) ~/ 100;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(1, '0')}';
  }

  @override
  void initState() {
    super.initState();
    ref.read(userProvider.notifier).getUser();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _stop(WidgetRef ref) async {
    setState(() {
      isRecording = false;
      recordedDuration = 0;
    });
    timer?.cancel();
    timer = null;

    log("Recorded file path: $recordedFilePath");
    if (recordedFilePath == null) {
      return;
    }
    speech?.stop();
  }

  void _record() async {
    setState(() {
      isRecording = true;
    });

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        recordedDuration += 100;
      });
    });
    speech = stt.SpeechToText();
    bool available = await speech!.initialize(
      onStatus: (s) {
        log(s);
      },
      onError: (e) {
        log(e.toString());
      },
    );
    if (available) {
      speech!.listen(
        onResult: (result) {
          _controller.text = result.recognizedWords;
        },
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  Widget _buildRecordingPage() {
    final userState = ref.watch(userProvider);
    final displayName = userState.display_name;
    return Column(
      key: const Key('recording_page'),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          child: Text(
            "Hello, $displayName!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child:
                      isRecording
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 10,
                                height: 10,
                              ),
                              SizedBox(width: 10),
                              Text(
                                formattedDuration,
                                style: TextStyle(fontSize: 50),
                              ),
                            ],
                          )
                          : Text(
                            "Record your memories",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                ),
              ),

              Expanded(
                child: Center(
                  child: SizedBox(
                    width: context.width * 0.8,
                    child:
                        isRecording
                            ? Text(_controller.text)
                            : Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    maxLines: 3,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text("Saving Memory"),
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 20.0,
                                                  ),
                                              child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel"),
                                              ),
                                            ],
                                          ),
                                    );
                                    final result = await ref
                                        .read(homeProvider.notifier)
                                        .saveRecording(_controller.text);

                                    Navigator.pop(context);
                                    if (result) {
                                      _controller.clear();

                                      ElegantNotification.success(
                                        title: Text("Saved Memory"),
                                        description: Text(
                                          "Memory saved successfully!",
                                        ),
                                      ).show(context);
                                    } else {
                                      ElegantNotification.error(
                                        title: Text("Error"),
                                        description: Text(
                                          "Failed to save memory.",
                                        ),
                                      ).show(context);
                                    }
                                  },
                                  icon: Icon(Icons.send),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Builder(
              builder: (context) {
                return IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: EdgeInsets.all(20),
                  ),
                  onPressed: () {
                    showBottomSheet(
                      context: context,
                      builder: (c) => HomeBottomSheet(),
                    );
                  },
                  icon: Icon(Icons.camera_alt),
                  iconSize: 30,
                );
              },
            ),
            Center(
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: EdgeInsets.all(20),
                ),
                onPressed: () async {
                  if (isRecording) {
                    _stop(ref);
                  } else {
                    _record();
                  }
                },
                icon: Icon(isRecording ? Icons.stop : Icons.mic),
                iconSize: 70,
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
                padding: EdgeInsets.all(20),
              ),
              onPressed: () {
                context.push(Routes.history);
              },
              icon: Icon(Icons.history),
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnsweringPage() {
    return HomeAnswerPage(key: const Key('answering_page'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 24),
              Text('Remember Me', style: TextStyle(fontSize: 16)),
              SizedBox(height: 17),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log out'),
                onTap: () {
                  AuthService.I.logout();
                },
              ),

              ListTile(
                leading: Icon(Icons.info),
                title: Text('License'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LicensePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.maxFinite),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  key: ValueKey<Key?>(child.key),
                  opacity: Tween<double>(
                    begin: 0.3,
                    end: 1.0,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-0.03, 0.0),
                      end: const Offset(0.0, 0.0),
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              layoutBuilder: (currentChild, child) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    ...child,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child:
                  ref.watch(homeProvider).selectedTab == HomeTabs.record
                      ? _buildRecordingPage()
                      : _buildAnsweringPage(),
            ),
          ),
          SizedBox(height: 30),
          HomeBottomBar(),
        ],
      ),
    );
  }
}
