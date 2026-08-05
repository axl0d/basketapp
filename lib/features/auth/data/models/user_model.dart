import 'package:basketapp/features/auth/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.emailVerified,
    super.displayName,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      emailVerified: firebaseUser.emailVerified,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'emailVerified': emailVerified,
    };
  }
}
