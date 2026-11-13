class UserModel {
  final int? id;
  final String? email;
  final String? phone;
  final String? displayName;
  final String? bio;
  final String? description;
  final String? referralCode;
  final int? stateId;
  final String? profilePhoto;
  final bool? isActive;
  final bool? isVerified;
  final String? gender;
  final String? role;

  UserModel({
    this.id,
    this.email,
    this.phone,
    this.displayName,
    this.bio,
    this.description,
    this.referralCode,
    this.stateId,
    this.profilePhoto,
    this.isActive,
    this.isVerified,
    this.gender,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      displayName: json['display_name']?.toString(),
      bio: json['bio']?.toString(),
      description: json['description']?.toString(),
      referralCode: json['referral_code']?.toString(),
      stateId: json['state_id'] is int
          ? json['state_id'] as int
          : int.tryParse(json['state_id']?.toString() ?? ''),
      profilePhoto: json['profile_photo']?.toString(),
      isActive: json['is_active'] is bool
          ? json['is_active'] as bool
          : (json['is_active']?.toString().toLowerCase() == 'true'),
      isVerified: json['is_verified'] is bool
          ? json['is_verified'] as bool
          : (json['is_verified']?.toString().toLowerCase() == 'true'),
      gender: json['gender']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'display_name': displayName,
      'bio': bio,
      'description': description,
      'referral_code': referralCode,
      'state_id': stateId,
      'profile_photo': profilePhoto,
      'is_active': isActive,
      'is_verified': isVerified,
      'gender': gender,
      'role': role,
    };
  }
}
