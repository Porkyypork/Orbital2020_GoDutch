import 'package:app/models/UserDetails.dart';
import 'package:app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // auth change user stream
  Stream<UserDetails> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // gets current UID
  Future<String> getCurrentUID() async {
    String uid = (await _auth.currentUser()).uid;
    return uid;
  }

  // create user object base on FirebaseUser
  UserDetails _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? UserDetails(
            name: user.displayName,
            uid: user.uid,
            email: user.email,
            number: user.phoneNumber,
            groups: [])
        : null;
  }

  //sign in with email and passowrd
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserDetails user = _userFromFirebaseUser(result.user);
      return user;
    } catch (e) {
      if (e.code == "ERROR_INVALID_EMAIL") {
        return "The email address is badly formatted.";
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        return "Wrong Password!";
      } else if (e.code == "ERROR_USER_NOT_FOUND") {
        return "User not found!";
      } else {
        return e.message;
      }
    }
  }

  //sign in with google
  Future<UserDetails> signInWithGoogle() async {
    FirebaseUser user;

    final GoogleSignInAccount googleUser =
        await _googleSignIn.signIn().catchError((onError) {
      return null;
    });
    if (googleUser == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    AuthResult _authResult = await _auth.signInWithCredential(credential);
    user = _authResult.user;
    await DataBaseService(uid: user.uid)
        .updateUserData(user.displayName, user.email, user.phoneNumber);
    return _userFromFirebaseUser(user);
  }

  // register with email and password
  Future<UserDetails> registerWithEmailAndPassword(
      UserDetails newUser, String password) async {
    try {
      UserUpdateInfo updateInfo = new UserUpdateInfo();
      updateInfo.displayName = newUser.name;
      await _auth.createUserWithEmailAndPassword(
        email: newUser.email,
        password: password,
      );
      FirebaseUser fUser = await _auth.currentUser();
      fUser.updateProfile(updateInfo);
      fUser.reload();
      fUser = await _auth.currentUser();
      UserDetails user = _userFromFirebaseUser(fUser);
      await DataBaseService(uid: user.uid)
          .updateUserData(newUser.name, newUser.email, newUser.number);
      return user;
    } catch (error) {
      if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return UserDetails(uid: 'Error_1');
      }
      return null;
    }
  }

  Future<int> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 1;
    } catch (error) {
      if (error.code == "ERROR_INVALID_EMAIL") {
        return -1;
      } else if (error.code == "ERROR_USER_NOT_FOUND") {
        return 0;
      }
      return null;
    }
  }

  //sign out
  Future<void> signOut() async {
    _auth.signOut();
    _googleSignIn.signOut();
  }
}
