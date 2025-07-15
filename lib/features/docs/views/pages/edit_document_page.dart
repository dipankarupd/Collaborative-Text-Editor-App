import 'package:app/client/ws_client.dart';
import 'package:app/features/docs/domain/entity/doc_entity.dart';
import 'package:app/features/docs/views/bloc/doc_bloc.dart';
import 'package:app/features/docs/views/widgets/app_logo.dart';
import 'package:app/features/docs/views/widgets/document_action_button.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:async';

class EditDocumentPage extends StatefulWidget {
  final String docId;
  const EditDocumentPage({super.key, required this.docId});

  @override
  State<EditDocumentPage> createState() => _EditDocumentPageState();
}

class _EditDocumentPageState extends State<EditDocumentPage> {
  final TextEditingController titleController = TextEditingController();
  quill.QuillController _controller = quill.QuillController.basic();
  bool _isInitialized = false;
  bool _isApplyingRemoteChange = false; // Flag to prevent infinite loops

  late WebSocketService _webSocketService;

  // WebSocket connection state
  bool _isWebSocketConnected = false;
  String _connectionStatus = 'Disconnected';

  // Auto-save timer
  Timer? _autoSaveTimer;

  // Document change subscription
  StreamSubscription? _documentChangeSubscription;

  @override
  void initState() {
    super.initState();

    // Fetch the document data when the page loads
    context.read<DocBloc>().add(
      DocGetDocumentByIdEvent(documentId: widget.docId),
    );

    // Initialize WebSocket
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    _webSocketService = WebSocketService();

    // Set up WebSocket callbacks
    _webSocketService.onDelta = _onRemoteDeltaReceived;
    _webSocketService.onConnectionStatusChanged = _onConnectionStatusChanged;

    // Connect to WebSocket
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    setState(() {
      _connectionStatus = 'Connecting...';
    });

    try {
      await _webSocketService.connect(widget.docId);
      print('WebSocket connected successfully');
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      setState(() {
        _connectionStatus = 'Connection failed';
      });
    }
  }

  void _onConnectionStatusChanged(bool isConnected) {
    setState(() {
      _isWebSocketConnected = isConnected;
      _connectionStatus = isConnected ? 'Connected' : 'Disconnected';
    });
  }

  void _onRemoteDeltaReceived(Delta delta) {
    if (_isApplyingRemoteChange) {
      print('Already applying remote change, skipping...');
      return;
    }

    print('Applying remote delta: ${delta.toJson()}');

    // Set flag to prevent infinite loops
    _isApplyingRemoteChange = true;

    try {
      // Apply the remote delta using compose
      _controller.compose(
        delta,
        _controller.selection,
        quill.ChangeSource.remote,
      );

      print('Remote delta applied successfully');
    } catch (e) {
      print('Error applying remote delta: $e');
    } finally {
      // Reset flag immediately after applying the change
      _isApplyingRemoteChange = false;
    }
  }

  void _setupDocumentChangeListener() {
    // Cancel existing subscription if any
    _documentChangeSubscription?.cancel();

    // Listen to document changes
    _documentChangeSubscription = _controller.document.changes.listen((event) {
      print('Document change detected - Source: ${event.source}');

      // Only send changes that are local (user-initiated)
      if (event.source == quill.ChangeSource.local &&
          !_isApplyingRemoteChange) {
        Delta delta = event.change;
        print('Sending local delta: ${delta.toJson()}');

        // Send to WebSocket
        if (_isWebSocketConnected) {
          _webSocketService.sendTyping(delta);
        }

        // Setup auto-save
        _setupAutoSave();
      }
    });
  }

  void _setupAutoSave() {
    // Cancel existing timer
    _autoSaveTimer?.cancel();

    // Set up new timer for auto-save (after 2 seconds of inactivity)
    _autoSaveTimer = Timer(Duration(seconds: 2), () {
      _saveDocument();
    });
  }

  void _saveDocument() {
    if (_isWebSocketConnected) {
      // Get the current document content as Delta
      Delta documentContent = _controller.document.toDelta();

      // Send the save event with the document content
      _webSocketService.sendSave(documentContent);

      print('Document auto-saved with content: ${documentContent.toJson()}');
    } else {
      print('Cannot save document - WebSocket not connected');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    _controller.dispose();
    _documentChangeSubscription?.cancel();
    _autoSaveTimer?.cancel();
    _webSocketService.disconnect();
    super.dispose();
  }

  void _createQuillController(Document doc) {
    // Dispose existing controller if any
    _controller.dispose();

    _controller = quill.QuillController(
      document:
          doc.content.isEmpty
              ? quill.Document()
              : quill.Document.fromDelta(Delta.fromJson(doc.content)),
      selection: TextSelection.collapsed(offset: 0),
    );

    // Set up document change listener after controller is created
    _setupDocumentChangeListener();

    setState(() {});
  }

  Widget _buildConnectionIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: _isWebSocketConnected ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isWebSocketConnected ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            _connectionStatus,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (popped, c) {
        if (popped) {
          context.read<DocBloc>().add(FetchDocsEvent());
        }
      },
      child: BlocListener<DocBloc, DocState>(
        listener: (context, state) {
          if (state is DocumentTitleSuccessfullyUpdatedState) {
            // Update the text field with the new title
            titleController.text = state.newTitle;
            // Show success feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Title updated successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is DocErrorState) {
            // Show error feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          } else if (state is DocGetDocumentByIdSuccessState &&
              !_isInitialized) {
            // Initialize the title and content when document is loaded for the first time
            titleController.text = state.document.title;
            _createQuillController(state.document);
            _isInitialized = true;

            print('Document initialized with title: ${state.document.title}');
            print('Document content: ${state.document.content}');
          }
        },
        child: BlocBuilder<DocBloc, DocState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                actionsPadding: EdgeInsets.all(12),
                automaticallyImplyLeading: false,
                actions: [
                  // Connection status indicator
                  _buildConnectionIndicator(),

                  // Reconnect button if disconnected
                  if (!_isWebSocketConnected)
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _connectWebSocket,
                      tooltip: 'Reconnect',
                    ),

                  if (state is DocLoadingState)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  DocumentActionButton(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: 40,
                    text: 'Share',
                    icon: Icons.lock,
                  ),
                ],
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: AppLogo(),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 20),
                      if (state is DocGetDocumentByIdSuccessState ||
                          _isInitialized)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.12,
                          child: TextField(
                            controller: titleController,
                            enabled: state is! DocLoadingState,
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                context.read<DocBloc>().add(
                                  DocUpdateTitleEvent(
                                    documentId: widget.docId,
                                    title: value.trim(),
                                  ),
                                );
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintText:
                                  titleController.text.isEmpty
                                      ? 'Loading title...'
                                      : '',
                            ),
                          ),
                        )
                      else
                        CircularProgressIndicator(),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade800,
                        width: 0.1,
                      ),
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: quill.QuillSimpleToolbar(controller: _controller),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SizedBox(
                      width: 750,
                      child: Card(
                        shape: BeveledRectangleBorder(),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              state is DocLoadingState && !_isInitialized
                                  ? Center(child: CircularProgressIndicator())
                                  : quill.QuillEditor.basic(
                                    controller: _controller,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
