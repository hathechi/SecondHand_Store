import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/google_signin.dart';
import 'package:second_hand_store/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final emailAddressFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  bool passwordFieldVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: primaryColor,
      body: SafeArea(
        top: true,
        child: Align(
          alignment: AlignmentDirectional(0, 0),
          child: Container(
            width: 360,
            decoration: BoxDecoration(),
            child: Align(
              alignment: AlignmentDirectional(0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.asset(
                              'assets/images/logo.png',
                            ).image,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Color(0x1917171C),
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SelectionArea(
                      child: Text(
                    'Log in to your account',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: SelectionArea(
                        child: Text(
                      'Welcome back! Please enter your details.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                      ),
                    )),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 32, 0, 0),
                    child: Form(
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SelectionArea(
                                      child: Text(
                                    'Email',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                                ],
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                child: TextFormField(
                                  controller: emailAddressFieldController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                    ),
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFD0D5DD),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFD0D5DD),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFFDA29B),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFFDA29B),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            14, 16, 14, 16),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SelectionArea(
                                        child: Text(
                                      'Password',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 6, 0, 0),
                                  child: Container(
                                    child: TextFormField(
                                      controller: passwordFieldController,
                                      obscureText: passwordFieldVisibility,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your password',
                                        labelStyle: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                        ),
                                        hintStyle: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFD0D5DD),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFD0D5DD),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFFDA29B),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFFDA29B),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                14, 16, 14, 16),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              passwordFieldVisibility =
                                                  !passwordFieldVisibility;
                                            });
                                          },
                                          focusNode:
                                              FocusNode(skipTraversal: true),
                                          child: Icon(
                                            passwordFieldVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: SelectionArea(
                        child: Text(
                      'Forget password?',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Login'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.loginGoogle();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xFFD0D5DD),
                              width: 1,
                            ),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12, 0, 0, 0),
                                    child: SelectionArea(
                                        child: Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectionArea(
                            child: Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: primaryColor,
                          ),
                        )),
                        SelectionArea(
                            child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
