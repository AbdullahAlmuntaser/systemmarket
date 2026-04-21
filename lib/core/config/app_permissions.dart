/// تعريف شامل لجميع صلاحيات النظام
/// يتم استخدام هذه الصلاحيات للتحكم في الوصول إلى الميزات والعمليات
class AppPermissions {
  // ===== صلاحيات نقطة البيع (POS) =====
  static const String posAccess = 'pos.access';
  static const String posCreateSale = 'pos.sale.create';
  static const String posHoldSale = 'pos.sale.hold';
  static const String posVoidSale = 'pos.sale.void';
  static const String posApplyDiscount = 'pos.discount.apply';
  static const String posOverridePrice = 'pos.price.override';
  static const String posOpenCashDrawer = 'pos.cashdrawer.open';
  static const String posCloseShift = 'pos.shift.close';
  static const String posViewShiftReport = 'pos.shift.report.view';

  // ===== صلاحيات المبيعات =====
  static const String salesView = 'sales.view';
  static const String salesCreate = 'sales.create';
  static const String salesEdit = 'sales.edit';
  static const String salesDelete = 'sales.delete';
  static const String salesVoid = 'sales.void';
  static const String salesReturn = 'sales.return';
  static const String salesViewReports = 'sales.reports.view';
  static const String salesExport = 'sales.export';

  // ===== صلاحيات المشتريات =====
  static const String purchasesView = 'purchases.view';
  static const String purchasesCreate = 'purchases.create';
  static const String purchasesEdit = 'purchases.edit';
  static const String purchasesDelete = 'purchases.delete';
  static const String purchasesReturn = 'purchases.return';
  static const String purchasesApprove = 'purchases.approve';
  static const String purchasesViewReports = 'purchases.reports.view';

  // ===== صلاحيات المنتجات =====
  static const String productsView = 'products.view';
  static const String productsCreate = 'products.create';
  static const String productsEdit = 'products.edit';
  static const String productsDelete = 'products.delete';
  static const String productsManageCategories = 'products.categories.manage';
  static const String productsManageUnits = 'products.units.manage';
  static const String productsManageBatches = 'products.batches.manage';
  static const String productsPrintBarcodes = 'products.barcodes.print';

  // ===== صلاحيات المخزون =====
  static const String inventoryView = 'inventory.view';
  static const String inventoryAdjust = 'inventory.adjust';
  static const String inventoryTransfer = 'inventory.transfer';
  static const String inventoryCount = 'inventory.count';
  static const String inventoryViewReports = 'inventory.reports.view';
  static const String inventoryManageWarehouses = 'inventory.warehouses.manage';

  // ===== صلاحيات العملاء =====
  static const String customersView = 'customers.view';
  static const String customersCreate = 'customers.create';
  static const String customersEdit = 'customers.edit';
  static const String customersDelete = 'customers.delete';
  static const String customersManageCredit = 'customers.credit.manage';
  static const String customersViewStatements = 'customers.statements.view';
  static const String customersReceivePayments = 'customers.payments.receive';

  // ===== صلاحيات الموردين =====
  static const String suppliersView = 'suppliers.view';
  static const String suppliersCreate = 'suppliers.create';
  static const String suppliersEdit = 'suppliers.edit';
  static const String suppliersDelete = 'suppliers.delete';
  static const String suppliersManageCredit = 'suppliers.credit.manage';
  static const String suppliersMakePayments = 'suppliers.payments.make';

  // ===== صلاحيات المحاسبة =====
  static const String accountingView = 'accounting.view';
  static const String accountingManage = 'accounting.manage';
  static const String accountingCreateEntries = 'accounting.entries.create';
  static const String accountingEditEntries = 'accounting.entries.edit';
  static const String accountingDeleteEntries = 'accounting.entries.delete';
  static const String accountingPostEntries = 'accounting.entries.post';
  static const String accountingManageAccounts = 'accounting.accounts.manage';
  static const String accountingManagePeriods = 'accounting.periods.manage';
  static const String accountingClosePeriod = 'accounting.periods.close';
  static const String accountingViewReports = 'accounting.reports.view';
  static const String accountingManageAssets = 'accounting.assets.manage';
  static const String accountingDepreciation = 'accounting.depreciation.run';

