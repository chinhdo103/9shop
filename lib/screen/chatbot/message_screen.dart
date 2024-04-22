import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final List messages;
  const MessageScreen({super.key, required this.messages});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView.separated(
      itemCount: widget.messages.length,
      separatorBuilder: (context, index) =>
          const Padding(padding: EdgeInsets.only(top: 10)),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: widget.messages[index]["isUserMessage"]
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(20),
                      topLeft: const Radius.circular(20),
                      bottomRight: Radius.circular(
                          widget.messages[index]["isUserMessage"] ? 0 : 20),
                      topRight: Radius.circular(
                          widget.messages[index]["isUserMessage"] ? 20 : 0),
                    ),
                    color: widget.messages[index]["isUserMessage"]
                        ? Colors.blue.shade900
                        : Colors.green.shade700),
                constraints: BoxConstraints(maxWidth: width * 2 / 3),
                child: Text(
                  widget.messages[index]["message"].text.text[0],
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
