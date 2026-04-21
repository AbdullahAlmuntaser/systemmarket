import 'package:equatable/equatable.dart';

enum UserRole {
  admin,
  manager,
  accountant,
  cashier,
  warehouseKeeper,
  salesPerson,
}

enum Permission {
  // Sales Permissions
  createSale,
  viewSale,
  editSale,
  deleteSale,
  voidSale,
  
  // Purchase Permissions
  createPurchase,
  viewPurchase,
  editPurchase,
  deletePurchase,
  
  // Inventory Permissions
  viewInventory,
  adjustInventory,
  performStockTake,
  manageProducts,
  
  // Accounting Permissions
  createJournalEntry,
  viewJournalEntry,
  approveJournalEntry,
  viewReports,
  manageAccounts,
  reconcileAccounts,
  
  // Returns Permissions
  createReturn,
  approveReturn,
  viewReturn,
  
  // Manufacturing Permissions
  createProductionOrder,
  viewProductionOrder,
  approveProductionOrder,
  
  // User Management Permissions
  createUser,
  viewUser,
  editUser,
  deleteUser,
  assignRole,
  
  // Settings Permissions
  manageSettings,
  backupData,
  restoreData,
}

class Role extends Equatable {
  final String id;
  final String name;
  final UserRole roleType;
  final Set<Permission> permissions;
  final bool isSystemRole;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Role({
    required this.id,
    required this.name,
    required this.roleType,
    required this.permissions,
    this.isSystemRole = false,
    required this.createdAt,
    this.updatedAt,
  });

  Role copyWith({
    String? id,
    String? name,
    UserRole? roleType,
    Set<Permission>? permissions,
    bool? isSystemRole,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      roleType: roleType ?? this.roleType,
      permissions: permissions ?? this.permissions,
      isSystemRole: isSystemRole ?? this.isSystemRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, roleType, permissions, isSystemRole];
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'مدير النظام';
      case UserRole.manager:
        return 'مدير';
      case UserRole.accountant:
        return 'محاسب';
      case UserRole.cashier:
        return 'كاشير';
      case UserRole.warehouseKeeper:
        return 'أمين مخزن';
      case UserRole.salesPerson:
        return 'مندوب مبيعات';
    }
  }
}

extension PermissionExtension on Permission {
  String get displayName {
    switch (this) {
      case Permission.createSale:
        return 'إنشاء فاتورة مبيعات';
      case Permission.viewSale:
        return 'عرض فواتير المبيعات';
      case Permission.editSale:
        return 'تعديل فاتورة مبيعات';
      case Permission.deleteSale:
        return 'حذف فاتورة مبيعات';
      case Permission.voidSale:
        return 'إلغاء فاتورة مبيعات';
      case Permission.createPurchase:
        return 'إنشاء فاتورة مشتريات';
      case Permission.viewPurchase:
        return 'عرض فواتير المشتريات';
      case Permission.editPurchase:
        return 'تعديل فاتورة مشتريات';
      case Permission.deletePurchase:
        return 'حذف فاتورة مشتريات';
      case Permission.viewInventory:
        return 'عرض المخزون';
      case Permission.adjustInventory:
        return 'تعديل المخزون';
      case Permission.performStockTake:
        return 'جرد المخزون';
      case Permission.manageProducts:
        return 'إدارة المنتجات';
      case Permission.createJournalEntry:
        return 'إنشاء قيد يدوي';
      case Permission.viewJournalEntry:
        return 'عرض القيود';
      case Permission.approveJournalEntry:
        return 'اعتماد القيود';
      case Permission.viewReports:
        return 'عرض التقارير';
      case Permission.manageAccounts:
        return 'إدارة الحسابات';
      case Permission.reconcileAccounts:
        return 'تسوية الحسابات';
      case Permission.createReturn:
        return 'إنشاء مرتجع';
      case Permission.approveReturn:
        return 'اعتماد المرتجعات';
      case Permission.viewReturn:
        return 'عرض المرتجعات';
      case Permission.createProductionOrder:
        return 'إنشاء أمر تصنيع';
      case Permission.viewProductionOrder:
        return 'عرض أوامر التصنيع';
      case Permission.approveProductionOrder:
        return 'اعتماد أوامر التصنيع';
      case Permission.createUser:
        return 'إنشاء مستخدم';
      case Permission.viewUser:
        return 'عرض المستخدمين';
      case Permission.editUser:
        return 'تعديل مستخدم';
      case Permission.deleteUser:
        return 'حذف مستخدم';
      case Permission.assignRole:
        return 'تعيين الصلاحيات';
      case Permission.manageSettings:
        return 'إعدادات النظام';
      case Permission.backupData:
        return 'نسخ احتياطي';
      case Permission.restoreData:
        return 'استعادة بيانات';
    }
  }
}