  // ===== صلاحيات التقارير =====
  static const String reportsView = 'reports.view';
  static const String reportsSales = 'reports.sales.view';
  static const String reportsPurchases = 'reports.purchases.view';
  static const String reportsInventory = 'reports.inventory.view';
  static const String reportsAccounting = 'reports.accounting.view';
  static const String reportsCustomers = 'reports.customers.view';
  static const String reportsSuppliers = 'reports.suppliers.view';
  static const String reportsExport = 'reports.export';
  static const String reportsPrint = 'reports.print';

  // ===== صلاحيات الموارد البشرية =====
  static const String hrView = 'hr.view';
  static const String hrManageEmployees = 'hr.employees.manage';
  static const String hrManageAttendance = 'hr.attendance.manage';
  static const String hrManagePayroll = 'hr.payroll.manage';
  static const String hrProcessSalaries = 'hr.salaries.process';
  static const String hrViewReports = 'hr.reports.view';

  // ===== صلاحيات التصنيع =====
  static const String manufacturingView = 'manufacturing.view';
  static const String manufacturingCreateOrder = 'manufacturing.order.create';
  static const String manufacturingEditOrder = 'manufacturing.order.edit';
  static const String manufacturingDeleteOrder = 'manufacturing.order.delete';
  static const String manufacturingManageBOM = 'manufacturing.bom.manage';
  static const String manufacturingViewReports = 'manufacturing.reports.view';

  // ===== صلاحيات الإعدادات =====
  static const String settingsView = 'settings.view';
  static const String settingsManage = 'settings.manage';
  static const String settingsManageUsers = 'settings.users.manage';
  static const String settingsManageRoles = 'settings.roles.manage';
  static const String settingsManagePermissions = 'settings.permissions.manage';
  static const String settingsBackup = 'settings.backup.manage';
  static const String settingsRestore = 'settings.restore';
  static const String settingsSystemConfig = 'settings.system.config';

