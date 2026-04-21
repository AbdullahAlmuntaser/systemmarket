import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/injection_container.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../config/app_permissions.dart';

class PermissionsService {
  final AppDatabase db;
  List<String> _permissions = [];
  String? _currentRole;

  PermissionsService(this.db);

  /// Initializes permissions for the given role.
  Future<void> init(String? role) async {
    _currentRole = role;
    if (role == null) {
      _permissions = [];
      return;
    }
    if (role.toLowerCase() == 'admin') {
      _permissions = ['*']; // Super admin has all permissions
      return;
    }

    final results = await (db.select(db.rolePermissions)
          ..where((rp) => rp.role.equals(role)))
        .get();
    _permissions = results.map((rp) => rp.permissionCode).toList();
  }

  /// Checks if the current role has the specified permission.
  bool can(String action) {
    if (_permissions.contains('*')) return true;
    return _permissions.contains(action);
  }

  /// Static shortcut for easy access in UI
  static bool hasPermission(String action) {
    return sl<PermissionsService>().can(action);
  }

  /// Get current role
  String? get currentRole => _currentRole;

  /// Initialize default roles and permissions on first run
  Future<void> initializeDefaults() async {
    // Check if permissions already exist
    final existingPerms = await db.select(db.permissions).get();
    if (existingPerms.isNotEmpty) {
      return; // Already initialized
    }

    // Insert all predefined permissions
    for (var perm in AppPermissions.allPermissions) {
      await db.into(db.permissions).insertOnConflictUpdate(
        PermissionsCompanion.insert(
          id: drift.Value(const Uuid().v4()),
          code: perm['code']!,
          description: drift.Value(perm['description']),
          syncStatus: const drift.Value(1),
        ),
      );
    }

    // Assign permissions to default roles
    for (var entry in AppPermissions.defaultRoles.entries) {
      final role = entry.key;
      final perms = entry.value;

      for (var permCode in perms) {
        // Check if already assigned
        final exists = await (db.select(db.rolePermissions)
              ..where((rp) => rp.role.equals(role) & rp.permissionCode.equals(permCode)))
            .getSingleOrNull();
        
        if (exists == null) {
          await db.into(db.rolePermissions).insert(
            RolePermissionsCompanion.insert(
              id: drift.Value(const Uuid().v4()),
              role: role,
              permissionCode: permCode,
              syncStatus: const drift.Value(1),
            ),
          );
        }
      }
    }
  }

  /// Log permission check for audit trail
  Future<void> logPermissionCheck(String userId, String action, bool granted) async {
    if (!granted) {
      // Only log denied attempts for security audit
      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          id: drift.Value(const Uuid().v4()),
          userId: drift.Value(userId),
          action: 'PERMISSION_DENIED',
          targetEntity: 'SYSTEM',
          entityId: 'N/A',
          details: drift.Value('User $userId attempted action: $action'),
          timestamp: drift.Value(DateTime.now()),
        ),
      );
    }
  }
}
