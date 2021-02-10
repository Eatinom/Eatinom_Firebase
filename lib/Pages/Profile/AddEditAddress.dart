import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:eatinom/Util/GlobalActions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:place_picker/place_picker.dart';
import 'package:place_picker/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';


class AddEditAddress extends StatefulWidget {
  AddEditAddress({Key key, this.address}) : super(key: key);
  final DocumentSnapshot address;
  final String apiKey = AppConfig.mapsApiKey;

  @override
  State<StatefulWidget> createState() => AddEditAddressState();
}

/// Place picker state
class AddEditAddressState extends State<AddEditAddress>{

  TextEditingController yourAddress = TextEditingController();
  TextEditingController yourLandmark = TextEditingController();
  TextEditingController yourTitle = TextEditingController();

  DocumentSnapshot address;
  final Completer<GoogleMapController> mapController = Completer();

  /// Indicator for the selected location
  final Set<Marker> markers = Set();

  /// Result returned after user completes selection
  LocationResult locationResult;

  /// Overlay to display autocomplete suggestions
  OverlayEntry overlayEntry;

  List<NearbyPlace> nearbyPlaces = List();

  /// Session token required for autocomplete API call
  String sessionToken = Uuid().generateV4();

  GlobalKey appBarKey = GlobalKey();

  bool hasSearchTerm = false;

  String previousSearchTerm = '';

  TextEditingController editController = TextEditingController();

  Timer debouncer;

  bool hasSearchEntry = false;
  bool isSaving = false;


  // constructor
  AddEditAddressState();


  void onMapCreated(GoogleMapController controller) {
    this.mapController.complete(controller);
    moveToCurrentUserLocation();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    if(AppConfig.currentPosition != null ){
      markers.add(Marker(
        position: LatLng(AppConfig.currentPosition.latitude, AppConfig.currentPosition.longitude),
        markerId: MarkerId("selected-location"),
      ));
    }

    if(widget.address != null){
      address = widget.address;
      if(address.data().containsKey('Title')){
        yourTitle.value = TextEditingValue(text: address['Title']);
      }
   /*   if(address.data().containsKey('Landmark')){
        yourLandmark.value = TextEditingValue(text: address['Landmark']);
      }*/
      if(address.data().containsKey('Address')){
        yourAddress.value = TextEditingValue(text: address['Address']);
      }
    }


    this.editController.addListener(this.onSearchInputChange);

  }



