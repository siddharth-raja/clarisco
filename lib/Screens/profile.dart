// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String imgurl = '';
  String email = '';
  bool loaded = false;

  // final FirebaseStorage _storage = FirebaseStorage.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final ImagePicker _picker = ImagePicker();
  // XFile? _image;

  final List badgesList = [
    {
      'icon' : Icons.verified,
      'text' : 'verified',
      'gained' : true
    },
    {
      'icon' : Icons.task,
      'text' : 'Go getter',
      'gained' : true
    },
    {
      'icon' : Icons.star,
      'text' : 'star',
      'gained' : true
    },
    {
      'icon' : Icons.center_focus_strong,
      'text' : 'focused',
      'gained' : true
    },
    {
      'icon' : Icons.wifi,
      'text' : 'network',
      'gained' : true
    },
    {
      'icon' : Icons.edit,
      'text' : 'edit',
      'gained' : true
    },
    {
      'icon' : Icons.settings,
      'text' : 'settings',
      'gained' : true
    },
    {
      'icon' : Icons.task,
      'text' : 'task',
      'gained' : true
    },
    {
      'icon' : Icons.verified,
      'text' : 'verified',
      'gained' : false
    },
    {
      'icon' : Icons.star,
      'text' : 'star',
      'gained' : false
    },
    {
      'icon' : Icons.center_focus_strong,
      'text' : 'focused',
      'gained' : false
    },
    {
      'icon' : Icons.wifi,
      'text' : 'network',
      'gained' : false
    }
  ];
  Future<void> processUser() async {
    final user = FirebaseFirestore.instance.collection('user');
    QuerySnapshot userdata = await user.where('id', isEqualTo: 1).get();
    for (var usr in userdata.docs) {
      setState(() {
        username = usr['name'];
        imgurl = usr['imgurl'];
        email = usr['email'];
      });
      setState(() {
        loaded = true;
      });
    }
  }

  // Future<void> _pickImage() async {
  //   bool isAllowed = await checkPermission(Permission.camera, context);
  //   if(isAllowed) {
  //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       setState(() {
  //         _image = image;
  //       });
  //       _uploadImage();
  //     }    
  //   } else {
  //     print('permission needed');
  //   }
  // }

  // Future<bool> checkPermission(Permission permission, BuildContext context) async {
  //   final status = await permission.request();
  //   if (status.isGranted || status.isLimited) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<void> _uploadImage() async {
  //   try {
  //     if (_image == null) return;
  //     Reference ref = _storage.ref().child('profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     await ref.putFile(File(_image!.path));
  //     String downloadUrl = await ref.getDownloadURL();
  //     await _firestore.collection('users').doc('user_id').update({
  //       'profileImageUrl': downloadUrl,
  //     });

  //     setState(() {
  //       imgurl = downloadUrl;
  //     });
  //     print('Image URL: $downloadUrl');
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    processUser();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loaded ? Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // _pickImage();
                        },
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle
                          ),
                          child: imgurl != '' ?
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image(
                              image: NetworkImage(imgurl),
                              height: 120, 
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ) : 
                          Center(
                            child: Text(username[0]+username[1].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),)
                          ) ,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(username, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),),
                      const SizedBox(height: 5,),
                      Text(email, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                      const SizedBox(height: 25,),
                      Container(
                        height: 45,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(24)
                        ),
                        child: const Center(child: Text('Edit profile', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle
                        ),
                        child: const Icon(Icons.power_settings_new, color: Colors.white,),
                      ),
                      const Text('Log Out', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),)
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30,),
              const Text('Your Badges', style: TextStyle(fontWeight: FontWeight.w600),),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = (constraints.maxWidth / 100).floor();

                      return GridView.builder(
                        primary: false,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 1,
                        ),
                        itemCount: badgesList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                height: constraints.maxWidth * 0.2,
                                width: constraints.maxWidth * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Icon(
                                    badgesList[index]['icon'],
                                    color: badgesList[index]['gained'] ? Colors.green : Colors.grey,
                                    size: constraints.maxWidth * 0.07,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                badgesList[index]['text'],
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                              const SizedBox(height: 5),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ) : const Center(
          child: CircularProgressIndicator(),
        )
      ),
    );
  }
}