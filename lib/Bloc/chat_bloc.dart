import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gemini_bot/models/chat_message_model.dart';
import 'package:gemini_bot/repos/chat_repo.dart';
import "package:meta/meta.dart";

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: const [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }

  List<ChatMessageModel> messages = [];
  bool generating = false;

  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async{
    messages.add(
      ChatMessageModel(
        role: "user",
        parts: [
          ChatPartModel(text: event.inputMessage),
        ],
      ),
    );
    emit(ChatSuccessState(messages: messages));
    generating = true;
    String? generatedText =  await ChatRepo.chatTextGenerationRepo(messages);
    if(generatedText!.isNotEmpty){
      messages.add(ChatMessageModel(role: 'model', parts: [ChatPartModel(text: generatedText)]));
      emit(ChatSuccessState(messages: messages));
    }
    generating = false;
  }
}
