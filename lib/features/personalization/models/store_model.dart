import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String id;
  String storeName;
  String ownerName;
  String ownerCitizenID;
  String phoneNumber;
  String provinceID;
  String province;
  String districtID;
  String district;
  String communeID;
  String commune;
  String detailedAddress;
  String? image;

  StoreModel({
    required this.id,
    required this.storeName,
    required this.ownerName,
    required this.ownerCitizenID,
    required this.phoneNumber,
    required this.provinceID,
    required this.province,
    required this.districtID,
    required this.district,
    required this.communeID,
    required this.commune,
    required this.detailedAddress,
    this.image
  });

  /// Create Empty func for clean code
  static StoreModel empty() => StoreModel(id: '', storeName: '', ownerName: '', ownerCitizenID: '', phoneNumber: '', provinceID: '', province: '', districtID: '', district: '', communeID: '', commune: '', detailedAddress: '');

  /// Json Format
  toJson() {
    return {
      'StoreName': storeName,
      'OwnerName': ownerName,
      'OwnerCitizenID': ownerCitizenID,
      'PhoneNumber': phoneNumber,
      'Province': province,
      'ProvinceID': provinceID,
      'District': district,
      "DistrictID": districtID,
      'Commune': commune,
      "CommuneID": communeID,
      "DetailedAddress": detailedAddress,
      'Image': image,
    };
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory StoreModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StoreModel(
      id: document.id,
      storeName: data['StoreName'],
      ownerName: data['OwnerName'],
      ownerCitizenID: data['OwnerCitizenID'],
      phoneNumber: data['PhoneNumber'] ?? '',
      provinceID: data['ProvinceID'] ?? '',
      province: data['Province'] ?? '',
      districtID: data['DistrictID'] ?? '',
      district: data['District'] ?? '',
      communeID: data['CommuneID'] ?? '',
      commune: data['Commune'] ?? '',
      detailedAddress: data['DetailedAddress'] ?? '',
      image: data['Image'] ?? ''
    );
  }

  // Map Json-oriented document snapshot from Firebase to Model
  factory StoreModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return StoreModel(
      id: document.id,
      storeName: data['StoreName'] ?? '',
      ownerName: data['OwnerName'] ?? '',
      ownerCitizenID: data['OwnerCitizenID'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      provinceID: data['ProvinceID'] ?? '',
      province: data['Province'] ?? '',
      districtID: data['DistrictID'] ?? '',
      district: data['District'] ?? '',
      communeID: data['CommuneID'] ?? '',
      commune: data['Commune'] ?? '',
      detailedAddress: data['DetailedAddress'] ?? '',
      image: data['Image'] ?? ''
    );
  }

    /// Map Json oriented document snapshot from Firebase to StoreModel
  factory StoreModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return StoreModel.empty();
    return StoreModel(
      id: '',
      storeName: data['StoreName'] ?? '',
      ownerName: data['OwnerName'] ?? '',
      ownerCitizenID: data['OwnerCitizenID'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      provinceID: data['ProvinceID'] ?? '',
      province: data['Province'] ?? '',
      districtID: data['DistrictID'] ?? '',
      district: data['District'] ?? '',
      communeID: data['CommuneID'] ?? '',
      commune: data['Commune'] ?? '',
      detailedAddress: data['DetailedAddress'] ?? '',
      image: data['Image'] ?? ''
    );
  }

  @override
  String toString() {
    return '$detailedAddress, $commune, $district, $province';
  }
}
