import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';

class AddressModel {
  String id;
  String name;
  String phoneNumber;
  String provinceID;
  String province;
  String districtID;
  String district;
  String communeID;
  String commune;
  String detailedAddress;
  DateTime? dateTime;
  bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.provinceID,
    required this.province,
    required this.districtID,
    required this.district,
    required this.communeID,
    required this.commune,
    required this.detailedAddress,
    this.dateTime,
    this.selectedAddress = true,
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);


  static AddressModel empty() => AddressModel(id: '', name: '', phoneNumber: '', provinceID: '', province: '', districtID: '', district: '', communeID: '', commune: '', detailedAddress: '');


  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Province': province,
      'ProvinceID': provinceID,
      'District': district,
      "DistrictID": districtID,
      'Commune': commune,
      "CommuneID": communeID,
      'DetailedAddress': detailedAddress,
      'DateTime' : DateTime.now(),
      'SelectedAddress' : selectedAddress,
    };
  }


  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      id: data['Id'] as String,
      name: data['Name'] as String,
      phoneNumber: data['PhoneNumber'] as String,
      provinceID: data['ProvinceID'] as String,
      province: data['Province'] as String,
      districtID: data['DistrictID'] as String,
      district: data['District'] as String,
      communeID: data['CommuneID'] as String,
      commune: data['Commune'] as String,
      detailedAddress: data['DetailedAddress'] as String,
      selectedAddress: data['SelectedAddress'] as bool,
      dateTime: (data['DateTime'] as Timestamp).toDate(),
    );
  }

  // Factory constructor to create an AddressModel from a DocumentSnapshot
  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return AddressModel(
      id: snapshot.id,
      name: data['Name'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      provinceID: data['ProvinceID'] ?? '',
      province: data['Province'] ?? '',
      districtID: data['DistrictID'] ?? '',
      district: data['District'] ?? '',
      communeID: data['CommuneID'] ?? '',
      commune: data['Commune'] ?? '',
      detailedAddress: data['DetailedAddress'] ?? '',
      dateTime: (data['DateTime'] as Timestamp).toDate(),
      selectedAddress: data['SelectedAddress'] as bool,
    );
  }

  @override
  String toString() {
    return '$detailedAddress, $commune, $district, $province';
  }
}
