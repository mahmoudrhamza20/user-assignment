// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management_app/core/constants/app_strings.dart';
import 'package:user_management_app/core/di/dependency_injection.dart';
import 'package:user_management_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:user_management_app/main.dart';

void main() {
  setUp(() async {
    // Initialize SharedPreferences mock
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    // Setup DI
    if (getIt.isRegistered<AuthCubit>()) {
      await getIt.reset();
    }
    await setupDependencyInjection();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('App launches and shows login screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that our app name is shown.
    expect(find.text(AppStrings.appName), findsOneWidget);

    // Verify that login screen is shown (Sign in to continue text)
    expect(find.text('Sign in to continue'), findsOneWidget);

    // Verify login button is present
    expect(find.text(AppStrings.login), findsOneWidget);
  });
}
