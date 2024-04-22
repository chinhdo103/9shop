import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:project_9shop/screen/chatbot/message_screen.dart';

class ChatBotScreen extends StatefulWidget {
  static const String id = 'ChatBotScreen';
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isListening = false;

  late AnimationController _micAnimationController;

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    _micAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hỗ trợ viên ảo 9Bot"),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Expanded(
              child: MessageScreen(messages: messages),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.blue.shade900,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(
                      IconlyLight.send,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _startListening();
                      _toggleMicAnimation();
                    },
                    icon: isListening
                        ? Image.asset(
                            'assets/images/microp.gif', // Replace with the path to your image asset
                            // Change color based on listening state
                            width: 24.0,
                            height: 24.0,
                          )
                        : const Icon(
                            Icons.mic,
                            color: Colors.white,
                          ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _startListening() async {
    if (!_speech.isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Speech Recognition Status: $status');
        },
        onError: (errorNotification) {
          print('Speech Recognition Error: $errorNotification');
        },
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      _speech.stop();
    }
  }

  void _toggleMicAnimation() {
    setState(() {
      isListening = !isListening;
      isListening
          ? _micAnimationController.forward()
          : _micAnimationController.reverse();
    });
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      EasyLoading.showToast('Hãy nhập tin nhắn');
    } else {
      setState(() {
        addMessage(
          Message(text: DialogText(text: [text])),
          true,
        );
      });
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) {
        return;
      } else {
        setState(() {
          addMessage(response.message!);
        });
      }
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({"message": message, "isUserMessage": isUserMessage});
  }

  @override
  void dispose() {
    _controller.dispose();
    dialogFlowtter.dispose();
    _speech.cancel();
    _micAnimationController.dispose();
    super.dispose();
  }
}
