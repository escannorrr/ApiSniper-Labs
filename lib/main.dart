import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'router/app_router.dart';
import 'core/theme/app_theme.dart';

// Features - Repositories
import 'features/projects/data/repositories/project_repository_impl.dart';
import 'features/projects/data/datasources/project_remote_datasource.dart';
import 'features/endpoints/data/repositories/endpoint_repository_impl.dart';
import 'features/endpoints/data/datasources/endpoint_remote_datasource.dart';
import 'features/test_generation/data/repositories/test_repository_impl.dart';
import 'features/test_generation/data/datasources/test_remote_datasource.dart';
import 'features/security_analysis/data/repositories/security_repository_impl.dart';
import 'features/security_analysis/data/datasources/security_remote_datasource.dart';
import 'features/billing/data/repositories/billing_repository_impl.dart';
import 'features/billing/data/datasources/billing_remote_datasource.dart';
import 'features/settings/data/repositories/user_repository_impl.dart';
import 'features/settings/data/datasources/user_remote_datasource.dart';

// Features - BLoCs
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/endpoints/presentation/bloc/endpoints_bloc.dart';
import 'features/test_generation/presentation/bloc/test_generation_bloc.dart';
import 'features/security_analysis/presentation/bloc/security_analysis_bloc.dart';
import 'features/billing/presentation/bloc/billing_bloc.dart';
import 'features/settings/presentation/bloc/profile_bloc.dart';
import 'features/settings/presentation/bloc/account_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sharedPreferences = await SharedPreferences.getInstance();
  final apiClient = ApiClient(
    onUnauthorized: () {
      Future.microtask(() {
        final context = navigatorKey.currentContext;
        if (context != null && context.mounted) {
          context.read<AuthBloc>().add(AuthLogoutRequested());
        }
      });
    },
  );
  
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(apiClient),
    sharedPreferences: sharedPreferences,
  );
  
  final dashboardRemoteDataSource = DashboardRemoteDataSourceImpl(apiClient);
  
  // Real Repositories
  final projectRepository = ProjectRepositoryImpl(
    remoteDataSource: ProjectRemoteDataSourceImpl(apiClient),
  );
  final endpointRepository = EndpointRepositoryImpl(
    remoteDataSource: EndpointRemoteDataSourceImpl(apiClient),
  );
  final testRepository = TestRepositoryImpl(
    remoteDataSource: TestRemoteDataSourceImpl(apiClient),
  );
  final securityRepository = SecurityRepositoryImpl(
    remoteDataSource: SecurityRemoteDataSourceImpl(apiClient),
  );
  final billingRepository = BillingRepositoryImpl(
    remoteDataSource: BillingRemoteDataSourceImpl(apiClient),
  );
  final userRepository = UserRepositoryImpl(
    remoteDataSource: UserRemoteDataSourceImpl(apiClient),
  );

  runApp(ApiSniperLabsApp(
    authRepository: authRepository,
    dashboardRemoteDataSource: dashboardRemoteDataSource,
    projectRepository: projectRepository,
    endpointRepository: endpointRepository,
    testRepository: testRepository,
    securityRepository: securityRepository,
    billingRepository: billingRepository,
    userRepository: userRepository,
  ));
}

class ApiSniperLabsApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final DashboardRemoteDataSourceImpl dashboardRemoteDataSource;
  final ProjectRepositoryImpl projectRepository;
  final EndpointRepositoryImpl endpointRepository;
  final TestRepositoryImpl testRepository;
  final SecurityRepositoryImpl securityRepository;
  final BillingRepositoryImpl billingRepository;
  final UserRepositoryImpl userRepository;

  const ApiSniperLabsApp({
    super.key,
    required this.authRepository,
    required this.dashboardRemoteDataSource,
    required this.projectRepository,
    required this.endpointRepository,
    required this.testRepository,
    required this.securityRepository,
    required this.billingRepository,
    required this.userRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository)..add(AuthCheckRequested()),
        ),
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(dataSource: dashboardRemoteDataSource),
        ),
        BlocProvider<ProjectsBloc>(
          create: (context) => ProjectsBloc(repository: projectRepository),
        ),
        BlocProvider<EndpointsBloc>(
          create: (context) => EndpointsBloc(repository: endpointRepository),
        ),
        BlocProvider<TestGenerationBloc>(
          create: (context) => TestGenerationBloc(repository: testRepository),
        ),
        BlocProvider<SecurityAnalysisBloc>(
          create: (context) => SecurityAnalysisBloc(repository: securityRepository),
        ),
        BlocProvider<BillingBloc>(
          create: (context) => BillingBloc(repository: billingRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(repository: userRepository),
        ),
        BlocProvider<AccountBloc>(
          create: (context) => AccountBloc(repository: userRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'APISniper Labs',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
