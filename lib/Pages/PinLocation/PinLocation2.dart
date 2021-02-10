import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/DataNotifier/CartData.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:place_picker/place_picker.dart';
import 'package:place_picker/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';


class PinLocation2 extends StatefulWidget {

  final String apiKey = AppConfig.mapsApiKey;

  @override
  State<StatefulWidget> createState() => PinLocation2State();
}

/// Place picker state
class PinLocation2State extends State<PinLocation2>{

  TextEditingController yourAddress = TextEditingController();
  TextEditingController yourLandmark = TextEditingController();

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
  String selectedAddress;



  // constructor
  PinLocation2State();


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


    if(AppConfig.currentAddress != null){
      yourAddress.value = TextEditingValue(text: AppConfig.currentAddress);
    }
    if(AppConfig.landMark != null){
      yourLandmark.value = TextEditingValue(text: AppConfig.landMark);
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


    var mapHeight = (MediaQuery.of(context).size.height - (100 + kBottomNavigationBarHeight + AppBar().preferredSize.height));

    return GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },child: Scaffold(backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(key: this.appBarKey,
          title: Text('Set your location', style: TextStyle(fontFamily: 'Product Sans',color: Colors.blueGrey)),//SearchInput(searchPlace),
          //centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.blueGrey, //change your color here
          ),
        ),
        body:  Stack(
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.80 - AppBar().preferredSize.height,
                child: ShowMap()
            ),
            searchInputCustom(),
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(color: Colors.white,width: double.infinity,
                    padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 225.0,top: 10.0),
                    child: Text('Move pin to set new location ', textAlign: TextAlign.left,style: TextStyle(color: Colors.green,fontFamily: 'Product Sans',fontSize: 18.0))
                )
            ),

            Align(
                alignment: Alignment.bottomCenter,
                child: Container(color: Colors.white,
                  padding: EdgeInsets.only(bottom: 165.0),
                  child:LandmarkBox(),
                )
            ),
            Align(
                alignment: Alignment.bottomCenter ,
                child: Container(color: Colors.white,
                    padding: EdgeInsets.only(bottom: 90.0),
                    child:EditAddressBox()
                )
            ),
           // Align(alignment: Alignment.bottomLeft,child: Container(padding: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 65.0),child: Text('Or Pick from the following', textAlign: TextAlign.left,style: TextStyle(color: Colors.blueGrey,fontFamily: 'Product Sans',fontSize: 16.0)))),
         /*   Align(
                alignment: Alignment.bottomCenter ,child: Container(
              padding: EdgeInsets.only(bottom: 0.0),
              child: SizedBox(height: 60.0),
            )),*/
            Align(
                alignment: Alignment.bottomCenter ,child: Container(
              padding: EdgeInsets.only(bottom: 1.0),
              child: showSavedAddresses(),
            ))
          ],
        ),
        bottomNavigationBar: ConfirmLocationButton(),
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
          height: 40.0,
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.blue.shade50,
            child: Center(
              child: Text('Move pin to set delivery location', style: TextStyle(color: Colors.blue,fontSize: 15.0,fontFamily: 'Product Sans'))
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
          Container(padding: EdgeInsets.only(left: 10.0),child: Icon(Icons.search_rounded, color: Colors.blueGrey)),
          SizedBox(width: 8),
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


  Widget ConfirmLocationButton(){

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      constraints: const BoxConstraints(
          maxWidth: 500
      ),
      child: RaisedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          AppConfig.currentPosition = locationResult.latLng;
          AppConfig.currentAddress = locationResult.formattedAddress;
          //AppConfig.subLocality = locationResult.locality;
          AppConfig.locality = locationResult.administrativeAreaLevel2.name;
          AppConfig.subLocality = locationResult.formattedAddress.split(',')[0];

            CartData.cart.clear();
            Navigator.pushReplacementNamed(context, '/index');




        },
        color: Colors.green,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Save Location',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontSize: 18.0),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              )
            ],
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
            /*Align(alignment: Alignment.centerLeft,child: Container(
                padding: EdgeInsets.only(left: 20.0,right: 20.0),
                child: Text('Landmark', textAlign: TextAlign.left,style: TextStyle(color: Colors.blueGrey,fontFamily: 'Product Sans',fontSize: 15.0))
            )),*/

           /* Align(alignment: Alignment.centerLeft,child: Container(padding: EdgeInsets.only(left: 20.0,right: 20.0),child: Text('Or Pick from the following', textAlign: TextAlign.left,style: TextStyle(color: Colors.green,fontFamily: 'Product Sans',fontSize: 16.0)))),
            SizedBox(height: 60.0),*/
          ])
        )
      //)
    );
  }

  Widget EditAddressBox(){

    return Container(
      height: 75,
      padding: EdgeInsets.only(top: 7.0,left: 20.0,right: 20.0,bottom: 7.0),
   /*   constraints: const BoxConstraints(
          maxWidth: 500
      ),*/
      margin: const EdgeInsets.only(left: 0,right: 0),

      child:
      CupertinoTextField(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0,bottom: 10.0),
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
       // prefix: Image.asset(' assets/home.png', height: 24.0,width: 24.0),
        controller: yourAddress,
       clearButtonMode: OverlayVisibilityMode.editing,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        maxLength: 1000,
        placeholder: 'Full Address',
      ),
    );
  }

  Widget showSavedAddresses(){
    try{
      Text('Or Pic From The Saved Addresses');
      CollectionReference allAddresses = FirebaseFirestore.instance.collection('Customer/'+AppConfig.userID+'/SavedAddresses');

      return StreamBuilder<QuerySnapshot>(
        stream: allAddresses.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong',textScaleFactor: 1.0,);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: 300.0,
                child: Center(child: CircularProgressIndicator())
            );
          }

          if(snapshot.hasData && snapshot.data.docs.length > 0){
            List<Widget> lst = new List<Widget>();
            snapshot.data.docs.forEach((dt) {
              lst.add(InkWell(
                child: Container(
                    height: 70.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selectedAddress == dt.id ? Colors.green.shade50 : HexColor('#f1f1f1'),
                        boxShadow: [BoxShadow(
                          color: Colors.black26,
                          blurRadius: 0.5,
                        )]
                    ),
                    width: 200.0,
                    //margin: EdgeInsets.all(5.0),
                    child: Stack(children: [

                      Align(alignment: Alignment.topRight,
                        child: Container(
                          width: 160.0,
                          height: 70.0,
                          padding: EdgeInsets.all(10.0),
                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                            Align(alignment: Alignment.topLeft, child: Text(dt['Title'],textScaleFactor: 1.0,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blueGrey, fontSize: 15.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600))),
                            Align(alignment: Alignment.topLeft, child: Text(dt['Address'],textScaleFactor: 1.0,overflow: TextOverflow.ellipsis,maxLines: 2, style: TextStyle(color: Colors.blueGrey, fontSize: 10.0, fontFamily: 'Product Sans', fontWeight: FontWeight.w600)))
                          ]),
                        ),
                      ),
                      Align(alignment: Alignment.topLeft,
                        child: Container(
                          width: 40.0,
                          height: 80.0,
                          child: Icon(Icons.circle, color: selectedAddress == dt.id ? Colors.orange.shade100 : Colors.black12),
                        ),
                      ),
                    ])
                ),onTap: (){
                selectedAddress = dt.id;
                yourAddress.text = dt['Address'];
                yourLandmark.text = dt['Landmark'];
                if(dt.data().containsKey('Location')){
                  clearOverlay();
                  LatLng lc = new LatLng(dt['Location'].latitude , dt['Location'].longitude);
                  moveToLocation(lc);
                }

                setState(() { });
              },
              ));
              lst.add(SizedBox(width: 20.0));
            });
            return SingleChildScrollView(
              padding: EdgeInsets.only(left: 20.0),
              scrollDirection: Axis.horizontal,
              child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: lst),
            );
          }
          else{
            return SizedBox();
          }
        },
      );
    }
    catch(err){
      print(err);
    }
  }
  Widget LandmarkBox(){

    return Container(
      height: 55,
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
        maxLength: 1000,
        placeholder: 'Near Landmark',
      ),
    );

  }


}
