import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/create_account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttershare/pages/timeline.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/upload.dart';
import 'package:fluttershare/pages/search.dart';
import 'package:fluttershare/pages/profile.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> 
{
  final userscollectionRef = Firestore.instance.collection('users');
      bool isAuth = false;
      PageController pageController;
      int pageIndex = 0;
      final DateTime timestamp = DateTime.now();

      DocumentSnapshot userdoc;
      User currentuser;

      @override
      void initState() {
        super.initState();
        pageController = PageController();
        googleSignIn.onCurrentUserChanged.listen((account) {
          handleSignin(account);
        }, onError: (error) {
          print('error sigining in : $error');
        });
        googleSignIn.signInSilently(suppressErrors: false).then((account) {
          handleSignin(account);
        }).catchError((error) {
          print('error sigining in : $error');
        });
      }

      handleSignin(GoogleSignInAccount account) 
      {
        if (account != null) {
          createuserInFirestore();
          setState(() {
            isAuth = true;
          });
        } else {
          setState(() {
            isAuth = false;
          });
        }
      }
      
      @override
      void dispose(){
        pageController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) 
      {
        return isAuth ? buildAuthenticatedScreen() : buildLoginScreen();
      }

      Scaffold buildAuthenticatedScreen() 
      {
        return Scaffold(
          body: PageView(
            children: <Widget>[
              Timeline(),
              ActivityFeed(),
              Upload(),
              Search(),
              Profile()
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: CupertinoTabBar(
            currentIndex: pageIndex,
            onTap: onTap,
            activeColor: Theme.of(context).primaryColor,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.whatshot),),
              BottomNavigationBarItem(icon: Icon(Icons.notifications_active),),
              BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size: 35,),),
              BottomNavigationBarItem(icon: Icon(Icons.search),),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle),),
            ],
            ),
        );
      }

        Scaffold buildLoginScreen() 
        {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "FlutterShare",
                    style: TextStyle(
                        fontFamily: "Signatra", fontSize: 90.0, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () => login(),
                    child: Container(
                      width: 260,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/google_signin_button.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

      onPageChanged(int pageIndex){
        setState(() {
          this.pageIndex = pageIndex;
        });
      }

      onTap(int pageIndex){
    pageController.animateToPage(
      pageIndex,
      duration: Duration( milliseconds : 250),
      curve: Curves.bounceInOut );
  }
      
      createuserInFirestore() async {
        final account = googleSignIn.currentUser;
        userdoc = await userscollectionRef.document(account.id).get();
        if(!userdoc.exists){
         final username = await Navigator.push(context,MaterialPageRoute(builder: (context) => CreateAccount() ));
         userscollectionRef.document(account.id).setData({
           "id"         : account.id,
           "username"   : username,
           "photoUrl"   : account.photoUrl,
           "email"      : account.email,
           "displayName" : account.displayName,
           "bio" : "",
           "timestamp" :  timestamp
         });
         userdoc = await userscollectionRef.document(account.id).get();
        }
        currentuser = User.fromDocumnet(userdoc);
        print(currentuser.displayName);
      }
}

login() 
{
  googleSignIn.signIn();
}

logout() 
{
  googleSignIn.signOut();
}

