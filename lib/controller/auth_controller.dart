import 'package:asher_store_cms/model/user_model.dart';
import 'package:asher_store_cms/service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  static AuthController instance = Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;
  late Rx<User?> user;
  late Rx<UserModel?> userModel = Rx(UserModel());
  // final googleSignIn = GoogleSignIn();

  @override
  void onReady() {
    super.onReady();
    user = Rx<User?>(auth.currentUser);
    user.bindStream(auth.userChanges());
    if(user.value != null){
      bindUserData();
    }
  }

  //  登出
  Future<void> signOut() async {
    await auth.signOut();
  }

  //  發送重置密碼電郵
  Future<void> passwordReset(String email) async {
    if(email.isEmpty){
      Get.snackbar('重置密碼失敗', '請輸入電郵', snackPosition: SnackPosition.BOTTOM);
    } else {
      try {
        await auth.sendPasswordResetEmail(email: email);
        Get.snackbar('重置密碼成功', '請檢查你的電子郵箱', snackPosition: SnackPosition.BOTTOM);
      } on FirebaseAuthException catch (e) {
        switch (e.code){
          case 'invalid-email':
          Get.snackbar('重置密碼失敗', '請輸入正確電郵', snackPosition: SnackPosition.BOTTOM);
          break;
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  //  以電郵登入
  Future<void> signIn(String email, String password) async {
    if(email.isEmpty){
      Get.snackbar('登入失敗', '請輸入電郵', snackPosition: SnackPosition.BOTTOM);
    } else if (password.isEmpty){
      Get.snackbar('登入失敗', '請輸入密碼', snackPosition: SnackPosition.BOTTOM);
    } else {
      try{
        await auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
          bindUserData();
        });
      } on FirebaseAuthException catch (e) {

        switch (e.code) {
          case 'invalid-email':
            Get.snackbar('登入失敗', '你所輸入的電郵或密碼不正確。', snackPosition: SnackPosition.BOTTOM);
            break;
          case 'wrong-password':
            Get.snackbar('登入失敗', '你所輸入的電郵或密碼不正確。', snackPosition: SnackPosition.BOTTOM);
            break;
          case 'too-many-requests':
            Get.snackbar('登入失敗', '由於多次登入失敗，請稍後嘗試。', snackPosition: SnackPosition.BOTTOM);
            break;
          default:
            Get.snackbar('登入失敗', '請稍後嘗試', snackPosition: SnackPosition.BOTTOM);
            break;
        }
        
      }
    }
    
  }

  //  綁定會員資料
  void bindUserData(){
    userModel.bindStream(FirebaseService().getUserInfo());
  }

}