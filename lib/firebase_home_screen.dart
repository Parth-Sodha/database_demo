import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_demo/contact_model.dart';
import 'package:database_demo/db_helper.dart';
import 'package:flutter/material.dart';

class FirebaseHomeScreen extends StatefulWidget {
  const FirebaseHomeScreen({super.key});

  @override
  State<FirebaseHomeScreen> createState() => _FirebaseHomeScreenState();
}

class _FirebaseHomeScreenState extends State<FirebaseHomeScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  List<ContactModel> contactList = [];
  final CollectionReference myRef =
  FirebaseFirestore.instance.collection('contact_master');


  Future<void> fetchDataFromFirestore() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('contact_master').get();

    contactList.clear();

    for (int i = 0; i < snapshot.docs.length; i++) {
      var userData = snapshot.docs[i].data() as Map<String, dynamic>;

      ContactModel model = ContactModel(
          userData['name'] ?? 'No Name',
          userData['mobile'] ?? 'Unknown'
      );
      contactList.add(model);
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Screen'),),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Name:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            TextFormField(
              controller: nameController,
             decoration: InputDecoration(),
            ),
            SizedBox(height: 5,),

            Text('Enter Mobile No:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(),
            ),

            SizedBox(height: 50,),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    String name = nameController.text;
                    String mobileNo = mobileController.text;

                    myRef.add({
                      'name' : name,
                      'mobile' : mobileNo
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 100, vertical: 10)
                  ),
                  child: Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    onPressed: () async {
                      fetchDataFromFirestore();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 100, vertical: 10)
                    ),
                    child: Text('Show Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    ContactModel model = contactList[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(model.mobile,
                          style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),
                        ),
                        Divider()
                      ],
                    );
                  },
              ),
            )

          ],
        ),
      ),
    );
  }
}
