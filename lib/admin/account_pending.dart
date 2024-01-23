import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';

class AccountPending extends StatefulWidget {
  const AccountPending({ super.key });

  @override
  AccountPendingState createState() => AccountPendingState();
}

class AccountPendingState extends State<AccountPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(RouteName.dashboardEmergency);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ColorTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 5,),


             Container(
              margin: const EdgeInsets.only(left: 20),
              padding: const EdgeInsets.all(8),
              child: const Text("Pending Accounts", style: TextStyle(color: ColorTheme.secondaryColor, fontSize: 24, letterSpacing: 1.5, wordSpacing: 0.5)),
            ),

            FutureBuilder(
              future: UserController.displayUserAccounts(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return const Center(child:CircularProgressIndicator(color: ColorTheme.primaryColor,),);
                }else if(snapshot.data!.isEmpty){
                  return const Center(child: Text("No data", style: TextStyle(fontSize: 40),),);
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            data.profile.toString() == "default"
                              ? Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/default_profile.jpg"),
                                          fit: BoxFit.cover)),
                              ) : CachedNetworkImage(
                                placeholder: (context, url) => Container(),
                                imageUrl: ImagesAPI.getImagesUrl(
                                    data.profile.toString()),
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )),
                                  );
                                },
                              ),

                              Text(data.email, style: const TextStyle(color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 16)),

                               TextButton(
                                onPressed: () => UserController.deleteUserAccounts(data.uid, context),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: ColorTheme.primaryColor
                                  ),
                                  child: const Text("DELETE" ,style: TextStyle(color: ColorTheme.accentColor, letterSpacing: 1.5, wordSpacing: 0.5)),
                                ),
                              ) ,

                              

                          ],
                        ),
                      );
                    },
                  );
                }
              },
            )
          
          ],
        ),
      ),
    );
  }
}