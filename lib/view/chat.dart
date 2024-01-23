import 'dart:io';
import 'package:capstone_project/theme/colors.dart';
import 'package:capstone_project/controllers/chat_controller.dart';
import 'package:capstone_project/models/admin_model.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  final int userID;
  final int adminID;
  const Chat({super.key, required this.userID, required this.adminID});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  ChatController chatController = ChatController();
  @override
  void initState() {
    chatController.getMessageUserData(widget.userID, widget.adminID);
    super.initState();
  }

  @override
  void dispose() {
    chatController.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    return Scaffold(
      drawer: const Sidebar(),
      body: SafeArea(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Platform.isAndroid
                    ? const Icon(EvaIcons.arrow_back,
                        color: ColorTheme.primaryColor)
                    : const Icon(CupertinoIcons.arrow_left,
                        color: ColorTheme.primaryColor),
              ),
              const Text("CHAT",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: ColorTheme.secondaryColor,
                      letterSpacing: 1.5,
                      wordSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              IconButton(
                onPressed: () => {},
                icon: const Icon(EvaIcons.bell,
                    color: ColorTheme.primaryColor),
              )
            ],
          ),
          StreamBuilder<List<Message>>(
            stream: chatController.readingStreamcontroller.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data![index];
                    final currentHM = DateFormat("hh:mm a");
                    var dateTime = currentHM.format(data.now);
                    return Align(
                      alignment: data.uid == widget.userID &&
                              data.sentBy.toString() == "user"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        children: [
                          Card(
                            color: data.uid == widget.userID &&
                                    data.sentBy.toString() == "user"
                                ? ColorTheme.secondaryColor
                                : Colors.grey.shade300,
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                data.sentBy.toString() == "user"
                                    ? data.message.toString()
                                    : data.message.toString(),
                                style: TextStyle(
                                    color: data.uid == widget.userID &&
                                            data.sentBy.toString() == "user"
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          Text(
                            dateTime,
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: messageController,
              decoration: InputDecoration(
                  hintText: "Message here...",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(EvaIcons.message_circle),
                    onPressed: () {
                      chatController.insertChatData(widget.userID,
                          widget.adminID, messageController.text);
                      messageController.clear();
                      setState(() {});
                    },
                  )),
            ),
          )
        ]),
      ),
    );
  }
}
