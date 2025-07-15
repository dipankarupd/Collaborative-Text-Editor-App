import 'package:app/common/cubit/app_cubit_cubit.dart';
import 'package:app/common/entity/user_entity.dart';
import 'package:app/config/routes/app_routes.dart';
import 'package:app/features/docs/views/bloc/doc_bloc.dart';
import 'package:app/features/docs/views/widgets/app_logo.dart';
import 'package:app/features/docs/views/widgets/create_new_doc_widget.dart';
import 'package:app/features/docs/views/widgets/document_container.dart';
import 'package:app/features/docs/views/widgets/error_fetching_doc.dart';
import 'package:app/features/docs/views/widgets/user_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocPage extends StatefulWidget {
  const DocPage({super.key});

  @override
  State<DocPage> createState() => _DocPageState();
}

class _DocPageState extends State<DocPage> {
  @override
  void initState() {
    super.initState();
    context.read<DocBloc>().add(FetchDocsEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-fetch docs when coming back to this page
    final currentState = context.read<DocBloc>().state;
    if (currentState is! FetchDocSuccessState &&
        currentState is! DocLoadingState) {
      context.read<DocBloc>().add(FetchDocsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubitCubit>().state;

    // Access user from AppCubit state
    User? user;
    if (state is AppUserLoggedInState) {
      user = state.user;
    }

    return BlocConsumer<DocBloc, DocState>(
      listener: (context, state) {
        if (state is DocSignoutSuccessState) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
        if (state is CreateDocumentSuccessState) {
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.documentWithId(state.doc.id));
        }
      },
      builder: (context, state) {
        if (state is DocLoadingState) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is DocErrorState) {
          return Scaffold(appBar: _buildAppBar(context), body: DocumentError());
        }

        if (state is FetchDocSuccessState) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Collabs of ${user!.name}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = constraints.maxWidth;
                        // Calculate columns based on screen width
                        final crossAxisCount =
                            screenWidth > 600
                                ? 3
                                : screenWidth > 400
                                ? 2
                                : 1;

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.35 / 0.26,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          padding: EdgeInsets.all(10),
                          itemCount:
                              state.docs.length + 1, // Add 1 for the extra item
                          itemBuilder: (context, index) {
                            // If it's the last index, return the "Create New" item
                            if (index == state.docs.length) {
                              return InkWell(
                                onTap: () {
                                  context.read<DocBloc>().add(DocCreateEvent());
                                },
                                child: CreateNewDocWidget(),
                              );
                            }

                            // Otherwise return the normal document item
                            final document = state.docs[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.documentWithId(document.id),
                                );
                              },
                              child: DocumentContainer(document: document),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox();
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 5,
      shadowColor: Colors.black54,
      automaticallyImplyLeading: false,
      actionsPadding: EdgeInsets.all(8),
      backgroundColor: Colors.white,
      title: AppLogo(),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'logout') {
              context.read<DocBloc>().add(DocSignoutEvent());
            }
          },
          itemBuilder:
              (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red.shade600, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
          child: UserIcon(),
        ),
      ],
    );
  }
}
