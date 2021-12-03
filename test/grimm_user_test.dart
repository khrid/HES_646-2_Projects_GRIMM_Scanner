
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grimm_scanner/models/grimm_user.dart';
import 'package:test/test.dart';


void main() {
  test('GrimmUser is created from JSON', () {
    String json = "{id:akjsdkjdsa,uid:aOEPcNuWGsTJ0P05i7t0Gtul6Jy2,firstname:TestDemo,name:Sprint3,email:demo@sprint3.ch,enable:true,groups:[Administrator, Member, ObjectManager]}";
    final grimmUser = FirebaseFirestore.instance.collection("users").doc("aOEPcNuWGsTJ0P05i7t0Gtul6Jy2");
    print(jsonEncode(json));
    expect(grimmUser.id, "aOEPcNuWGsTJ0P05i7t0Gtul6Jy2");
  });
}