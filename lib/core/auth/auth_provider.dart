import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import '../../data/datasources/local/app_database.dart';
import '../services/role_permissions_service.dart';

class AuthProvider with ChangeNotifier {
  final AppDatabase db;
  final PermissionsService permissionsService;
  User? _currentUser;

  AuthProvider(this.db, this.permissionsService);

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';
  String? get currentRole => permissionsService.currentRole;

  Future<bool> login(String username, String password) async {
    final user = await (db.select(
      db.users,
    )..where((u) => u.username.equals(username))).getSingleOrNull();

    if (user != null && BCrypt.checkpw(password, user.password)) {
      _currentUser = user;
      await permissionsService.init(user.role);
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    permissionsService.init(null);
    notifyListeners();
  }

  // Initial seed user and default permissions
  Future<void> seedAdmin() async {
    final count = await db.select(db.users).get();
    if (count.isEmpty) {
      final hashedPassword = BCrypt.hashpw('123', BCrypt.gensalt());
      await db
          .into(db.users)
          .insert(
            UsersCompanion.insert(
              username: 'admin',
              password: hashedPassword,
              role: 'admin',
              fullName: 'System Admin',
            ),
          );
      
      // Initialize default roles and permissions
      await permissionsService.initializeDefaults();
    }
  }

  /// Check if current user has permission
  bool can(String permission) {
    return permissionsService.can(permission);
  }

  /// Check and log permission
  Future<bool> checkAndLogPermission(String permission) async {
    final granted = permissionsService.can(permission);
    if (!granted && _currentUser != null) {
      await permissionsService.logPermissionCheck(
        _currentUser!.id,
        permission,
        granted,
      );
    }
    return granted;
  }
}
