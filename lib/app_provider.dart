import 'package:flutter/cupertino.dart';

class MessageBombProvider extends ChangeNotifier {
  List<String> bombedMessage = [];
  bool needNumber = false;

  //Explode message method
  void explodeMessage(
      TextEditingController count, TextEditingController message) {
    bombedMessage.clear();
    if (message.text.isNotEmpty && count.text.isNotEmpty) {
      for (int i = 0; i < int.parse(count.text); i++) {
        bombedMessage.add(message.text);
        notifyListeners();
      }
    }
  }

  //Check for numbers
  void checkNumber(bool value) {
    needNumber = value;
    notifyListeners();
  }
}
