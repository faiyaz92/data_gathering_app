import 'package:requirment_gathering_app/company_admin_module/data/product/category.dart';
import 'package:requirment_gathering_app/company_admin_module/data/product/product_model.dart';
import 'package:requirment_gathering_app/company_admin_module/data/product/sub_category.dart';
import 'package:requirment_gathering_app/company_admin_module/data/task/task_model.dart';
import 'package:requirment_gathering_app/super_admin_module/data/tenant_company.dart';
import 'package:requirment_gathering_app/super_admin_module/data/user_info.dart';
import 'package:requirment_gathering_app/user_module/data/company.dart';

abstract class Coordinator {
  void navigateToLoginPage();

  void navigateToDashboardPage();

  void navigateToSplashScreen();

  void navigateToHomePage();

  void navigateToCompanyListPage(); // For existing CompanyListPage
  void navigateToAiCompanyListPage(); // For AiCompanyListPage
  void navigateToReportsPage();

  void navigateToCompanySettingsPage();

  void navigateToAddCompanyPage();

  void navigateToCompanyDetailsPage(Company company);

  void navigateToEditCompanyPage(Company? company);

  void navigateBack({bool isUpdated});

  // 🔹 Super Admin Navigation
  void navigateToSuperAdminPage();

  // 🔹 Add & Edit Tenant Company Navigation
  void navigateToAddTenantCompanyPage({TenantCompany? company});

  void navigateToAddUserPage({UserInfo? user});

  void navigateToCompanyAdminPage();

  void navigateToUserListPage();

  void navigateToTaskListPage();

  Future<dynamic> navigateToAddTaskPage({TaskModel? task});

  void navigateToAccountLedgerPage({required Company company});

  void navigateToCreateLedgerPage(String companyId, String customerCompanyId);

  // ✅ New Product Navigation Methods
  void navigateToProductListPage();

  Future<dynamic> navigateToAddEditProductPage({Product? product});

  // 🔹 Add Edit Category/Subcategory Navigation Methods
  void navigateToAddEditCategoryPage({Category? category});

  void navigateToAddEditSubcategoryPage(
      {Subcategory? subcategory, required Category category});

  void navigateToProductManagementPage();

  Future<dynamic>
      navigateToCategoriesWithSubcategoriesPage(); // Add this line for the new page.
}
