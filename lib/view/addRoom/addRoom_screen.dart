import 'dart:async';
import 'dart:typed_data';

import 'package:chat_app/Navigators/AddRoomNavigator.dart';
import 'package:chat_app/model/category.dart';
import 'package:chat_app/view_model/addRoom_screen_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/utils.dart' as Utils;

class AddRoomScreen extends StatefulWidget {
  static const String routeName = 'addRoom-screen';
  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen>
    implements AddRoomNavigator {
  AddRoomScreen_viewModel viewModel = AddRoomScreen_viewModel();
  var formKey = GlobalKey<FormState>();
  String roomTitle = '';
  String roomDesc = '';
  late Category selectedCategory;
  var categoryList=Category.getCategory();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
    selectedCategory=categoryList[0];
  }
  @override
  void hideLoading() {
    Utils.hideLoading(context);
  }

  @override
  void navigateToHome() {
    Timer(Duration(seconds: 4),
            () => Navigator.pop(context));
  }

  @override
  void showLoading() {
    Utils.showLoading(context);
  }

  @override
  void showMessage(String message) {
    Utils.showMessage(context, message, 'ok', (context){
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => viewModel,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Image.asset(
            'assets/images/main_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Chat App',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 35),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Create New Room',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Image.asset('assets/images/add_room.png'),
                            SizedBox(
                              height: 12,
                            ),

                            TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please enter room name';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                roomTitle = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'enter room name',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButton<Category>(
                                  // Initial Value
                                  value: selectedCategory,
                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: categoryList.map((Category category) {
                                    return DropdownMenuItem<Category>(
                                      value: category,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(category.title??''),
                                            Image.asset(category.image??'')
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (newCategory) {
                                    if(newCategory==null)return;
                                    selectedCategory=newCategory!;
                                    setState(() {

                                    });
                                  },

                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),


                            TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'please enter room description';
                                } else {
                                  return null;
                                }
                              },
                              maxLines: 4,
                                minLines: 4,
                              onChanged: (value) {
                                roomDesc = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'enter room description ',
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: validateForm, child: Text('Create')),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void validateForm() {
    if (formKey.currentState?.validate() == true) {
      //add room
      viewModel.addRoom(roomTitle, roomDesc, selectedCategory.categoryId);
    }
  }


}
