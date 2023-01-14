import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthenticationState { authenticated, unauthenticated }

class AppCubit extends Cubit<AuthenticationState> {
  AppCubit() : super(AuthenticationState.unauthenticated);

  void login() {
    emit(AuthenticationState.authenticated);
  }

  void logout() {
    emit(AuthenticationState.unauthenticated);
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      home: FlowBuilder<AuthenticationState>(
        state: context.select((AppCubit cubit) => cubit.state),
        onGeneratePages: (state, pages) {
          switch (state) {
            case AuthenticationState.authenticated:
              return [HomePage.page()];
            case AuthenticationState.unauthenticated:
              return [LoginPage.page()];
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage._({super.key});

  static Page<void> page() => const MaterialPage<void>(
        name: '/home',
        child: HomePage._(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Home Page'),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () {
                context.read<AppCubit>().logout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage._({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(name: 'login', child: LoginPage._());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Login Page'),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () {
                context.read<AppCubit>().login();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
