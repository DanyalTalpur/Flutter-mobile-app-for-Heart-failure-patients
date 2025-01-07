class UserData {
  static final Map<String, Map<String, String>> _userData = {};

  static void addUser(String email, String password, String name, String phone, String age, String medicalRecordNumber, String role) {
    _userData[email] = {
      'password': password,
      'name': name,
      'phone': phone,
      'email': email,
      'age': age,
      'medicalRecordNumber': medicalRecordNumber,
      'role': role,
    };
  }

  static Map<String, String>? getUserData(String email) {
    return _userData[email];
  }

  static Map<String, String>? getUserDataByMedicalRecordNumber(String medicalRecordNumber) {
    return _userData.values.firstWhere(
          (user) => user['medicalRecordNumber'] == medicalRecordNumber,
      orElse: () => {}, // Return an empty map instead of null
    );
  }

  static bool validateUser(String email, String password) {
    final user = _userData[email];
    if (user != null && user['password'] == password) {
      return true;
    }
    return false;
  }

  static String getRole(String email) {
    final user = _userData[email];
    if (user != null) {
      return user['role']!;
    }
    throw Exception('User not found');
  }
}
