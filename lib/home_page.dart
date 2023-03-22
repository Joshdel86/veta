import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:veta/screens/add_prouct.dart';

import 'package:flutter/material.dart';
import 'package:veta/screens/size_config.dart';
import 'package:veta/screens/update_product.dart';
import 'package:veta/utils.dart';

class HomePageScreen extends StatefulWidget {
  final String id;
  HomePageScreen({required this.id});
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddProduct()));
                  //Implement logout functionality
                }),
          ],
          title: Center(child: Text('Availabble Products')),
          backgroundColor: Colors.lightBlueAccent,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Icon(Icons.logout),
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection(widget.id).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error'),
                );
              } else {
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    String price = data['pet_price'];
                    double _myBalance = double.parse(price);

                    String _newBalance =
                        NumberFormat.currency(symbol: '₦').format(_myBalance);

                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(15),
                          horizontal: getProportionateScreenWidth(15)),
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(10),
                          vertical: getProportionateScreenHeight(10)),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: getProportionateScreenWidth(70),
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        NetworkImage(data['pet_image']),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(15),
                                  ),
                                  Text(
                                    _newBalance,
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(10),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Name: ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data['pet_name'],
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(5),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Breed: ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data['pet_breed'],
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(5),
                                  ),
                                  Text(
                                    'Description: ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        data['pet_description'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateProduct(
                                                breed: data['pet_breed'],
                                                desc: data['pet_description'],
                                                image: data['pet_image'],
                                                name: data['pet_name'],
                                                taskId: data['id'],
                                                price: data['pet_price'])));
                                  },
                                  icon: Icon(
                                    Icons.edit_note,
                                    color: Colors.white,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    final user =
                                        FirebaseAuth.instance.currentUser!;
                                    String taskId = data['id'];
                                    await FirebaseFirestore.instance
                                        .collection(user.uid)
                                        .doc(taskId)
                                        .delete();

                                    successSnackBar(
                                        context: context,
                                        message:
                                            'product deleted successfully');
                                  },
                                  icon:
                                      Icon(Icons.delete, color: Colors.white)),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            })

        //  StreamBuilder(
        //     stream: FirebaseFirestore.instance.collection(widget.id).snapshots(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       } else if (snapshot.hasData) {
        //         final data = snapshot.data!;
        //         return ListView.builder(
        //             itemCount: data.docs.length,
        //             itemBuilder: (context, index) {
        //               print(index);
        //               var item = (data.docs[index].data() as Map);
        //               var image = item['pet_image'];
        //               var name = item['pet_name'];
        //               var desc = item['pet_description'];
        //               var model = item['pet_breed'];
        //               var amount = item['pet_price'];
        //               print(amount);
        //               // String data = snapshot.data.toString();
        //               double _myBalance = double.parse(amount);

        //               String _newBalance =
        //                   NumberFormat.currency(symbol: '₦').format(_myBalance);

        //               return
        // Container(
        //                 padding:
        //                     EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        //                 margin:
        //                     EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        //                 decoration: BoxDecoration(color: Colors.teal),
        //                 child: Row(
        //                   children: [
        //                     Expanded(
        //                       child: Column(
        //                         children: [
        //                           CircleAvatar(
        //                             radius: 40,
        //                             backgroundColor: Colors.white,
        //                             backgroundImage: NetworkImage(image),
        //                           ),
        //                           SizedBox(
        //                             height: 10,
        //                           ),
        //                           Text(
        //                             _newBalance,
        //                             style: TextStyle(
        //                                 color: Colors.white,
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 14),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       width: 20,
        //                     ),
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                       children: [
        //                         infoRow(title: 'Name', value: name),
        //                         SizedBox(
        //                           height: 10,
        //                         ),
        //                         infoRow(title: 'model', value: model),
        //                         SizedBox(
        //                           height: 10,
        //                         ),
        //                         infoRow(title: 'description', value: desc),
        //                         SizedBox(
        //                           height: 10,
        //                         ),
        //                         Row(
        //                           crossAxisAlignment: CrossAxisAlignment.end,
        //                           children: [
        //                             GestureDetector(
        //                               onTap: () {},
        //                               child: Icon(
        //                                 Icons.edit_document,
        //                                 size: 18,
        //                                 color: Colors.white,
        //                               ),
        //                             ),
        //                             SizedBox(
        //                               width: 35,
        //                             ),
        //                             GestureDetector(
        //                               onTap: () async {},
        //                               child: Icon(
        //                                 Icons.delete,
        //                                 size: 18,
        //                                 color: Colors.white,
        //                               ),
        //                             )
        //                           ],
        //                         )
        //                       ],
        //                     )
        //                   ],
        //                 ),
        //               );
        //             });
        //       } else {
        //         return Container(
        //           color: Colors.black,
        //           width: double.infinity,
        //           height: 300,
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 'No Product Yet',
        //                 style: TextStyle(fontSize: 30, color: Colors.blue),
        //               ),
        //               IconButton(
        //                 onPressed: () {
        //                   Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                           builder: (context) => const AddProduct()));
        //                   //Implement send functionality.
        //                 },
        //                 icon: const Icon(
        //                   Icons.add_circle_outline,
        //                   size: 50,
        //                   color: Colors.blue,
        //                 ),
        //               )
        //             ],
        //           ),
        //         );
        //       }
        //     }),
        // SafeArea(
        //   child:
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   children: <Widget>[
        //     Container(
        //       decoration: kMessageContainerDecoration,
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: <Widget>[
        //           Expanded(
        //             child: TextField(
        //               onChanged: (value) {
        //                 //Do something with the user input.
        //               },
        //               decoration: kMessageTextFieldDecoration,
        //             ),
        //           ),
        //           ElevatedButton(
        //             onPressed: () {
        //               //Implement send functionality.
        //             },
        //             child: Text(
        //               'Send',
        //               style: kSendButtonTextStyle,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     ElevatedButton(
        //         onPressed: () {
        //           // final double _height = MediaQuery.of(context).size.height;
        //           // final double _weight = MediaQuery.of(context).size.width;

        //           // print(_height);
        //           // print(_weight);
        //         },
        //         child: Text('Log Out'))
        //   ],
        // ),
        // ),
        );
  }

  Row infoRow({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          '${title.toUpperCase()} : ',
          style: TextStyle(color: Colors.white),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
