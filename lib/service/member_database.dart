// ignore: import_of_legacy_library_into_null_safe
import 'package:alternate_store_cms/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberDatabase{

  final CollectionReference _userRef = FirebaseFirestore.instance.collection('user');

  //  取得所有會員資料
  Stream<List<UserModel>> get showMember {
    return _userRef.snapshots().map((list) => list.docs
      .map((doc) => UserModel.fromFirestore(doc.data() as Map<String, dynamic>))
      .toList());
  }
  
}