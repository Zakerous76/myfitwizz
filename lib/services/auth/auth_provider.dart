import 'package:myfitwizz/services/auth/auth_user.dart';


abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }); // if you cant return an AuthUser, throw an exception.
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> updateDisplayName(String displayName);
}