  // قائمة بجميع الصلاحيات
  static const List<Map<String, String>> allPermissions = [
    {'code': posAccess, 'description': 'الوصول إلى نقطة البيع'},
    {'code': posCreateSale, 'description': 'إنشاء عملية بيع في POS'},
    {'code': posHoldSale, 'description': 'تعليق عملية بيع'},
    {'code': posVoidSale, 'description': 'إلغاء عملية بيع'},
    {'code': posApplyDiscount, 'description': 'تطبيق خصم'},
    {'code': posOverridePrice, 'description': 'تجاوز السعر'},
    {'code': posOpenCashDrawer, 'description': 'فتح درج النقد'},
    {'code': posCloseShift, 'description': 'إغلاق الوردية'},
    {'code': posViewShiftReport, 'description': 'عرض تقرير الوردية'},
    {'code': salesView, 'description': 'عرض المبيعات'},
    {'code': salesCreate, 'description': 'إنشاء مبيعات'},
    {'code': salesEdit, 'description': 'تعديل المبيعات'},
    {'code': salesDelete, 'description': 'حذف المبيعات'},
    {'code': salesVoid, 'description': 'إلغاء المبيعات'},
    {'code': salesReturn, 'description': 'مرتجعات المبيعات'},
    {'code': salesViewReports, 'description': 'عرض تقارير المبيعات'},
    {'code': salesExport, 'description': 'تصدير المبيعات'},
    {'code': purchasesView, 'description': 'عرض المشتريات'},
    {'code': purchasesCreate, 'description': 'إنشاء مشتريات'},
    {'code': purchasesEdit, 'description': 'تعديل المشتريات'},
    {'code': purchasesDelete, 'description': 'حذف المشتريات'},
    {'code': purchasesReturn, 'description': 'مرتجعات المشتريات'},
    {'code': purchasesApprove, 'description': 'اعتماد المشتريات'},
    {'code': purchasesViewReports, 'description': 'عرض تقارير المشتريات'},
    {'code': productsView, 'description': 'عرض المنتجات'},
    {'code': productsCreate, 'description': 'إنشاء منتجات'},
    {'code': productsEdit, 'description': 'تعديل المنتجات'},
    {'code': productsDelete, 'description': 'حذف المنتجات'},
    {'code': productsManageCategories, 'description': 'إدارة تصنيفات المنتجات'},
    {'code': productsManageUnits, 'description': 'إدارة وحدات المنتجات'},
    {'code': productsManageBatches, 'description': 'إدارة الدفعات'},
    {'code': productsPrintBarcodes, 'description': 'طباعة الباركود'},
    {'code': inventoryView, 'description': 'عرض المخزون'},
    {'code': inventoryAdjust, 'description': 'تعديل المخزون'},
    {'code': inventoryTransfer, 'description': 'نقل المخزون'},
    {'code': inventoryCount, 'description': 'جرد المخزون'},
    {'code': inventoryViewReports, 'description': 'عرض تقارير المخزون'},
    {'code': inventoryManageWarehouses, 'description': 'إدارة المستودعات'},
    {'code': customersView, 'description': 'عرض العملاء'},
    {'code': customersCreate, 'description': 'إنشاء عملاء'},
    {'code': customersEdit, 'description': 'تعديل العملاء'},
    {'code': customersDelete, 'description': 'حذف العملاء'},
    {'code': customersManageCredit, 'description': 'إدارة ائتمان العملاء'},
    {'code': customersViewStatements, 'description': 'عرض كشوف العملاء'},
    {'code': customersReceivePayments, 'description': 'استلام مدفوعات العملاء'},
    {'code': suppliersView, 'description': 'عرض الموردين'},
    {'code': suppliersCreate, 'description': 'إنشاء موردين'},
    {'code': suppliersEdit, 'description': 'تعديل الموردين'},
    {'code': suppliersDelete, 'description': 'حذف الموردين'},
    {'code': suppliersManageCredit, 'description': 'إدارة ائتمان الموردين'},
    {'code': suppliersMakePayments, 'description': 'دفع للموردين'},
    {'code': accountingView, 'description': 'عرض المحاسبة'},
    {'code': accountingManage, 'description': 'إدارة المحاسبة'},
    {'code': accountingCreateEntries, 'description': 'إنشاء قيود محاسبية'},
    {'code': accountingEditEntries, 'description': 'تعديل القيود المحاسبية'},
    {'code': accountingDeleteEntries, 'description': 'حذف القيود المحاسبية'},
    {'code': accountingPostEntries, 'description': 'ترحيل القيود المحاسبية'},
    {'code': accountingManageAccounts, 'description': 'إدارة الحسابات'},
    {'code': accountingManagePeriods, 'description': 'إدارة الفترات المحاسبية'},
    {'code': accountingClosePeriod, 'description': 'إغلاق الفترة المحاسبية'},
    {'code': accountingViewReports, 'description': 'عرض التقارير المحاسبية'},
    {'code': accountingManageAssets, 'description': 'إدارة الأصول الثابتة'},
    {'code': accountingDepreciation, 'description': 'تشغيل الإهلاك'},
    {'code': reportsView, 'description': 'عرض التقارير'},
    {'code': reportsSales, 'description': 'تقارير المبيعات'},
    {'code': reportsPurchases, 'description': 'تقارير المشتريات'},
    {'code': reportsInventory, 'description': 'تقارير المخزون'},
    {'code': reportsAccounting, 'description': 'التقارير المحاسبية'},
    {'code': reportsCustomers, 'description': 'تقارير العملاء'},
    {'code': reportsSuppliers, 'description': 'تقارير الموردين'},
    {'code': reportsExport, 'description': 'تصدير التقارير'},
    {'code': reportsPrint, 'description': 'طباعة التقارير'},
    {'code': hrView, 'description': 'عرض الموارد البشرية'},
    {'code': hrManageEmployees, 'description': 'إدارة الموظفين'},
    {'code': hrManageAttendance, 'description': 'إدارة الحضور'},
    {'code': hrManagePayroll, 'description': 'إدارة الرواتب'},
    {'code': hrProcessSalaries, 'description': 'معالجة الرواتب'},
    {'code': hrViewReports, 'description': 'تقارير الموارد البشرية'},
    {'code': manufacturingView, 'description': 'عرض التصنيع'},
    {'code': manufacturingCreateOrder, 'description': 'إنشاء أمر تصنيع'},
    {'code': manufacturingEditOrder, 'description': 'تعديل أمر تصنيع'},
    {'code': manufacturingDeleteOrder, 'description': 'حذف أمر تصنيع'},
    {'code': manufacturingManageBOM, 'description': 'إدارة قائمة المواد'},
    {'code': manufacturingViewReports, 'description': 'تقارير التصنيع'},
    {'code': settingsView, 'description': 'عرض الإعدادات'},
    {'code': settingsManage, 'description': 'إدارة الإعدادات'},
    {'code': settingsManageUsers, 'description': 'إدارة المستخدمين'},
    {'code': settingsManageRoles, 'description': 'إدارة الأدوار'},
    {'code': settingsManagePermissions, 'description': 'إدارة الصلاحيات'},
    {'code': settingsBackup, 'description': 'النسخ الاحتياطي'},
    {'code': settingsRestore, 'description': 'الاستعادة'},
    {'code': settingsSystemConfig, 'description': 'تكوين النظام'},
  ];

