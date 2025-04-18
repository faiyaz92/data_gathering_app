import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:requirment_gathering_app/company_admin_module/presentation/ledger/account_ledger_cubit.dart';
import 'package:requirment_gathering_app/company_admin_module/presentation/product/add_edit_category_cubit.dart';
import 'package:requirment_gathering_app/company_admin_module/presentation/product/product_cubit.dart';
import 'package:requirment_gathering_app/company_admin_module/presentation/tasks/task_cubit.dart';
import 'package:requirment_gathering_app/company_admin_module/presentation/users/add_user_cubit.dart';
import 'package:requirment_gathering_app/company_admin_module/presentation/users/user_list_cubit.dart';
import 'package:requirment_gathering_app/company_admin_module/repositories/account_ledger_repository.dart';
import 'package:requirment_gathering_app/company_admin_module/repositories/category_repository.dart';
import 'package:requirment_gathering_app/company_admin_module/repositories/product_repository.dart';
import 'package:requirment_gathering_app/company_admin_module/repositories/product_repository_impl.dart';
import 'package:requirment_gathering_app/company_admin_module/repositories/task_repository.dart';
import 'package:requirment_gathering_app/company_admin_module/repositories/task_repository_impl.dart';
import 'package:requirment_gathering_app/company_admin_module/service/account_ledger_service.dart';
import 'package:requirment_gathering_app/company_admin_module/service/category_service.dart';
import 'package:requirment_gathering_app/company_admin_module/service/category_service_impl.dart';
import 'package:requirment_gathering_app/company_admin_module/service/product_service.dart';
import 'package:requirment_gathering_app/company_admin_module/service/product_service_impl.dart';
import 'package:requirment_gathering_app/company_admin_module/service/task_service.dart';
import 'package:requirment_gathering_app/company_admin_module/service/task_service_impl.dart';
import 'package:requirment_gathering_app/company_admin_module/service/user_services.dart';
import 'package:requirment_gathering_app/company_admin_module/service/user_services_impl.dart';
import 'package:requirment_gathering_app/core_module/app_router/app_router.gr.dart';
import 'package:requirment_gathering_app/core_module/coordinator/app_cordinator.dart';
import 'package:requirment_gathering_app/core_module/coordinator/coordinator.dart';
import 'package:requirment_gathering_app/core_module/presentation/dashboard/dashboard/dashboard_cubit.dart';
import 'package:requirment_gathering_app/core_module/presentation/dashboard/home/home_cubit.dart';
import 'package:requirment_gathering_app/core_module/presentation/login/login_cubit.dart';
import 'package:requirment_gathering_app/core_module/presentation/login/splash_cubit.dart';
import 'package:requirment_gathering_app/core_module/repository/account_repository.dart';
import 'package:requirment_gathering_app/core_module/repository/account_repository_impl.dart';
import 'package:requirment_gathering_app/core_module/services/auth_service.dart';
import 'package:requirment_gathering_app/core_module/services/auth_service_impl.dart';
import 'package:requirment_gathering_app/core_module/services/firestore_provider.dart';
import 'package:requirment_gathering_app/core_module/services/firestore_provider_impl.dart';
import 'package:requirment_gathering_app/core_module/services/provider.dart';
import 'package:requirment_gathering_app/core_module/services/user_service.dart';
import 'package:requirment_gathering_app/core_module/services/user_service_impl.dart';
import 'package:requirment_gathering_app/super_admin_module/ai_module/presentation/ai_company_list_cubit.dart';
import 'package:requirment_gathering_app/super_admin_module/ai_module/repositories/ai_company_repository.dart';
import 'package:requirment_gathering_app/super_admin_module/ai_module/repositories/ai_company_repository_impl.dart';
import 'package:requirment_gathering_app/super_admin_module/presentation/add_tenant_company/add_tenant_company_cubit.dart';
import 'package:requirment_gathering_app/super_admin_module/repository/tenant_company_repository.dart';
import 'package:requirment_gathering_app/super_admin_module/repository/tenant_company_repository_impl.dart';
import 'package:requirment_gathering_app/super_admin_module/services/tenant_company_service.dart';
import 'package:requirment_gathering_app/super_admin_module/services/tenant_company_service_impl.dart';
import 'package:requirment_gathering_app/user_module/presentation/add_company/customer_company_cubit.dart';
import 'package:requirment_gathering_app/user_module/presentation/company_settings/company_settings_cubit.dart';
import 'package:requirment_gathering_app/user_module/repo/company_settings_repository.dart';
import 'package:requirment_gathering_app/user_module/repo/company_settings_repository_impl.dart';
import 'package:requirment_gathering_app/user_module/repo/customer_company_repository.dart';
import 'package:requirment_gathering_app/user_module/repo/customer_company_repository_impl.dart';
import 'package:requirment_gathering_app/user_module/services/customer_company_service.dart';
import 'package:requirment_gathering_app/user_module/services/customer_company_service_impl.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  _initFirebase();
  _initRepositories();
  _initServices();
  _initCubits();
  _initAppNavigation();
}

/// **1. Initialize Firebase Dependencies**
void _initFirebase() {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<IFirestorePathProvider>(
      () => FirestorePathProviderImpl(sl<FirebaseFirestore>()));
}

