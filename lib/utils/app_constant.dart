import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client
final supabase = Supabase.instance.client;

class AssetImages {
  static const logo = 'assets/images/logo.png';
}

class Sizes {
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p32 = 32.0;
  static const p48 = 48.0;
  static const p64 = 64.0;
  static const p100 = 100.0;
  static const p120 = 120.0;
}

class AppConstant {
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String expireIn = 'expire_in';
  static const String lastTokenTime = 'lastTokenTime';
  static const String isLogin = 'isLogin';
}

class AppLabels {
  static const password = 'Password';
  static const username = 'Username';
  static const email = 'Email(test@test.com)';
  static const login = 'Login';
  static const signUp = "Register";
  static const emptyEmail = "Email can't be empty";
  static const emptyPassword = "Password can't be empty";

  static const startConversation = 'Start your conversation now :)';
}
