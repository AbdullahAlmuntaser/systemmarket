import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:supermarket/core/config/app_permissions.dart';
import 'package:supermarket/core/auth/auth_provider.dart';
import 'package:bcrypt/bcrypt.dart' as bcrypt_pkg;

/// صفحة إدارة الصلاحيات والأدوار المحسنة
class PermissionsManagementPage extends StatefulWidget {
  const PermissionsManagementPage({super.key});

  @override
  State<PermissionsManagementPage> createState() =>
      _PermissionsManagementPageState();
}

class _PermissionsManagementPageState extends State<PermissionsManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedRole = 'admin';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Initialize default permissions if needed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final db = context.read<AppDatabase>();
      final permsService = context.read<PermissionsService>();
      await permsService.initializeDefaults();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الصلاحيات'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.shield), text: 'الأدوار'),
            Tab(icon: Icon(Icons.key), text: 'الصلاحيات'),
            Tab(icon: Icon(Icons.assignment_ind), text: 'تعيين الصلاحيات'),
            Tab(icon: Icon(Icons.people), text: 'المستخدمين'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await context.read<PermissionsService>().initializeDefaults();
              if (mounted) setState(() {});
            },
            tooltip: 'إعادة تهيئة الصلاحيات الافتراضية',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRolesTab(db),
          _buildPermissionsTab(db),
          _buildRolePermissionsTab(db),
          _buildUsersTab(db, authProvider),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddUserDialog(context, db),
        icon: const Icon(Icons.person_add),
        label: const Text('مستخدم جديد'),
      ),
    );
  }

  // ====== تبويب الأدوار ======
  Widget _buildRolesTab(AppDatabase db) {
    return FutureBuilder<List<User>>(
      future: db.select(db.users).get(),
      builder: (context, snapshot) {
        final users = snapshot.data ?? [];
        final roles = users.map((u) => u.role).toSet().toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الأدوار الموجودة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddRoleDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة دور'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (roles.isEmpty)
                const Center(child: Text('لا توجد أدوار'))
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: roles.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      final userCount = users
                          .where((u) => u.role == role)
                          .length;
                      return ListTile(
                        leading: const Icon(Icons.shield, size: 32),
                        title: Text(role),
                        trailing: Text('$userCount مستخدم'),
                        onTap: () {
                          setState(() => _selectedRole = role);
                          _tabController.animateTo(2);
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الأدوار الافتراضية:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: AppPermissions.defaultRoles.keys.map((role) {
                          return Chip(
                            label: Text(role),
                            avatar: const Icon(Icons.star, size: 16),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ====== تبويب الصلاحيات ======
  Widget _buildPermissionsTab(AppDatabase db) {
    return StreamBuilder<List<Permission>>(
      stream: db.select(db.permissions).watch(),
      builder: (context, snapshot) {
        final permissions = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الصلاحيات المتاحة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPermissionDialog(context, db),
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة صلاحية'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: permissions.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد صلاحيات. اضغط على "إعادة تهيئة" لإضافة الصلاحيات الافتراضية.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: permissions.length,
                        itemBuilder: (context, index) {
                          final p = permissions[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    p.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p.description ?? '',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ====== تبويب تعيين الصلاحيات للأدوار ======
  Widget _buildRolePermissionsTab(AppDatabase db) {
    return FutureBuilder<List<RolePermission>>(
      future: db.select(db.rolePermissions).get(),
      builder: (context, snapshot) {
        final rolePermissions = snapshot.data ?? [];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'اختر الدور',
                  border: OutlineInputBorder(),
                ),
                items: rolePermissions
                        .map((rp) => rp.role)
                        .toSet()
                        .toList()
                        .isNotEmpty
                    ? rolePermissions
                          .map((rp) => rp.role)
                          .toSet()
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ),
                          )
                          .toList()
                    : AppPermissions.defaultRoles.keys
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ),
                          )
                          .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRole = val);
                },
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: AppPermissions.allPermissions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final perm = AppPermissions.allPermissions[index];
                  final permCode = perm['code']!;
                  final hasPermission = rolePermissions.any(
                    (rp) =>
                        rp.role == _selectedRole &&
                        rp.permissionCode == permCode,
                  );

                  return SwitchListTile(
                    title: Text(permCode),
                    subtitle: Text(perm['description'] ?? ''),
                    value: hasPermission,
                    onChanged: (val) async {
                      if (val) {
                        await db
                            .into(db.rolePermissions)
                            .insert(
                              RolePermissionsCompanion.insert(
                                id: drift.Value(const Uuid().v4()),
                                role: _selectedRole,
                                permissionCode: permCode,
                                syncStatus: const drift.Value(1),
                              ),
                            );
                      } else {
                        await (db.delete(db.rolePermissions)..where(
                              (rp) =>
                                  rp.role.equals(_selectedRole) &
                                  rp.permissionCode.equals(permCode),
                            ))
                            .go();
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ====== تبويب المستخدمين ======
  Widget _buildUsersTab(AppDatabase db, AuthProvider authProvider) {
    return StreamBuilder<List<User>>(
      stream: db.select(db.users).watch(),
      builder: (context, snapshot) {
        final users = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'المستخدمون',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'الدور الحالي: ${authProvider.currentRole ?? "غير محدد"}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.fullName[0].toUpperCase()),
                      ),
                      title: Text(user.fullName),
                      subtitle: Text(user.username),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            label: Text(user.role),
                            backgroundColor: user.role == 'admin'
                                ? Colors.red[100]
                                : Colors.blue[100],
                          ),
                          const SizedBox(width: 8),
                          if (user.id != authProvider.currentUser?.id)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _showEditUserDialog(context, db, user),
                            ),
                          if (user.id != authProvider.currentUser?.id)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _confirmDeleteUser(context, db, user),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ====== Dialogs ======
  void _showAddRoleDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة دور جديد'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'اسم الدور',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم إنشاء الدور: ${controller.text}\nانتقل إلى تبويب "تعيين الصلاحيات" لتكوينه',
                    ),
                  ),
                );
                setState(() {});
              }
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showAddPermissionDialog(BuildContext context, AppDatabase db) {
    final codeController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة صلاحية جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'رمز الصلاحية (مثال: pos.access)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (codeController.text.isNotEmpty) {
                await db
                    .into(db.permissions)
                    .insert(
                      PermissionsCompanion.insert(
                        id: drift.Value(const Uuid().v4()),
                        code: codeController.text,
                        description: drift.Value(descController.text),
                        syncStatus: const drift.Value(1),
                      ),
                    );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, AppDatabase db) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final fullNameController = TextEditingController();
    String selectedRole = 'cashier';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة مستخدم جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'الدور',
                    border: OutlineInputBorder(),
                  ),
                  items: AppPermissions.defaultRoles.keys
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedRole = val);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (usernameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  final hashedPassword = bcrypt_pkg.BCrypt.hashpw(
                    passwordController.text,
                    bcrypt_pkg.BCrypt.gensalt(),
                  );
                  await db.into(db.users).insert(
                    UsersCompanion.insert(
                      id: drift.Value(const Uuid().v4()),
                      username: usernameController.text,
                      password: hashedPassword,
                      fullName: fullNameController.text,
                      role: selectedRole,
                      syncStatus: const drift.Value(1),
                    ),
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('إنشاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(
    BuildContext context,
    AppDatabase db,
    User user,
  ) {
    final fullNameController = TextEditingController(text: user.fullName);
    final passwordController = TextEditingController();
    String selectedRole = user.role;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('تعديل المستخدم'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور الجديدة (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'الدور',
                    border: OutlineInputBorder(),
                  ),
                  items: AppPermissions.defaultRoles.keys
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedRole = val);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                String? newPassword;
                if (passwordController.text.isNotEmpty) {
                  newPassword = bcrypt_pkg.BCrypt.hashpw(
                    passwordController.text,
                    bcrypt_pkg.BCrypt.gensalt(),
                  );
                }
                await db.update(db.users).write(
                  user.copyWith(
                    fullName: fullNameController.text,
                    role: selectedRole,
                    password: newPassword ?? user.password,
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteUser(
    BuildContext context,
    AppDatabase db,
    User user,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف المستخدم "${user.fullName}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await db.delete(db.users).delete(user);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
