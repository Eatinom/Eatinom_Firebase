import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_grid/responsive_grid.dart';

class General extends StatefulWidget {
  General({Key key, this.title}) : super(key: key);
  final String title;

  @override
  GeneralPage createState() => new GeneralPage();
}

class GeneralPage extends State<General> {
  String selectedProfilePic = 'ProfilePic1.jpg';
  static final _formKey = new GlobalKey<FormState>();
  bool isSaving = false;
  bool isLoaded = false;
  Key _k1 = new GlobalKey();
  Key _k2 = new GlobalKey();
  Key _k3 = new GlobalKey();
  Key _k4 = new GlobalKey();
  Key _k5 = new GlobalKey();
  Key _k6 = new GlobalKey();
  TextEditingController ctrlFirstName = new TextEditingController();
  TextEditingController ctrlLastName = new TextEditingController();
  TextEditingController ctrlEmail = new TextEditingController();
  TextEditingController ctrlPhone = new TextEditingController();
  TextEditingController ctrlDOB = new TextEditingController();
  DocumentSnapshot data;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Customer')
        .doc(AppConfig.userID)
        .get()
        .then((value) {
      data = value;
      if (data.data().containsKey('First_Name')) {
        ctrlFirstName.text = data['First_Name'];
      }
      if (data.data().containsKey('Last_Name')) {
        ctrlLastName.text = data['Last_Name'];
      }
      if (data.data().containsKey('Email')) {
        ctrlEmail.text = data['Email'];
      }
      if (data.data().containsKey('Phone_Number')) {
        ctrlPhone.text = data['Phone_Number'];
      }
      if (data.data().containsKey('DOB')) {
        ctrlDOB.text = data['DOB'];
      }
      if (data.data().containsKey('ProfilePic')) {
        selectedProfilePic = data['ProfilePic'];
      }
      print(data.id);
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppConfig.context = context;
    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.blueGrey, //change your color here
          ),
          title: Text("General Profile",
              textScaleFactor: 1.0,
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  color: Colors.blueGrey,
                  fontSize: 20.0)),
          backgroundColor: Colors.white,
          //centerTitle: true,
        ),
        body: isLoaded
            ? showData()
            : Container(
                height: 300.0,
                child: Center(child: CircularProgressIndicator())));
  }

  Widget showData() {
    return Stack(children: [
      Container(
          child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Column(children: [
          ProfilePic(data),
          SizedBox(height: 20.0),
          inputBox(
              'First Name',
              data.data().containsKey('First_Name') ? data['First_Name'] : '',
              'eg. Tony',
              ctrlFirstName,
              _k1),
          inputBox(
              'Last Name',
              data.data().containsKey('Last_Name') ? data['Last_Name'] : '',
              'eg. Stark',
              ctrlLastName,
              _k2),
          inputBox(
              'Email',
              data.data().containsKey('Email') ? data['Email'] : '',
              'eg. Tony@gmail.com',
              ctrlEmail,
              _k3),
          inputBox(
              'Phone',
              data.data().containsKey('Phone_Number')
                  ? data['Phone_Number']
                  : '',
              'eg. 9999999999',
              ctrlPhone,
              _k4),
          inputBox('D.O.B', data.data().containsKey('DOB') ? data['DOB'] : '',
              'eg. DD/MM/YYYY', ctrlDOB, _k5),
          SizedBox(height: 50.0)
        ]),
      )),
      Align(alignment: Alignment.bottomCenter, child: ConfirmButton()),
      isSaving
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.4),
              child: Center(
                  child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black45,
                                blurRadius: 5.0,
                                spreadRadius: 1.0)
                          ]),
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator())))
          : SizedBox(),
    ]);
  }

  Widget ProfilePic(DocumentSnapshot dt) {
    try {
      return InkWell(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.30,
          color: HexColor('#f1f1f1'),
          child: Center(
              child: Stack(children: [
            Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 1.0)
                  ]),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/' + selectedProfilePic),
              ),
            ),
            InkWell(
              child: Container(
                  width: 90.0,
                  height: 100.0,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(Icons.edit_outlined,
                          size: 20.0, color: Colors.black))),
              onTap: () {
                ShowProfilePics();
              },
            )
          ])),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      );
    } catch (err) {
      print(err.toString());
      return SizedBox();
    }
  }

  Widget ShowProfilePics() {
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      List<String> pics = [
        'ProfilePic1.jpg',
        'ProfilePic2.jpg',
        'ProfilePic3.jpg'
      ];

      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          isScrollControlled: true,
          isDismissible: true,
          backgroundColor: Colors.white,
          context: context,
          builder: (context) {
            List<Widget> lst = new List<Widget>();
            pics.forEach((element) {
              lst.add(InkWell(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: selectedProfilePic == element
                                ? Colors.green
                                : Colors.black26,
                            blurRadius:
                                selectedProfilePic == element ? 5.0 : 1.0)
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/' + element),
                  ),
                ),
                onTap: () {
                  selectedProfilePic = element;
                  setState(() {});
                  Navigator.pop(context);
                },
              ));
            });

            return Container(
                height: MediaQuery.of(context).size.height * 0.60,
                padding: EdgeInsets.only(top: 10.0),
                child: ResponsiveGridList(
                  desiredItemWidth: 100,
                  scroll: false,
                  minSpacing: 11,
                  children: lst,
                ));
          });
    } catch (err) {
      print(err.toString());
      return SizedBox();
    }
  }

  Widget inputBox(String label, String value, String hint,
      TextEditingController ctrl, Key ky) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: .0, left: 20.0, right: 20.0),
      child: TextFormField(
          key: ky,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            labelText: label,
            labelStyle: TextStyle(
                fontSize: 18.0,
                color: Colors.blue.shade400,
                fontFamily: 'Product Sans'),
            errorText: '',
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.blueGrey.shade200,
                fontFamily: 'Product Sans'),
            filled: true,
            fillColor: HexColor('#f1f1f1'),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade100),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.blueGrey.shade100),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(
                  width: 1,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(width: 1, color: Colors.blueGrey.shade100)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(width: 1, color: Colors.blueGrey.shade100)),
          ),
          controller: ctrl,
          onTap: () async {
            if (label == 'D.O.B') {
              DateTime date = DateTime(1900);
              FocusScope.of(context).requestFocus(new FocusNode());

              date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));

              if (date != null) {
                ctrlDOB.text = date.day.toString() +
                    '/' +
                    date.month.toString() +
                    '/' +
                    date.year.toString();
                this.setState(() {});
              }
            }
          }),
    );
  }

  Widget ConfirmButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      constraints: const BoxConstraints(maxWidth: 500),
      child: RaisedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          setState(() {
            isSaving = true;
          });
          saveData();
        },
        color: Colors.green.shade300,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          width: double.infinity,
          child: Text(
            'Save Changes',
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  bool saveData() {
    try {
      if (ctrlFirstName.text.isEmpty) {
        GlobalActions.showToast_Error(
            'First Name Required', 'Please enter your first name', context);
        setState(() {
          isSaving = false;
        });
        return false;
      }

      if (ctrlLastName.text.isEmpty) {
        GlobalActions.showToast_Error(
            'Last Name Required', 'Please enter your first name', context);
        setState(() {
          isSaving = false;
        });
        return false;
      }

      if (ctrlFirstName.text.isEmpty) {
        GlobalActions.showToast_Error(
            'First Name Required', 'Please enter your last name', context);
        setState(() {
          isSaving = false;
        });
        return false;
      }

      if (ctrlPhone.text.isEmpty) {
        GlobalActions.showToast_Error(
            'Phone Number Required', 'Please enter your phone number', context);
        setState(() {
          isSaving = false;
        });
        return false;
      }

      CollectionReference customer = AppConfig.firestore.collection('Customer');

      customer.doc(AppConfig.userID).set({
        'First_Name': ctrlFirstName.text,
        'Last_Name': ctrlLastName.text,
        'Full_Name': ctrlFirstName.text + ' ' + ctrlLastName.text,
        'Last_Modified_Date': DateTime.now(),
        'Email': ctrlEmail.text,
        'Phone_Number': ctrlPhone.text,
        'DOB': ctrlDOB.text,
        'ProfilePic': selectedProfilePic
      }, SetOptions(merge: true)).then((value) {
        print("Customer Updated");
        Navigator.pop(context, true);
        GlobalActions.showToast_Sucess(
            'Success', 'Changes successfully updated to server.', context);
        /*setState(() {
          isSaving = false;
        });*/
      }).catchError((error) => print("issue while saving changes"));
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
