import 'package:usnepal/home/presentation/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'app/router.dart';
import 'app/view/login_screen.dart';
import 'app/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MindGuard - PTSD Support',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: Consumer(
        builder: (context, ref, _) {
          // Check authentication state directly
          final isAuthenticated = ref.watch(isAuthenticatedProvider);

          final isLoading = ref.watch(authLoadingProvider);

          print('🔄 Authentication check: $isAuthenticated, loading: $isLoading');

          if (isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          if (isAuthenticated) {
            print('✅ User authenticated - Going to HomeScreen');
            return HomePage();
          } else {
            print('❌ User not authenticated - Showing LoginScreen');
            return const LoginScreen();
            // return HomePage();
          }
        },
      ),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

