import 'dart:async';
import 'dart:convert';
import 'package:capstone_project/connection/api.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_project/controllers/chat_controller.dart';
import 'package:capstone_project/models/admin_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:capstone_project/theme/colors.dart';
class ChatAdmin extends StatefulWidget {
  final int userID;
  final int adminID;
  const ChatAdmin({super.key, required this.userID, required this.adminID});

  @override
  ChatAdminState createState() => ChatAdminState();
}

class ChatAdminState extends State<ChatAdmin> {
  List<MessageAdmin> dataMessage = <MessageAdmin>[];
  bool isInit = false;
  final ChatController chatController = Get.put(ChatController());
  StreamController<List<MessageAdmin>> readingStreamController =
      StreamController<List<MessageAdmin>>();

  Future<void> closeStream() => readingStreamController.close();

  Future<void> insertChatAdminData(int fromID, int toID, String message) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final response =
          await http.post(Uri.parse(API.insertChatAdminAPI), body: {
        "fromID": fromID.toString(),
        "toID": toID.toString(),
        "message": message.toString()
      });

      if (response.statusCode == 200) {}
    } catch (e) {
      //
    }
  }

  // Future<List<MessageAdmin>> getMessageAdminData(
  //     var adminID, var userID) async {
  //   List<MessageAdmin> temp = <MessageAdmin>[];
  //   try {
  //     final response = await http.get(
  //         Uri.parse(API.displayChatAdminData(adminID, userID)),
  //         headers: {"Accept": "application/json"});

  //     if (response.statusCode == 200) {

  //       setState(() {
  //         var jsonData = jsonDecode(response.body);
  //         for (var result in jsonData) {
  //           MessageAdmin model = MessageAdmin(
  //               cid: result["cid"],
  //               aid: result["aid"],
  //               uid: result["uid"],
  //               message: result["message"],
  //               uName: result["uName"],
  //               username: result["username"],
  //               sentBy: result["sentBy"],
  //               now: DateTime.parse(result["date"]));
  //           temp.add(model);
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   return temp;
  // }

  void getMessageAdminData(var adminID, var userID) async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();

      try {
        final response = await http.get(
            Uri.parse(API.displayChatAdminData(adminID, userID)),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          // for (var result in jsonData) {
          //   MessageAdmin model = MessageAdmin(
          //       cid: result["cid"],
          //       aid: result["aid"],
          //       uid: result["uid"],
          //       message: result["message"],
          //       uName: result["uName"],
          //       username: result["username"],
          //       sentBy: result["sentBy"],
          //       now: DateTime.parse(result["date"]));
          //   readingStreamController.sink.add(model);
          // }
          List<MessageAdmin> readings = jsonData.map<MessageAdmin>((json) {
            return MessageAdmin.fromJson(json);
          }).toList();

          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }

  @override
  void initState() {
    getMessageAdminData(widget.adminID, widget.userID);
    // chatController.getMessageAdmin(widget.adminID, widget.userID);
    // getMessageAdminData(widget.userID, widget.adminID).then((value) {
    //   setState(() {
    //     dataMessage.addAll(value);
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHAT"),
        centerTitle: true,
      ),
      // drawer: const AdminSidebar(),
      body: SafeArea(
        child: Column(children: [
          StreamBuilder<List<MessageAdmin>>(
            stream: readingStreamController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator(color: ColorTheme.primaryColor,);
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data![index];
                    var dateTime = DateFormat().add_jm().format(data.now);
                    return Align(
                      alignment: data.aid == widget.adminID &&
                              data.sentBy.toString() == "admin"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Column(
                        children: [
                          Card(
                            color: data.aid == widget.adminID &&
                                    data.sentBy.toString() == "admin"
                                ? Colors.grey.shade300
                                : const Color.fromRGBO(123, 97, 255, 1),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                data.sentBy.toString() == "admin"
                                    ? data.message.toString()
                                    : data.message.toString(),
                                style: TextStyle(
                                    color: data.aid == widget.adminID &&
                                            data.sentBy.toString() == "admin"
                                        ? Colors.black
                                        : Colors.white),
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
                    icon: const Icon(EvaIcons.message_circle, color: ColorTheme.secondaryColor,),
                    onPressed: () {
                      setState(() {
                        insertChatAdminData(widget.userID, widget.adminID,
                            messageController.text);
                        messageController.clear();
                        getMessageAdminData(widget.adminID, widget.userID);
                      });
                    },
                  )),
            ),
          )
        ]),
      ),
    );
  }
}
