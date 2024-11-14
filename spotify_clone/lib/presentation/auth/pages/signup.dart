import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify_clone/common/helper/navigation/app_navigation.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/button/basic_app_button.dart';
import 'package:spotify_clone/core/config/assets/app_vectors.dart';
import 'package:spotify_clone/data/models/auth/create_user_req.dart';
import 'package:spotify_clone/domain/usecases/auth/signup.dart';
import 'package:spotify_clone/presentation/auth/pages/signin.dart';
import 'package:spotify_clone/presentation/auth/widgets/custom_text_field.dart';
import 'package:spotify_clone/presentation/auth/widgets/row_button.dart';
import 'package:spotify_clone/presentation/home/pages/home.dart';
import 'package:spotify_clone/service_locator.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 33,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _registerText(),
              SizedBox(height: 50),
              CustomTextField(
                hintText: 'Full Name',
                controller: _fullNameCtrl,
              ),
              SizedBox(height: 15),
              CustomTextField(
                hintText: 'Enter Email',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 15),
              CustomTextField(
                hintText: 'Password',
                controller: _passwordCtrl,
              ),
              SizedBox(height: 20),
              BasicAppButton(
                title: 'Create Account',
                onPressed: () async {
                  var result = await sl<SignupUseCase>().call(
                    params: CreateUserReq(
                      fullName: _fullNameCtrl.text.toString(),
                      email: _emailCtrl.text.toString(),
                      password: _passwordCtrl.text.toString(),
                    ),
                  );
                  result.fold(
                    // On Error
                    (error) {
                      var snackBar = SnackBar(
                        content: Text(error),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    // on Successful
                    (data) {
                      var snackBar = SnackBar(
                        content: Text('Sign Up was Successful'),
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      AppNavigator.pushAndRemove(context, HomePage());
                    },
                  );
                },
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RowButton(
        onPressed: () {
          AppNavigator.pushReplacement(context, SignInPage());
        },
        infoText: 'Already have an account?',
        buttonTitle: 'Sign In',
      ),
    );
  }

  Widget _registerText() {
    return Text(
      'Register',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    );
  }
}
