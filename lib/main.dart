import 'package:app/common/cubit/app_cubit_cubit.dart';
import 'package:app/config/routes/app_routes.dart';

import 'package:app/features/auth/views/bloc/auth_bloc.dart';
import 'package:app/features/auth/views/pages/login_page.dart';
import 'package:app/features/auth/views/pages/register_page.dart';
import 'package:app/features/docs/views/bloc/doc_bloc.dart';
import 'package:app/features/docs/views/pages/doc_page.dart';
import 'package:app/features/docs/views/pages/edit_document_page.dart';
import 'package:app/utils/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

void main() async {
  await initDependancies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppCubitCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<DocBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // print('CHeck from main');
    context.read<AuthBloc>().add(AuthIsLoggedInEvent());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      title: 'Text Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
      home: BlocListener<AppCubitCubit, AppCubitState>(
        listener: (context, state) {
          if (state is AppUserLoggedOutState || state is AppCubitInitial) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
          }
        },
        child: BlocSelector<AppCubitCubit, AppCubitState, bool>(
          selector: (state) => state is AppUserLoggedInState,
          builder: (context, isLoggedIn) {
            return isLoggedIn ? const DocPage() : LoginPage();
          },
        ),
      ),
      // routes: {
      //   AppRoutes.login: (context) => LoginPage(),
      //   AppRoutes.register: (context) => const RegistrationPage(),
      //   AppRoutes.home: (context) => const DocPage(),
      //   AppRoutes.documentWithId(id)
      // },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name!);

        switch (settings.name) {
          case AppRoutes.login:
            return MaterialPageRoute(builder: (context) => LoginPage());
          case AppRoutes.register:
            return MaterialPageRoute(
              builder: (context) => const RegistrationPage(),
            );
          case AppRoutes.home:
            return MaterialPageRoute(builder: (context) => const DocPage());
        }

        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'document') {
          final docId = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (context) => EditDocumentPage(docId: docId),
            settings: settings,
          );
        }
      },
    );
  }
}
