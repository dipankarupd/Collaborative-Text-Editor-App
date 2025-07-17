import 'package:app/config/routes/app_routes.dart';
import 'package:app/features/auth/views/bloc/auth_bloc.dart';
import 'package:app/features/auth/views/widgets/auth_button.dart';
import 'package:app/features/auth/views/widgets/auth_text_field.dart';
import 'package:app/features/auth/views/widgets/google_signin_button.dart';
import 'package:app/utils/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: Container(
          width: w * 0.7,
          height: h * 0.65,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthErrorState) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                } else if (state is AuthSuccessState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.home,
                      // arguments: state.user,
                    );
                  });
                }
              },
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[50],
                              ),
                              child: Center(
                                child: Image.network(
                                  'https://images.pexels.com/photos/2104882/pexels-photo-2104882.jpeg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 100,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    AuthTextField(
                                      hint: 'Enter email',
                                      icon: Icons.email,
                                      controller: emailController,
                                    ),
                                    SizedBox(height: 25),
                                    AuthTextField(
                                      hint: 'Enter Password',
                                      icon: Icons.lock,
                                      isObscure: true,
                                      controller: passwordController,
                                    ),

                                    SizedBox(height: 45),
                                    AuthButton(
                                      width: w * 0.1,
                                      height: h * 0.05,
                                      text: 'Login',
                                      onPress: () {
                                        if (formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                            AuthLoginEvent(
                                              email:
                                                  emailController.text
                                                      .toString(),
                                              password:
                                                  passwordController.text
                                                      .toString(),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Fields are necessary',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.register);
                            },
                            child: Text(
                              'Create an Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SigninWithGoogleButton(
                            w: w * 0.1,
                            h: h * 0.07,
                            onPress: () async {
                              print('press');
                              final (name, email) = await signinWithGoogle();
                              context.read<AuthBloc>().add(
                                AuthLoginWithGoogleEvent(
                                  name: name,
                                  email: email,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
