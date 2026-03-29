import 'package:flutter/material.dart';
import 'view/category_selection_screen.dart';
import 'view/assessment_questionnaire_screen.dart';
import 'view/assessment_result_screen.dart';
import 'view/login_screen.dart';
import 'view/register_screen.dart';
import 'view/camera_screen.dart';
import 'model/assessment_model.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String categorySelection = '/assessment-categories';
  static const String questionnaire = '/assessment/questionnaire';
  static const String results = '/assessment/results';
  static const String camera = '/camera';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );
      
      case AppRoutes.categorySelection:
        return MaterialPageRoute(
          builder: (_) => const CategorySelectionScreen(),
        );
      
      case AppRoutes.questionnaire:
        final category = settings.arguments as PTSDCategory;
        return MaterialPageRoute(
          builder: (_) => AssessmentQuestionnaireScreen(category: category),
        );
      
      case AppRoutes.results:
        final result = settings.arguments as AssessmentResult;
        return MaterialPageRoute(
          builder: (_) => AssessmentResultScreen(result: result),
        );
      
      case AppRoutes.camera:
        return MaterialPageRoute(
          builder: (_) => const CameraScreen(),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}

// Helper method to navigate to assessment
void navigateToAssessment(BuildContext context) {
  Navigator.pushNamed(context, AppRoutes.categorySelection);
}
