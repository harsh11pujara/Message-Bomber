import 'package:explodemessage/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sms/flutter_sms.dart';


class Home extends StatelessWidget {
  Home({super.key});

  final TextEditingController _messageController = TextEditingController();

  final TextEditingController _count = TextEditingController();

  final TextEditingController _contact = TextEditingController();

  String message = "This is a test message!";

  List<String> recipents = ["9714159849"];

  sendingMsg() async{
    int num = int.parse(_count.text);
    for(int i = 0; i< num;i++){
      String _result = await sendSMS(message: _messageController.text, recipients: [_contact.text], sendDirect: true)
          .catchError((onError) {
        print(onError);
      });
      print(_result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final messageProvider = Provider.of<MessageBombProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Message Bomb")),
        body: Consumer<MessageBombProvider>(
          builder: (context, providerValue, child) {
            return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _messageController,
                      cursorColor: Colors.teal,
                      decoration: InputDecoration(
                          hintText: "Message",
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(25.0)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(25.0))),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _count,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.teal,
                      decoration: InputDecoration(
                          hintText: "Count",
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(25.0)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(25.0))),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _contact,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.teal,
                      decoration: InputDecoration(
                          hintText: "Contact Number",
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(25.0)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(25.0))),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          value: providerValue.needNumber,
                          onChanged: (value) {
                            providerValue.checkNumber(value!);
                          },
                        ),
                        const Text(
                          'Number Required!',
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 15,
                              letterSpacing: 1.0),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 40),
                            backgroundColor: const Color(0xFFBDBDBD)),
                        onPressed: () {
                          if (_count.text.isEmpty ||
                              _messageController.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Empty fields not allowed",
                                style: TextStyle(
                                    color: Colors.teal, letterSpacing: 1.0),
                              ),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                          sendingMsg();
                          providerValue.explodeMessage(
                              _count, _messageController);
                        },
                        child: Text(
                          "Explode".toUpperCase(),
                          style: const TextStyle(
                              letterSpacing: 1.0, fontWeight: FontWeight.w500),
                        )),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: List.generate(
                            providerValue.bombedMessage.length,
                            (index) {
                              return Text(
                                providerValue.needNumber
                                    ? "${index + 1}. ${providerValue.bombedMessage[index]}"
                                    : providerValue.bombedMessage[index],
                                style: const TextStyle(fontSize: 15),
                              );
                            }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            onPressed: () {
                              String inputString = providerValue.bombedMessage
                                  .toString()
                                  .replaceAll("]", "")
                                  .replaceAll("[", "")
                                  .replaceAll(" ", "");
                              List<String> words = inputString.split(",");
                              String outputString = providerValue.needNumber
                                  ? words
                                      .asMap()
                                      .map((index, word) => MapEntry(
                                          index + 1, '${index + 1}. $word'))
                                      .values
                                      .join("\n")
                                  : words
                                      .asMap()
                                      .map((index, word) =>
                                          MapEntry(index + 1, word))
                                      .values
                                      .join("\n");
                              Clipboard.setData(
                                      ClipboardData(text: outputString))
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.white,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text('Copied',
                                            style:
                                                TextStyle(letterSpacing: 1.0)),
                                        duration: Duration(milliseconds: 500)));
                              });
                            },
                            child: const Center(child: Icon(Icons.copy)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: FloatingActionButton(
                            onPressed: () {
                              // void shareOnWhatsApp(String message) async {
                              //   final url =
                              //       'whatsapp://send?text=${Uri.encodeComponent(message)}';

                              //   if (await canLaunch(url)) {
                              //     await launch(url);
                              //   } else {
                              //     throw 'Could not launch $url';
                              //   }
                              // }
                            },
                            child: Icon(Icons.share),
                          ),
                        ),
                      ],
                    )
                  ],
                ));
          },
        ));
  }
}
