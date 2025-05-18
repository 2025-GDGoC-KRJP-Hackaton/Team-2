import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:remember_me/app/provider/user/user_provider.dart';
import 'package:remember_me/app/screens/home/logic/home_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeAnswerPage extends ConsumerStatefulWidget {
  const HomeAnswerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAnswerPageState();
}

class _HomeAnswerPageState extends ConsumerState<HomeAnswerPage> {
  bool isRecording = false;
  bool isAnswering = false;
  String recording = "";
  stt.SpeechToText? speech;
  String answer = "";

  void _stop() async {
    setState(() {
      isRecording = false;
      isAnswering = true;
    });
    speech?.stop();
    final answer = await ref.read(homeProvider.notifier).getAnswer(recording);
    if (mounted) {
      setState(() {
        this.answer = answer;
      });
    }
  }

  void _record() async {
    setState(() {
      isRecording = true;
      recording = "";
      isAnswering = false;
      answer = "";
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
          if (mounted) {
            setState(() {
              recording = result.recognizedWords;
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (!isRecording && !isAnswering)
                    Text(
                      "Press button to start question.",
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          recording.isEmpty
                              ? Center(
                                child: SizedBox(
                                  width: 40,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.lineScale,
                                    colors: const [Colors.black],
                                    strokeWidth: 2,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ),
                              )
                              : Text(
                                recording,
                                style: const TextStyle(fontSize: 20),
                              ),
                    ),
                  SizedBox(height: 20),

                  if (isAnswering)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          answer.isEmpty
                              ? Center(
                                child: SizedBox(
                                  width: 40,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.lineScale,
                                    colors: const [Colors.black],
                                    strokeWidth: 2,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ),
                              )
                              : SizedBox(
                                width: double.infinity,
                                child: Text(
                                  answer,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                    ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
                padding: EdgeInsets.all(20),
              ),
              onPressed: () async {
                if (isRecording) {
                  _stop();
                } else {
                  _record();
                }
              },
              icon: Icon(isRecording ? Icons.stop : Icons.mic),
              iconSize: 70,
            ),
          ),
        ],
      ),
    );
  }
}
