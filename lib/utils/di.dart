import 'package:app/client/ws_client.dart';
import 'package:app/common/cubit/app_cubit_cubit.dart';
import 'package:app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:app/features/auth/data/source/auth_local_source.dart';
import 'package:app/features/auth/data/source/auth_remote_source.dart';
import 'package:app/features/auth/domain/repo/auth_repo.dart';
import 'package:app/features/auth/domain/usecases/login.dart';
import 'package:app/features/auth/domain/usecases/logout.dart';
import 'package:app/features/auth/domain/usecases/me.dart';
import 'package:app/features/auth/domain/usecases/register.dart';
import 'package:app/features/auth/views/bloc/auth_bloc.dart';
import 'package:app/features/docs/data/repo/doc_repo_impl.dart';
import 'package:app/features/docs/data/source/doc_remote.dart';
import 'package:app/features/docs/domain/repo/doc_repo.dart';
import 'package:app/features/docs/domain/usecases/create_document.dart';
import 'package:app/features/docs/domain/usecases/get_all_documents.dart';
import 'package:app/features/docs/domain/usecases/get_document_by_id.dart';
import 'package:app/features/docs/domain/usecases/update_title.dart';
import 'package:app/features/docs/views/bloc/doc_bloc.dart';
import 'package:app/utils/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependancies() async {
  final dio = Dio();
  serviceLocator.registerLazySingleton(() => dio);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => prefs);

  // AuthLocalSource
  final authLocalSource = AuthLocalSource(prefs: prefs);
  serviceLocator.registerLazySingleton(() => authLocalSource);

  // Attach TokenInterceptor to Dio
  dio.interceptors.add(
    TokenInterceptor(dio: dio, authLocalSource: authLocalSource),
  );

  serviceLocator.registerLazySingleton(() => AppCubitCubit());

  _initAuth();
  _initDoc();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteSource>(
      () => AuthRemoteSourceImpl(
        dio: serviceLocator(),
        authLocalSource: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepo>(() => AuthRepoImpl(source: serviceLocator()))
    ..registerFactory<Login>(() => Login(repo: serviceLocator()))
    ..registerFactory<Register>(() => Register(repo: serviceLocator()))
    ..registerFactory<Me>(() => Me(repo: serviceLocator()))
    ..registerFactory<Logout>(() => Logout(repo: serviceLocator()))
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        login: serviceLocator(),
        register: serviceLocator(),
        me: serviceLocator(),
        appCubitCubit: serviceLocator(),
      ),
    );
}

void _initDoc() {
  serviceLocator
    ..registerFactory<DocRemoteSource>(
      () => DocRemoteSourceImpl(dio: serviceLocator()),
    )
    ..registerFactory<DocRepo>(() => DocRepoImpl(source: serviceLocator()))
    ..registerFactory<GetAllDocuments>(
      () => GetAllDocuments(repo: serviceLocator()),
    )
    ..registerFactory<CreateDocument>(
      () => CreateDocument(repo: serviceLocator()),
    )
    ..registerFactory<UpdateTitle>(() => UpdateTitle(repo: serviceLocator()))
    ..registerFactory<GetDocumentById>(
      () => GetDocumentById(repo: serviceLocator()),
    )
    ..registerLazySingleton<DocBloc>(
      () => DocBloc(
        logout: serviceLocator(),
        getAllDocuments: serviceLocator(),
        createDocument: serviceLocator(),
        updateTitle: serviceLocator(),
        getDocumentById: serviceLocator(),
      ),
    );
}
