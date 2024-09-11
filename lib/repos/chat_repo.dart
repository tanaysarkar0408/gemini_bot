import 'dart:developer';

import 'package:gemini_bot/utils/constants.dart';
import 'package:dio/dio.dart';

import '../models/chat_message_model.dart';

class ChatRepo {
  //List of all the previous chats
  static Future<String?> chatTextGenerationRepo(List<ChatMessageModel> previousMessages) async {
    try {
      Dio dio = Dio();
      final response = await dio.post(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$kApi_Key',
          data: {
            "contents": previousMessages.map((e) => e.toMap()).toList(),
            //convert every element to map and then to list
            "generationConfig": {
              "temperature": 0.9,
              "topK": 1,
              "topP": 1,
              "maxOutputTokens": 2048,
              "stopSequences": []
            },
            "safetySettings": [
              {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              }
            ]
          });
      if(response.statusCode! >= 200 && response.statusCode! <= 300){
        return response.data['candidates'].first['content']['parts'].first['text'];
      }
      log(response.toString());
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
