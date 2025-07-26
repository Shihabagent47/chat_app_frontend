import 'package:chat_app_user/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_event.dart';
import 'package:chat_app_user/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/routing/navigation_helper.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated &&
              state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          } else if (state.status == AuthStatus.authenticated) {
            NavigationHelper.goToChatList(context);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.loading;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading, // Disable during loading
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      label: 'Email',
                      hint: 'Enter your email',
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,

                      obscureText: true,
                      enabled: !isLoading, // Disable during loading
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      label: 'Password',
                      hint: 'Enter your password',
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _login,
                        child:
                            isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Login'),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                NavigationHelper.goToRegister(context);
                              },
                      child: Text('Don\'t have an account? Register'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