  @override
  void dispose() {
    this.overlayEntry?.remove();
    this.editController.removeListener(this.onSearchInputChange);
    this.editController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    return GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            key: this.appBarKey,
            title: Text(address != null ? address['Title'] : 'New Address',textScaleFactor: 1.0, style: TextStyle(fontFamily: 'Product Sans', color: Colors.blueGrey)),
            //centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.blueGrey, //change your color here
            ),
            actions: [
              address != null ? InkWell(
                child: Container(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Center(
                    child: Text('Delete',textScaleFactor: 1.0, style: TextStyle(color: Colors.red, fontSize: 15.0, fontFamily: 'Product Sans'))
                  )
                ),
                onTap: (){
                  deleteAddress();
                },
              ): SizedBox()
            ],
          ),
          body: Stack(children: [

            SingleChildScrollView(
              child: Column(children: [

                //Map
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40 - AppBar().preferredSize.height,
                    child: ShowMap()
                ),

                SizedBox(height: 10.0),

                Align(
                    alignment: Alignment.topLeft,
                    child: Container(color: Colors.white,width: double.infinity,
                        padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 5.0,top: 10.0),
                        child: Text('Title', textAlign: TextAlign.left,style: TextStyle(color: Colors.green,fontFamily: 'Product Sans',fontSize: 18.0))
                    )
                ),

                Align(
                    alignment: Alignment.topLeft,
                    child: Container(color: Colors.white,
                      padding: EdgeInsets.only(bottom: 5.0,top: 5.0),
                      child:TitleBox(),
                    )
                ),

                Align(
                    alignment: Alignment.topLeft,
                    child: Container(color: Colors.white,width: double.infinity,
                        padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 5.0,top: 10.0),
                        child: Text('Address Info', textAlign: TextAlign.left,style: TextStyle(color: Colors.green,fontFamily: 'Product Sans',fontSize: 18.0))
                    )
                ),

                Align(
                    alignment: Alignment.topLeft,
                    child: Container(color: Colors.white,
                      padding: EdgeInsets.only(bottom: 5.0,top: 5.0),
                      child:LandmarkBox(),
                    )
                ),
                Align(
                    alignment: Alignment.bottomCenter ,
                    child: Container(color: Colors.white,
                        padding: EdgeInsets.only(bottom: 25.0),
                        child:EditAddressBox()
                    )
                ),

              ]),
            ),


            isSaving ? Container(
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
                            boxShadow: [BoxShadow(
                                color: Colors.black45,
                                blurRadius: 5.0,
                                spreadRadius: 1.0
                            )]
                        ),
                        height: 50.0,width: 50.0,
                        child: CircularProgressIndicator()
                    )
                )
            ): SizedBox(),
          ]),
          bottomNavigationBar: SaveButton(),
        )
    );
  }

  Widget ShowMap(){
    try{

      return Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(AppConfig.currentPosition.latitude, AppConfig.currentPosition.longitude),
            zoom: 15,
          ),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          padding: EdgeInsets.only(top:5.0,bottom: 40.0),
          onMapCreated: onMapCreated,
          onTap: (latLng) {
            clearOverlay();
            moveToLocation(latLng);
          },
          markers: markers,
        ),
        Align(alignment: Alignment.bottomCenter,child: Container(
            height: 35.0,
            child: Container(
                padding: EdgeInsets.all(0.0),
                color: Colors.blue.shade50,
                child: Center(
                    child: FittedBox(child: Text('Move pin to set delivery location', style: TextStyle(color: Colors.blue,fontSize: 15.0,fontFamily: 'Product Sans')), fit: BoxFit.cover)
                )
            )
        )),
        searchInputCustom(),
      ]);
    }
    catch(err){
      print(err.toString());
      return Center(child: Text('Error while loading map', style: TextStyle(color: Colors.red, fontSize: 20.0,fontFamily: 'Product Sans')));
    }
  }


  /// Hides the autocomplete overlay
  void clearOverlay() {
    if (this.overlayEntry != null) {
      this.overlayEntry.remove();
      this.overlayEntry = null;
    }
  }

  void searchPlaceCustom(String place) {
    // on keyboard dismissal, the search was being triggered again
    // this is to cap that.
    if (place == this.previousSearchTerm) {
      return;
    }

    previousSearchTerm = place;

    if (context == null) {
      return;
    }

    clearOverlay();

    setState(() {
      hasSearchTerm = place.length > 0;
    });

    if (place.length < 1) {
      return;
    }

    final RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;

    final RenderBox appBarBox =
    this.appBarKey.currentContext.findRenderObject();

    this.overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: appBarBox.size.height,
        width: size.width,
        child: Material(
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: <Widget>[
                SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 3)),
                SizedBox(width: 24),
                Expanded(
                    child: Text("Finding place...",
                        style: TextStyle(fontSize: 16)))
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(this.overlayEntry);

    autoCompleteSearchCustom(place);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearchCustom(String place) async {
    try {
      place = place.replaceAll(" ", "+");

      var endpoint =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?" +
              "key=${widget.apiKey}&" +
              "input={$place}&sessiontoken=${this.sessionToken}";
      if (this.locationResult != null) {
        endpoint += "&location=${this.locationResult.latLng.latitude}," +
            "${this.locationResult.latLng.longitude}";
      }

      final response = await http.get(endpoint);

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['predictions'] == null) {
        throw Error();
      }

      List<dynamic> predictions = responseJson['predictions'];

      List<RichSuggestion> suggestions = [];

      if (predictions.isEmpty) {
        AutoCompleteItem aci = AutoCompleteItem();
        aci.text = "No result found";
        aci.offset = 0;
        aci.length = 0;

        suggestions.add(RichSuggestion(aci, () {}));
      } else {
        for (dynamic t in predictions) {
          final aci = AutoCompleteItem()
            ..id = t['place_id']
            ..text = t['description']
            ..offset = t['matched_substrings'][0]['offset']
            ..length = t['matched_substrings'][0]['length'];

          suggestions.add(RichSuggestion(aci, () {
            FocusScope.of(context).requestFocus(FocusNode());
            decodeAndSelectPlaceCustom(aci.id);
          }));
        }
      }

      displayAutoCompleteSuggestionsCustom(suggestions);
    } catch (e) {
      print(e);
    }
  }

  void decodeAndSelectPlaceCustom(String placeId) async {
    clearOverlay();

    try {
      final response = await http.get(
          "https://maps.googleapis.com/maps/api/place/details/json?key=${widget.apiKey}" +
              "&placeid=$placeId");

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['result'] == null) {
        throw Error();
      }

      final location = responseJson['result']['geometry']['location'];
      moveToLocation(LatLng(location['lat'], location['lng']));
    } catch (e) {
      print(e);
    }
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestionsCustom(List<RichSuggestion> suggestions) {
    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    final RenderBox appBarBox =
    this.appBarKey.currentContext.findRenderObject();

    clearOverlay();

    this.overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        top: appBarBox.size.height + 60.0,
        child: Material(elevation: 1, child: Column(children: suggestions)),
      ),
    );

    Overlay.of(context).insert(this.overlayEntry);
  }

  String getLocationName() {
    if (this.locationResult == null) {
      return "Unnamed location";
    }

    for (NearbyPlace np in this.nearbyPlaces) {
      if (np.latLng == this.locationResult.latLng &&
          np.name != this.locationResult.locality) {
        this.locationResult.name = np.name;
        return "${np.name}, ${this.locationResult.locality}";
      }
    }

    return "${this.locationResult.name}, ${this.locationResult.locality}";
  }

  /// Moves the marker to the indicated lat,lng
  void setMarker(LatLng latLng) {
    // markers.clear();
    setState(() {
      markers.clear();
      markers.add(
          Marker(markerId: MarkerId("selected-location"), position: latLng));
    });
  }

  /// Fetches and updates the nearby places to the provided lat,lng
  void getNearbyPlaces(LatLng latLng) async {
    try {
      final response = await http.get(
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" +
              "key=${widget.apiKey}&" +
              "location=${latLng.latitude},${latLng.longitude}&radius=150");

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Error();
      }

      this.nearbyPlaces.clear();

      for (Map<String, dynamic> item in responseJson['results']) {
        final nearbyPlace = NearbyPlace()
          ..name = item['name']
          ..icon = item['icon']
          ..latLng = LatLng(item['geometry']['location']['lat'],
              item['geometry']['location']['lng']);

        this.nearbyPlaces.add(nearbyPlace);
      }

      // to update the nearby places
      setState(() {
        // this is to require the result to show
        this.hasSearchTerm = false;
      });
    } catch (e) {
      //
    }
  }

  /// This method gets the human readable name of the location. Mostly appears
  /// to be the road name and the locality.
  void reverseGeocodeLatLng(LatLng latLng) async {
    try {
      final response = await http.get(
          "https://maps.googleapis.com/maps/api/geocode/json?" +
              "latlng=${latLng.latitude},${latLng.longitude}&" +
              "key=${widget.apiKey}");

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Error();
      }

      final result = responseJson['results'][0];

      print('address result --- '+result.toString());

      setState(() {

        if(result != null && result['formatted_address'] != null){
          print('new address detected');
          yourAddress.text = result['formatted_address'].toString();
        }




        String name,
            locality,
            postalCode,
            country,
            administrativeAreaLevel1,
            administrativeAreaLevel2,
            city,
            subLocalityLevel1,
            subLocalityLevel2;
        bool isOnStreet = false;
        if (result['address_components'] is List<dynamic> &&
            result['address_components'].length != null &&
            result['address_components'].length > 0) {
          for (var i = 0; i < result['address_components'].length; i++) {
            var tmp = result['address_components'][i];
            var types = tmp["types"] as List<dynamic>;
            var shortName = tmp['short_name'];
            if (types == null) {
              continue;
            }
            if (i == 0) {
              // [street_number]
              name = shortName;
              isOnStreet = types.contains('street_number');
              // other index 0 types
              // [establishment, point_of_interest, subway_station, transit_station]
              // [premise]
              // [route]
            } else if (i == 1 && isOnStreet) {
              if (types.contains('route')) {
                name += ", $shortName";
              }
            } else {
              if (types.contains("sublocality_level_1")) {
                subLocalityLevel1 = shortName;
              } else if (types.contains("sublocality_level_2")) {
                subLocalityLevel2 = shortName;
              } else if (types.contains("locality")) {
                locality = shortName;
              } else if (types.contains("administrative_area_level_2")) {
                administrativeAreaLevel2 = shortName;
              } else if (types.contains("administrative_area_level_1")) {
                administrativeAreaLevel1 = shortName;
              } else if (types.contains("country")) {
                country = shortName;
              } else if (types.contains('postal_code')) {
                postalCode = shortName;
              }
            }
          }
        }
        locality = locality ?? administrativeAreaLevel1;
        city = locality;
        this.locationResult = LocationResult()
          ..name = name
          ..locality = locality
          ..latLng = latLng
          ..formattedAddress = result['formatted_address']
          ..placeId = result['place_id']
          ..postalCode = postalCode
          ..country = AddressComponent(name: country, shortName: country)
          ..administrativeAreaLevel1 = AddressComponent(
              name: administrativeAreaLevel1,
              shortName: administrativeAreaLevel1)
          ..administrativeAreaLevel2 = AddressComponent(
              name: administrativeAreaLevel2,
              shortName: administrativeAreaLevel2)
          ..city = AddressComponent(name: city, shortName: city)
          ..subLocalityLevel1 = AddressComponent(
              name: subLocalityLevel1, shortName: subLocalityLevel1)
          ..subLocalityLevel2 = AddressComponent(
              name: subLocalityLevel2, shortName: subLocalityLevel2);
      });
    } catch (e) {
      print(e);
    }
  }

  /// Moves the camera to the provided location and updates other UI features to
  /// match the location.
  void moveToLocation(LatLng latLng) {
    this.mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 15.0)),
      );
    });

    setMarker(latLng);

    reverseGeocodeLatLng(latLng);

  }

  void moveToCurrentUserLocation() {
    if (AppConfig.currentPosition != null) {
      moveToLocation(LatLng(AppConfig.currentPosition.latitude, AppConfig.currentPosition.longitude));
      return;
    }

    Location().getLocation().then((locationData) {
      LatLng target = LatLng(locationData.latitude, locationData.longitude);
      moveToLocation(target);
    }).catchError((error) {
      // TODO: Handle the exception here
      print(error);
    });
  }


  Widget searchInputCustom(){
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
          )]
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Container(padding: EdgeInsets.only(left: 10.0),child: Icon(Icons.search, color: Colors.blueGrey)),
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: "Search your location", border: InputBorder.none,contentPadding: EdgeInsets.only(left: 20.0,top: 0.0),),
              controller: this.editController,
              onChanged: (value) {
                setState(() {
                  this.hasSearchEntry = value.isNotEmpty;
                });
              },
            ),
          ),
          SizedBox(width: 8),
          if (this.hasSearchEntry)
            GestureDetector(
              child: Icon(Icons.clear, color: Colors.black45,),
              onTap: () {
                this.editController.clear();
                setState(() {
                  this.hasSearchEntry = false;
                });
              },
            ),
        ],
      ),

    );
  }


  void onSearchInputChange() {
    print('onSearchInputChange called');
    if (this.editController.text.isEmpty) {
      this.debouncer?.cancel();
      searchPlaceCustom(this.editController.text);
      return;
    }

    if (this.debouncer?.isActive ?? false) {
      this.debouncer.cancel();
    }

    this.debouncer = Timer(Duration(milliseconds: 500), () {
      searchPlaceCustom(this.editController.text);
    });
  }


  Widget SaveButton(){

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      child: RaisedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          if(address != null){
            updateAddress();
          }else{
            saveAddress();
          }

        },
        color: Colors.green.shade300,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
                'Save',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 18.0),
              ),
          ),
        ),

    );
  }




  Widget ActionsBlock(){
    return Container(
        padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.50) + 0.0),
        //height: MediaQuery.of(context).size.height * 0.50,
        //child: SingleChildScrollView(
        child:Container(
            padding: EdgeInsets.all(0.0),
            child: ListView(children: [
              SizedBox(height: 10.0),
              Align(alignment: Alignment.centerLeft,child: Container(
                  padding: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: Text('Your Address', textAlign: TextAlign.left,style: TextStyle(color: Colors.green,fontFamily: 'Product Sans',fontSize: 18.0))
              )),
              SizedBox(height: 5.0),
              LandmarkBox(),
              EditAddressBox(),
              SizedBox(height: 5.0),
              Align(alignment: Alignment.centerLeft,child: Container(padding: EdgeInsets.only(left: 20.0,right: 20.0),child: Text('Or Pick from the following', textAlign: TextAlign.left,style: TextStyle(color: Colors.green,fontFamily: 'Product Sans',fontSize: 16.0)))),
              SizedBox(height: 60.0),
            ])
        )
      //)
    );
  }

  Widget EditAddressBox(){

    return Container(
      height: 150,
      padding: EdgeInsets.only(top: 7.0,left: 20.0,right: 20.0,bottom: 7.0),
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      margin: const EdgeInsets.only(left: 0,right: 0),
      child: CupertinoTextField(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0,bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        controller: yourAddress,
        clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        maxLength: 1000,
        placeholder: 'Full Address',
      ),
    );

  }

  Widget LandmarkBox(){

    return Container(
      height: 60,
      padding: EdgeInsets.only(top: 7.0,left: 20.0,right: 20.0,bottom: 7.0),
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      margin: const EdgeInsets.only(left: 0,right: 0),
      child: CupertinoTextField(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 11.0,bottom: 11.0),
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        controller: yourLandmark,
        clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        maxLength: 100,
        placeholder: 'Near Landmark',
      ),
    );

  }

  Widget TitleBox(){

    return Container(
      height: 60,
      padding: EdgeInsets.only(top: 7.0,left: 20.0,right: 20.0,bottom: 7.0),
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      margin: const EdgeInsets.only(left: 0,right: 0),
      child: CupertinoTextField(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 11.0,bottom: 11.0),
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        controller: yourTitle,
        clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: TextInputType.text,
        maxLines: 1,
        maxLength: 50,
        placeholder: 'Title',
      ),
    );

  }


  bool saveAddress(){
    try{
      if(yourTitle.text.isEmpty){
        GlobalActions.showToast_Error('Title Required', 'Please enter title of address', context);
        setState(() {
          isSaving = false;
        });
        return false;
      }

      if(yourAddress.text.isEmpty){
        GlobalActions.showToast_Error('Address Required', 'Please enter your address details', context);
        setState(() {
          isSaving = false;
        });
        return false;
      }

      CollectionReference customer = AppConfig.firestore.collection('Customer/'+AppConfig.userID+'/SavedAddresses');

      String Locality = '';
      String SubLocality = '';
      GeoPoint pt;
      try
      {
        if(locationResult != null) {
          if (locationResult.subLocalityLevel1.name != null) {
            SubLocality = locationResult.subLocalityLevel1.name;
            Locality = locationResult.locality;
          }
          else if (locationResult.administrativeAreaLevel2.name != null) {
            SubLocality = locationResult.locality;
            Locality = locationResult.administrativeAreaLevel2.name;
          }
          else {
            SubLocality = locationResult.formattedAddress.split(',')[0];
            Locality = locationResult.locality;
          }

          pt = new GeoPoint(locationResult.latLng.latitude, locationResult.latLng.longitude);
        }
        else{
          pt = new GeoPoint(0.0, 0.0);
        }
      }catch(err){
        print(err);
      }
      customer.add({
        'Title': yourTitle.text,
        'Landmark': yourLandmark.text,
        'Address': yourAddress.text,
        'Location': pt != null ? pt : new GeoPoint(0.0, 0.0),
        'CreatedOn': DateTime.now(),
        'Sub_Locality': SubLocality,
        'Locality': Locality
      })
      .then((value){
        print("address added");
        Navigator.pop(context,true);
        GlobalActions.showToast_Sucess('Success', 'Address added successfully.', context);
      })
      .catchError((error) => print("issue while saving changes"));
    }
    catch(err){
      GlobalActions.showToast_Error('Error', 'Error while saving changes to server', context);
    }
  }

  bool updateAddress(){
    try{
      if(yourTitle.text.isEmpty){
        GlobalActions.showToast_Error('Title Required', 'Please enter title of address', context);
        setState(() {
          isSaving = false;
        });
        return false;
      }

      if(yourAddress.text.isEmpty){
        GlobalActions.showToast_Error('Address Required', 'Please enter your address details', context);
        setState(() {
          isSaving = false;
        });
        return false;
      }

      CollectionReference customer = AppConfig.firestore.collection('Customer/'+AppConfig.userID+'/SavedAddresses');

      String Locality = '';
      String SubLocality = '';
      GeoPoint pt;
      try
      {
        if(locationResult != null) {
          if (locationResult.subLocalityLevel1.name != null) {
            SubLocality = locationResult.subLocalityLevel1.name;
            Locality = locationResult.locality;
          }
          else if (locationResult.administrativeAreaLevel2.name != null) {
            SubLocality = locationResult.locality;
            Locality = locationResult.administrativeAreaLevel2.name;
          }
          else {
            SubLocality = locationResult.formattedAddress.split(',')[0];
            Locality = locationResult.locality;
          }

          pt = new GeoPoint(locationResult.latLng.latitude, locationResult.latLng.longitude);
        }
        else{
          pt = new GeoPoint(0.0, 0.0);
        }
      }catch(err){
        print(err);
      }

      customer.doc(address.id).set({
        'Title': yourTitle.text,
        'Landmark': yourLandmark.text,
        'Address': yourAddress.text,
        'Location': pt != null ? pt : new GeoPoint(0.0, 0.0),
        'CreatedOn': DateTime.now(),
        'Sub_Locality': SubLocality,
        'Locality': Locality
      }, SetOptions(merge: true))
      .then((value){
        print("address updated");
        Navigator.pop(context,true);
        GlobalActions.showToast_Sucess('Success', 'Address updated successfully.', context);
      })
      .catchError((error) => print("issue while saving changes"));
    }
    catch(err){
      GlobalActions.showToast_Error('Error', 'Error while saving changes to server', context);
    }
  }

  bool deleteAddress(){
    try{
      FirebaseFirestore.instance.collection("Customer/"+AppConfig.userID+'/SavedAddresses').doc(address.id).delete();
      Navigator.pop(context, true);
    }
    catch(err){
      print(err);
      GlobalActions.showToast_Error('Error', 'Issue in processing your request.', context);
    }
  }


}
