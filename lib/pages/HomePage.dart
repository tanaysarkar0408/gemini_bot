import 'dart:ui';
import 'package:gemini_bot/Bloc/chat_bloc.dart';
import 'package:gemini_bot/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_bot/pages/camera_page.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {
          // TODO: implement listener
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
                                  'CHAT BOT',
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
                                                : 'CHAT BOT:-',
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
