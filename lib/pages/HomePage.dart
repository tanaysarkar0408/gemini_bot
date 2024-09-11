import 'dart:ui';
import 'package:gemini_bot/Bloc/chat_bloc.dart';
import 'package:gemini_bot/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_bot/pages/camera_page.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // speech to text
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _speechText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          _speechText = val.recognizedWords;
          textEditingController.text = _speechText;

          // Check if the speech recognition result is final
          if (val.finalResult) {
            // Wait for a few seconds and then send the message
            Future.delayed(const Duration(seconds: 2), () {
              if (_speechText.isNotEmpty) {
                _sendMessage();
              }
            });
          }
        });
      });
    }
  }

  void _sendMessage() {
    if (textEditingController.text.isNotEmpty) {
      String text = textEditingController.text;
      textEditingController.clear();
      chatBloc.add(ChatGenerateNewTextMessageEvent(inputMessage: text));
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }
  @override
  void dispose() {
    _flutterTts.stop();
    _speech.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {
          if (state is ChatSuccessState) {
            if (state.messages.isNotEmpty) {
              ChatMessageModel lastMessage = state.messages.last;
              if (lastMessage.role == 'model') {
                _speak(lastMessage.parts.first.text); // Speak bot response
              }
            }
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Container(
                  height: double.maxFinite,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/robot.jpg'),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GradientText(
                                  'ASK TINA',
                                  style: const TextStyle(
                                      fontFamily: 'Sixtyfour',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                  colors: const [
                                    Colors.white,
                                    Colors.pink,
                                    Colors.purpleAccent,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration:  BoxDecoration(
                                  color: Colors.grey.shade500.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(25)
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 25, sigmaY: 25),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            messages[index].role == "user"
                                                ? 'USER:-'
                                                : 'TINA:-',
                                            style: TextStyle(
                                              fontFamily: 'Sixtyfour',
                                              fontSize: 12,
                                              color: messages[index].role ==
                                                      "user"
                                                  ? Colors.greenAccent
                                                  : Colors.purpleAccent,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            messages[index].parts.first.text,
                                            style: const TextStyle(
                                                fontSize: 20, height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                                                      ),
                        ),
                        if (chatBloc.generating)
                          SizedBox(
                              height: 100,
                              width: 100,
                              child: Lottie.asset('assets/Animation.json')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          // height: 70,
                          child: Row(
                            children: [
                              //Camera Button
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 26,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.purple[900],
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraPage()));
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            size: 25,
                                          )),
                                    ),
                                  ),
                                ),
                              ),

                              //Mic
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 26,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.purple[900],
                                      child: IconButton(
                                          onPressed: () {
                                           if (! _isListening) {
                                             _startListening();
                                           } else {
                                             _stopListening();
                                           }
                                          },
                                          icon: Icon(
                                            size: 25,
                                            _isListening ?  Icons.mic : Icons.mic_none
                                          )),
                                    ),
                                  ),
                                ),
                              ),

                              //TextField
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: textEditingController,
                                    textAlign: TextAlign.justify,
                                    decoration: InputDecoration(
                                        hintText: 'TYPE SOMETHING...',
                                        fillColor: const Color(0x5fB47AC0),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50))),
                                  ),
                                ),
                              ),

                              // Send Button
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 26,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.purple[900],
                                      child: IconButton(
                                          onPressed: () {
                                            if (textEditingController
                                                .text.isNotEmpty) {
                                              String text =
                                                  textEditingController.text;
                                              textEditingController.clear();
                                              chatBloc.add(
                                                  ChatGenerateNewTextMessageEvent(
                                                      inputMessage: text));
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 15,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