/// **2. Initialize Repositories**
void _initRepositories() {
  // Account Repository
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(
        sl<FirebaseAuth>(),
        sl<IFirestorePathProvider>(),
      ));

  // Company Repository
  sl.registerFactory<CustomerCompanyRepository>(() =>
      CustomerCompanyRepositoryImpl(
          sl<IFirestorePathProvider>(), sl<AccountRepository>()));

  // Company Setting Repository
  sl.registerLazySingleton<CompanySettingRepository>(
      () => CompanySettingRepositoryImpl(
            sl<IFirestorePathProvider>(),
            sl<AccountRepository>(),
          ));

  // AI Company Repository
  sl.registerLazySingleton<AiCompanyListRepository>(
      () => AiCompanyListRepositoryImpl(sl<DioClientProvider>()));

  sl.registerLazySingleton<ITenantCompanyRepository>(
      () => TenantCompanyRepository(
            sl<IFirestorePathProvider>(),
            sl<FirebaseAuth>(),
            sl<AccountRepository>(),
          ));

  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(sl<IFirestorePathProvider>()));
  sl.registerLazySingleton<IAccountLedgerRepository>(
      () => AccountLedgerRepositoryImpl(sl<IFirestorePathProvider>()));
  // ✅ Register Product Repository
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(
      firestore: sl<FirebaseFirestore>(),
      firestorePathProvider: sl<IFirestorePathProvider>()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(
        firestorePathProvider: sl<IFirestorePathProvider>(),
      ));
}

/// **3. Initialize Services**
void _initServices() {
  sl.registerLazySingleton<AuthService>(
      () => AuthServiceImpl(sl<AccountRepository>()));

  sl.registerLazySingleton<CustomerCompanyService>(
    () => CustomerCompanyServiceImpl(
      sl<CustomerCompanyRepository>(),
      companySettingRepository: sl<CompanySettingRepository>(),
    ),
  );
  sl.registerLazySingleton<TenantCompanyService>(
    () => TenantCompanyServiceImpl(
      sl<ITenantCompanyRepository>(),
    ),
  );

  // ✅ Register CompanyOperationsService
  sl.registerLazySingleton<UserServices>(
    () => UserServicesImpl(
      sl<ITenantCompanyRepository>(),
      sl<AccountRepository>(),
    ),
  );
  sl.registerLazySingleton<TaskService>(
      () => TaskServiceImpl(sl<TaskRepository>(), sl<AccountRepository>()));

  sl.registerLazySingleton<IAccountLedgerService>(
      () => AccountLedgerServiceImpl(
            sl<IAccountLedgerRepository>(),
            sl<AccountRepository>(),
            sl<CustomerCompanyService>(),
          ));
  sl.registerLazySingleton<IUserService>(
      () => UserServiceImpl(sl<AccountRepository>()));
  // ✅ Register Product Service
  sl.registerLazySingleton<ProductService>(() => ProductServiceImpl(
      productRepository: sl<ProductRepository>(), sl<AccountRepository>()));
  sl.registerLazySingleton<CategoryService>(() => CategoryServiceImpl(
        categoryRepository: sl<CategoryRepository>(),
        accountRepository: sl<AccountRepository>(),
      ));
}

/// **4. Initialize Cubits (State Management)**
void _initCubits() {
  sl.registerFactory(
      () => LoginCubit(sl<AuthService>(), sl<TenantCompanyService>()));
  sl.registerFactory(() => SplashCubit(sl<AccountRepository>()));

  sl.registerFactory(() =>
      CustomerCompanyCubit(sl<CustomerCompanyService>(), sl<UserServices>()));
  sl.registerFactory(() => DashboardCubit());
  sl.registerFactory(() => CompanySettingCubit(sl<CustomerCompanyService>()));

  sl.registerFactory(() => AiCompanyListCubit(
        sl<AiCompanyListRepository>(),
        sl<CompanySettingRepository>(),
        sl<CustomerCompanyRepository>(),
      ));

  // ✅ Register AddTenantCompanyCubit
  sl.registerFactory(() => AddTenantCompanyCubit(
        sl<TenantCompanyService>(),
      ));

  // ✅ Register AddUserCubit for adding users
  sl.registerFactory(() => AddUserCubit(
        sl<UserServices>(),
      ));
  sl.registerFactory(() => TaskCubit(sl<TaskService>(), sl<UserServices>(),
      sl<CustomerCompanyService>(), sl<AccountRepository>()));
  sl.registerFactory(() => AccountLedgerCubit(
        sl<IAccountLedgerService>(),
        sl<AccountRepository>(),
      ));
  sl.registerFactory(() => HomeCubit(sl<IUserService>()));
  sl.registerFactory(() => UserListCubit(sl<UserServices>()));
  sl.registerFactory(() => ProductCubit(
        productService: sl<ProductService>(),
        categoryService: sl<CategoryService>(),
      ));
  sl.registerFactory(() => CategoryCubit(
        categoryService: sl<CategoryService>(),
      ));
}

/// **5. Initialize App Navigation & Coordinator**
void _initAppNavigation() {
  sl.registerLazySingleton<AppRouter>(() => AppRouter());
  sl.registerLazySingleton<Coordinator>(() => AppCoordinator(sl<AppRouter>()));
}
