/// Model for user data from Supabase Auth
///
/// Contains essential user information including:
/// - Basic info (id, email, name)
/// - Avatar/profile picture
/// - Authentication metadata
/// - Account timestamps
class UserDataModel {
  /// Unique user ID
  final String id;

  /// User email address
  final String email;

  /// Full name of the user
  final String? fullName;

  /// Avatar URL (profile picture)
  final String? avatarUrl;

  /// Phone number (optional)
  final String? phone;

  /// Whether email is verified
  final bool emailVerified;

  /// Whether phone is verified
  final bool phoneVerified;

  /// Authentication provider (google, email, etc.)
  final String? provider;

  /// List of all providers user has used
  final List<String> providers;

  /// Account creation timestamp
  final DateTime? createdAt;

  /// Last sign in timestamp
  final DateTime? lastSignInAt;

  /// Account last update timestamp
  final DateTime? updatedAt;

  const UserDataModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.provider,
    this.providers = const [],
    this.createdAt,
    this.lastSignInAt,
    this.updatedAt,
  });

  /// Create UserDataModel from Supabase User object
  factory UserDataModel.fromSupabaseUser(dynamic user) {
    final userMetaData = user.userMetadata ?? {};
    final appMetaData = user.appMetadata ?? {};

    return UserDataModel(
      id: user.id,
      email: user.email ?? '',
      fullName: userMetaData['full_name'] as String? ?? userMetaData['name'] as String?,
      avatarUrl: userMetaData['avatar_url'] as String? ?? userMetaData['picture'] as String?,
      phone: user.phone,
      emailVerified: userMetaData['email_verified'] as bool? ?? false,
      phoneVerified: userMetaData['phone_verified'] as bool? ?? false,
      provider: appMetaData['provider'] as String?,
      providers: (appMetaData['providers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: user.createdAt != null ? DateTime.parse(user.createdAt) : null,
      lastSignInAt: user.lastSignInAt != null ? DateTime.parse(user.lastSignInAt) : null,
      updatedAt: user.updatedAt != null ? DateTime.parse(user.updatedAt) : null,
    );
  }

  /// Create UserDataModel from JSON
  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    final userMetaData = json['raw_user_meta_data'] as Map<String, dynamic>? ?? {};
    final appMetaData = json['raw_app_meta_data'] as Map<String, dynamic>? ?? {};

    return UserDataModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: userMetaData['full_name'] as String? ?? userMetaData['name'] as String?,
      avatarUrl: userMetaData['avatar_url'] as String? ?? userMetaData['picture'] as String?,
      phone: json['phone'] as String?,
      emailVerified: userMetaData['email_verified'] as bool? ?? false,
      phoneVerified: userMetaData['phone_verified'] as bool? ?? false,
      provider: appMetaData['provider'] as String?,
      providers: (appMetaData['providers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'provider': provider,
      'providers': providers,
      'created_at': createdAt?.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get display name (full name or email)
  String get displayName => fullName ?? email.split('@').first;

  /// Get initials from name (for avatar placeholder)
  String get initials {
    if (fullName == null || fullName!.isEmpty) {
      return email.substring(0, 1).toUpperCase();
    }

    final nameParts = fullName!.split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    }

    return '${nameParts[0].substring(0, 1)}${nameParts[1].substring(0, 1)}'.toUpperCase();
  }

  /// Check if user signed in with Google
  bool get isGoogleUser => providers.contains('google');

  /// Check if user signed in with email
  bool get isEmailUser => providers.contains('email');

  /// Copy with method for updating fields
  UserDataModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? phone,
    bool? emailVerified,
    bool? phoneVerified,
    String? provider,
    List<String>? providers,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    DateTime? updatedAt,
  }) {
    return UserDataModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      provider: provider ?? this.provider,
      providers: providers ?? this.providers,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserDataModel(id: $id, email: $email, fullName: $fullName, avatarUrl: $avatarUrl)';
  }
}
