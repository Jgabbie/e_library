// lib/data/mock_db.dart
class MockDatabase {
  // Our "Database" of users. I added an admin user for testing.
  static List<Map<String, String>> users = [
    {
      "username": "admin",
      "email": "admin@test.com",
      "password": "123"
    }
  ];

  // Stores the currently logged-in user
  static Map<String, String>? activeUser; 
}