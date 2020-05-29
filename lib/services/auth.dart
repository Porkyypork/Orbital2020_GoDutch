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
    return user != null ? UserDetails(
      name: user.displayName,
      uid: user.uid,
      email: user.email,
      number: user.phoneNumber,
      groups : []
      ) : null;
  }

  //sign in with email and passowrd
  Future<UserDetails> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserDetails user = _userFromFirebaseUser(result.user);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with google
  Future<UserDetails> signInWithGoogle() async {
    FirebaseUser user;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, 
        idToken: googleAuth.idToken,
      );

    AuthResult _authResult = await _auth.signInWithCredential(credential);
    user = _authResult.user;
    await DataBaseService(uid: user.uid).updateUserData(user.displayName, user.email, user.phoneNumber);
    return _userFromFirebaseUser(user);
  }

  // register with email and password
  Future<UserDetails> registerWithEmailAndPassword(UserDetails newUser, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: newUser.email, 
          password: password,
        );
      UserDetails user = _userFromFirebaseUser(result.user);
      await DataBaseService(uid: result.user.uid).updateUserData(newUser.name, newUser.email, "");
      return user;
    } catch (error) {
      if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return UserDetails(uid : 'Error_1');
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
