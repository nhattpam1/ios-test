class SessionManager {
  static SessionManager? _instance;
  factory SessionManager() => _instance ??= SessionManager._();
  SessionManager._();

  int? userId;

  void setUserId(int id) {
    userId = id;
  }
}
