class HiveConstant {
  HiveConstant._();
  // BOX
  static const String generalBox = "general-box";
  static const String authBox = "auth-box";
  static const String listCrudDataModel = "list-crud-model";
  static const String bearerToken = "bearer-token";

  // AUTH KEYS
  /// Remember me preference key
  static const String rememberMeKey = 'remember_me_enabled';

  /// Last login timestamp key (ISO 8601 format)
  static const String lastLoginKey = 'last_login_timestamp';

  /// Failed login attempts count key
  static const String failedAttemptsKey = 'failed_attempts';

  /// Account lockout timestamp key (ISO 8601 format)
  static const String lockoutUntilKey = 'lockout_until';
}
