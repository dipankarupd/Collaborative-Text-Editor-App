import 'package:app/config/routes/app_routes.dart';
import 'package:app/features/auth/views/bloc/auth_bloc.dart';
import 'package:app/features/auth/views/widgets/auth_button.dart';
import 'package:app/features/auth/views/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is AuthErrorState) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
              } else if (state is AuthSuccessState) {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Success"),
                        content: Text(
                          "You have Registered in successfully. Username: ${state.user.name}",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              formKey.currentState!.reset();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  SizedBox(
                    height: h * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    AuthTextField(
                                      hint: 'Enter Name',
                                      icon: Icons.person,
                                      controller: nameController,
                                    ),
                                    SizedBox(height: 20),

                                    AuthTextField(
                                      controller: emailController,
                                      hint: 'Enter Email',
                                      icon: Icons.email,
                                    ),
                                    SizedBox(height: 20),

                                    AuthTextField(
                                      controller: passwordController,
                                      hint: 'Enter Password',
                                      icon: Icons.lock,
                                      isObscure: true,
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AuthButton(
                          width: w * 0.1,
                          height: h * 0.07,
                          text: 'Register',
                          onPress: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthRegisterEvent(
                                  name: nameController.text.toString(),
                                  email: emailController.text.toString(),
                                  password: passwordController.text.toString(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fields are necessary'),
                                ),
                              );
                            }
                          },
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.login);
                          },
                          child: Text(
                            'I am already a member',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
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
    );
  }
}
