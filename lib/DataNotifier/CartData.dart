import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatinom/Pages/Cart/CartHolder.dart';
import 'package:flutter/material.dart';

class CartData{
  static ValueNotifier notifier = ValueNotifier(0);
  static void callNotifier() {
    notifier.value++;
  }
 // static Map<String , int> CartItems = new Map<String, int>();
  static Map<String , CartHolder> cart = new Map<String , CartHolder>();

  static int getItemCount(String itemID){
    try{
      if(cart.containsKey(itemID) != null){
        return cart[itemID].count;
      }
      else{
        return 0;
      }
    }
    catch(err){
      return 0;
    }
  }
//dt == item

  static void increaseItemCount(DocumentSnapshot item){
    try{
      // ignore: unrelated_type_equality_checks
            if (item['Order_Type'] == 'Pre') {
              if(CartData.cart != null && CartData.cart.length > 0){
                // lst.add(couponCodeBox());
                CartData.cart.values.forEach((hld) {
                  print(hld.item.id);
                  print(hld.item['Order_Type']);
                  if(hld.item['Order_Type']=='Instant'){
                  //  cart.remove(hld.item.id);
                    cart.clear();
                  }
                }
                );
              }

              if (cart.containsKey(item.id) ) {
                print("conditon applied");
                CartHolder hld = cart[item.id];
                hld.count = hld.count + 1;
                hld.item = item;
                cart[item.id] = hld;

              }else {
                CartHolder hld = new CartHolder();
                hld.count = 1;
                hld.item = item;
                cart[item.id] = hld;
              }
            }


            if (item['Order_Type'] == 'Instant') {
              if(CartData.cart != null && CartData.cart.length > 0){
                // lst.add(couponCodeBox());
                CartData.cart.values.forEach((hld) {
                  print(hld.item.id);
                  print(hld.item['Order_Type']);
                  if(hld.item['Order_Type']=='Pre'){
                   // cart.remove(hld.item.id);
                    cart.clear();
                  }
                }
                );

              }

              if (cart.containsKey(item.id) ) {
                print("conditon applied");
                CartHolder hld = cart[item.id];
                hld.count = hld.count + 1;
                hld.item = item;
                cart[item.id] = hld;

              }else {

                CartHolder hld = new CartHolder();
                hld.count = 1;
                hld.item = item;
                cart[item.id] = hld;
              }
            }


    }
    catch(err){
      CartHolder hld = new CartHolder();
      hld.count = 1;
      hld.item = item;
      cart[item.id] = hld;
    }
    callNotifier();
  }

  static void decreaseItemCount(DocumentSnapshot item){
    try{
      if(cart.containsKey(item.id)){
        if(cart[item.id] == null || cart[item.id].count <= 1){
          cart.remove(item.id);
        }else{
          CartHolder hld = cart[item.id];
          hld.count = hld.count - 1;
          cart[item.id] = hld;
        }
      }
    }
    catch(err){
      print(err);
    }
    callNotifier();
  }


  static CartHolder getCartItem(String itemId){
    //if(cart.containsKey(itemId)==ChefData.availableChefIDs_Instant && cart.containsKey(itemId)!=ChefData.availableChefIDs_Pre)
    return cart[itemId];
  }



  static void setCartItem(CartHolder hld){
      cart[hld.item.id] = hld;
  }


}