  // أدوار افتراضية مع صلاحياتها
  static const Map<String, List<String>> defaultRoles = {
    'admin': [
      // مدير النظام لديه جميع الصلاحيات
      '*',
    ],
    'manager': [
      // المدير: وصول كامل تقريباً
      posAccess, posCreateSale, posHoldSale, posVoidSale, posApplyDiscount,
      posOverridePrice, posOpenCashDrawer, posCloseShift, posViewShiftReport,
      salesView, salesCreate, salesEdit, salesDelete, salesVoid, salesReturn, salesViewReports, salesExport,
      purchasesView, purchasesCreate, purchasesEdit, purchasesDelete, purchasesReturn, purchasesApprove, purchasesViewReports,
      productsView, productsCreate, productsEdit, productsDelete, productsManageCategories, productsManageUnits, productsManageBatches, productsPrintBarcodes,
      inventoryView, inventoryAdjust, inventoryTransfer, inventoryCount, inventoryViewReports, inventoryManageWarehouses,
      customersView, customersCreate, customersEdit, customersDelete, customersManageCredit, customersViewStatements, customersReceivePayments,
      suppliersView, suppliersCreate, suppliersEdit, suppliersDelete, suppliersManageCredit, suppliersMakePayments,
      accountingView, accountingManage, accountingCreateEntries, accountingEditEntries, accountingPostEntries, accountingManageAccounts, accountingManagePeriods, accountingViewReports, accountingManageAssets,
      reportsView, reportsSales, reportsPurchases, reportsInventory, reportsAccounting, reportsCustomers, reportsSuppliers, reportsExport, reportsPrint,
      hrView, hrManageEmployees, hrManageAttendance, hrManagePayroll, hrProcessSalaries, hrViewReports,
      manufacturingView, manufacturingCreateOrder, manufacturingEditOrder, manufacturingDeleteOrder, manufacturingManageBOM, manufacturingViewReports,
      settingsView, settingsManageUsers, settingsBackup,
    ],
    'cashier': [
      // أمين الصندوق: عمليات POS فقط
      posAccess, posCreateSale, posHoldSale, posViewShiftReport,
      salesView, salesCreate,
      customersView, customersCreate, customersReceivePayments,
      reportsView,
    ],
    'accountant': [
      // المحاسب: صلاحيات محاسبية وتقارير
      accountingView, accountingManage, accountingCreateEntries, accountingEditEntries, accountingPostEntries,
      accountingManageAccounts, accountingManagePeriods, accountingViewReports, accountingManageAssets, accountingDepreciation,
      salesView, salesViewReports,
      purchasesView, purchasesViewReports,
      customersView, customersViewStatements, customersReceivePayments,
      suppliersView, suppliersMakePayments,
      reportsView, reportsSales, reportsPurchases, reportsAccounting, reportsCustomers, reportsSuppliers, reportsExport, reportsPrint,
      inventoryView, inventoryViewReports,
    ],
    'storekeeper': [
      // أمين المخزن: إدارة المخزون والمشتريات
      inventoryView, inventoryAdjust, inventoryTransfer, inventoryCount, inventoryViewReports,
      purchasesView, purchasesCreate, purchasesEdit, purchasesReturn,
      productsView, productsEdit, productsManageBatches,
      suppliersView,
      reportsView, reportsInventory, reportsPurchases,
    ],
    'viewer': [
      // مشاهد: عرض فقط بدون تعديل
      posAccess,
      salesView,
      purchasesView,
      productsView,
      inventoryView,
      customersView,
      suppliersView,
      accountingView,
      reportsView, reportsSales, reportsPurchases, reportsInventory, reportsAccounting, reportsCustomers, reportsSuppliers,
      hrView,
      manufacturingView,
      settingsView,
    ],
  };
}
