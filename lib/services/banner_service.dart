import 'dart:io';
import 'package:asher_store_cms/model/banner_model.dart';
import 'package:asher_store_cms/randomstring_gender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BannerService{
  final CollectionReference _ref = FirebaseFirestore.instance.collection('banner');

  //  取得所有 Banner
  Stream<List<BannerModel>> get getBanner {
    return _ref.orderBy('CREATE_DATE' , descending: true).snapshots().map((list) => list.docs
      .map((doc) => BannerModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
      .toList());
  }

  //  上載 Banner 圖片
  Future<String> uploadImage(File imageList) async {
    Reference storageRef = FirebaseStorage.instance.ref().child('banner/${randomStringGender(20, true).toUpperCase()}.jpg');
    final UploadTask uploadTask = storageRef.putFile(File(imageList.path));
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }

  //  上載 Banner 
  Future<void> uploadBanner(String url, String queryString) async{
    try{
    DocumentReference xref = FirebaseFirestore.instance.collection('banner').doc();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(xref);
        if (!snapshot.exists) {
          xref.set({
            'CREATE_DATE': Timestamp.now(),
            'URL': url,
            'KEY': queryString
          });
        }
      });
    } catch (e){
      // ignore: avoid_print
      print(e);
    }
  }

  //  更新封面
  Future<void> updateBanner(String docId, String queryString, String imagePatch) async {
    DocumentReference xref = FirebaseFirestore.instance.collection('banner').doc(docId);
    xref.update({
      'KEY' : queryString,
      'URL' : imagePatch
    });
  }

  //  剷除封面
  void removeBanner(String docId){
    DocumentReference xref = FirebaseFirestore.instance.collection('banner').doc(docId);
    xref.delete();
  }


}