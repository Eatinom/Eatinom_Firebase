import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/App/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMap extends StatefulWidget{
  OrderMap({Key key, this.order}) : super(key: key);
  final DocumentSnapshot order;
  @override
  OrderMapState createState() => new OrderMapState();
}

class OrderMapState extends State<OrderMap>{

  //CameraPosition _initialLocation = CameraPosition(target: LatLng(18.1119941,83.1369833),zoom: 13);
  Set<Marker> markers = {};
  GoogleMapController mapController;
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  bool isMapLoaded = false;
  Completer<GoogleMapController> _controller = Completer();

  //static const LatLng _center =  const LatLng(widget.order['Delivery_Location'].latitude,widget.order['Delivery_Location'].longitude);
  LatLng _lastMapPosition;
  DocumentSnapshot order;

  @override
  void initState(){
    super.initState();
    order = widget.order;
    loadMarkers(order);
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    ScreenUtil().allowFontScaling = false;

    reAnimateMap(widget.order);

    return !isMapLoaded ? Container(
        color: Colors.blueGrey.shade50,
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
        child: Center(child: CircularProgressIndicator())
    )
        :
    Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
        GoogleMap(
          markers: markers != null ? Set<Marker>.from(markers) : null,
          initialCameraPosition: CameraPosition(target: LatLng(order['Delivery_Location'].latitude,order['Delivery_Location'].longitude),zoom: 13),
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          polylines: Set<Polyline>.of(polylines.values),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            _controller.complete(controller);
            print('mapController called');
            final LatLng offerLatLng = LatLng(
                order['Delivery_Location'].latitude,
                order['Delivery_Location'].longitude);
            final LatLng endLoc = LatLng(
                order['Chef_Location'].latitude,
                order['Chef_Location'].longitude);

            LatLngBounds bound;
            if (offerLatLng.latitude > endLoc.latitude &&
                offerLatLng.longitude > endLoc.longitude) {
              bound = LatLngBounds(southwest: endLoc, northeast: offerLatLng);
            } else if (offerLatLng.longitude > endLoc.longitude) {
              bound = LatLngBounds(
                  southwest: LatLng(offerLatLng.latitude, endLoc.longitude),
                  northeast: LatLng(endLoc.latitude, offerLatLng.longitude));
            } else if (offerLatLng.latitude > endLoc.latitude) {
              bound = LatLngBounds(
                  southwest: LatLng(endLoc.latitude, offerLatLng.longitude),
                  northeast: LatLng(offerLatLng.latitude, endLoc.longitude));
            } else {
              bound = LatLngBounds(southwest: offerLatLng, northeast: endLoc);
            }

            CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
            this.mapController.animateCamera(u2).then((void v){
              check(u2,this.mapController);
            });
          },
          onCameraMove: _onCameraMove,
        ),
        order.data().containsKey('Live_Status') ? Align(alignment: Alignment.bottomCenter,
          child: Container(
            height: 40.0,
              child: Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.blue.shade50,
                child: Center(
                  child: Text('Move pin to set delivery location',textScaleFactor: 1.0, style: TextStyle(color: Colors.blue,fontSize: 15.0,fontFamily: 'Product Sans'))
                )
              )
          )
        ) : SizedBox()
      ]),
    );
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1=await c.getVisibleRegion();
    LatLngBounds l2=await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if(l1.southwest.latitude==-90 ||l2.southwest.latitude==-90)
      check(u, c);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }


  void loadMarkers(DocumentSnapshot order) async{
    try{
      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId('Customer'),
        position: LatLng(order['Delivery_Location'].latitude, order['Delivery_Location'].longitude),
        infoWindow: InfoWindow(
          title: 'Customer',
          snippet: 'Delivery Location',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId('Chef'),
        position: LatLng(order['Chef_Location'].latitude, order['Chef_Location'].longitude),
        infoWindow: InfoWindow(
          title: 'Chef',
          snippet: 'Chef Location',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);


      polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        AppConfig.mapsApiKey, // Google Maps API Key
        PointLatLng(order['Delivery_Location'].latitude, order['Delivery_Location'].longitude),
        PointLatLng(order['Chef_Location'].latitude, order['Chef_Location'].longitude),
        travelMode: TravelMode.driving,
      );

      print('result.points.isNotEmpty --- '+result.points.isNotEmpty.toString());
      if (result.points.isNotEmpty) {
        print('result.points --- '+result.points.length.toString());
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }

      PolylineId polyid = PolylineId('poly');
      Polyline polyline = Polyline(
        polylineId: polyid,
        color: Colors.blueGrey,
        points: polylineCoordinates,
        width: 3,
      );
      polylines[polyid] = polyline;


      this.setState(() {
        isMapLoaded = true;
      });

    }
    catch(err){
      print(err.toString());
    }
  }


  void reAnimateMap(DocumentSnapshot order){
    try{
      Timer(Duration(milliseconds: 500), () async {
        final LatLng offerLatLng = LatLng(
            order['Delivery_Location'].latitude,
            order['Delivery_Location'].longitude);
        final LatLng endLoc = LatLng(
            order['Chef_Location'].latitude,
            order['Chef_Location'].longitude);

        LatLngBounds bound;
        if (offerLatLng.latitude > endLoc.latitude &&
            offerLatLng.longitude > endLoc.longitude) {
          bound = LatLngBounds(southwest: endLoc, northeast: offerLatLng);
        } else if (offerLatLng.longitude > endLoc.longitude) {
          bound = LatLngBounds(
              southwest: LatLng(offerLatLng.latitude, endLoc.longitude),
              northeast: LatLng(endLoc.latitude, offerLatLng.longitude));
        } else if (offerLatLng.latitude > endLoc.latitude) {
          bound = LatLngBounds(
              southwest: LatLng(endLoc.latitude, offerLatLng.longitude),
              northeast: LatLng(offerLatLng.latitude, endLoc.longitude));
        } else {
          bound = LatLngBounds(southwest: offerLatLng, northeast: endLoc);
        }

        CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
        this.mapController.animateCamera(u2).then((void v){
          check(u2,this.mapController);
        });
      });
    }catch(err){

    }
  }

}