import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_space/model/community_icons.dart';

import '../../model/colors.dart';
import '../widgets/cText.dart';
import 'groupchat_page.dart';

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key});

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
        ),
        toolbarHeight: 75,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [cText(fontSize: 30, text: "Your Community")],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        backgroundColor: AppColors.mediumBrown,
      ),
      body: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(12),
          //   color: Colors.blue.shade50,
          //   child: const Text(
          //     "This is a peer support space. Be kind. No professional advice here.",
          //     style: TextStyle(fontSize: 13),
          //   ),
          // ),

          // Group list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('community')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No groups available right now"),
                  );
                }

                final groups = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupchatPage(
                              groupName: group['name'],
                              groupId: group.id,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: AppColors.lightestBrowm,
                        margin: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: 12,
                        ),
                        child: Container(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 20),
                              CircleAvatar(
                                backgroundColor: AppColors.brown,
                                radius: 35,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.lightestBrowm,
                                  radius: 32,
                                  // child: CircleAvatar(
                                  //   backgroundColor: AppColors.lightestBrowm,
                                  //   radius: 25,
                                  child: Icon(
                                    CommunityIcons.icons[group.id] ??
                                        Icons.group_outlined,
                                    size: 25,
                                    color: AppColors.brown,
                                  ),
                                ),
                                // ),
                              ),
                              SizedBox(width: 20),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  cText(
                                    fontSize: 18,
                                    text: group['name'],
                                    color: Colors.white,
                                  ),
                                  Text(
                                    group['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.lightGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
