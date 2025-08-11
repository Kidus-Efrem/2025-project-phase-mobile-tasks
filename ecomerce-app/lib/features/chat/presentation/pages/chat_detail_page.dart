import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;

  const ChatDetailPage({
    super.key,
    required this.chat,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('🔍 ChatDetailPage - Chat ID: "${widget.chat.id}"');
    print('🔍 ChatDetailPage - Chat object: ${widget.chat}');
    context.read<ChatBloc>().add(LoadMessages(widget.chat.id));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    print('🚀 ChatDetailPage - _sendMessage called');
    print('🚀 ChatDetailPage - Message content: "${_messageController.text.trim()}"');
    print('🚀 ChatDetailPage - Chat ID: "${widget.chat.id}"');
    
    if (_messageController.text.trim().isNotEmpty) {
      final content = _messageController.text.trim();
      _messageController.clear();
      
      print('🚀 ChatDetailPage - Content trimmed: "$content"');
      
      // Add message immediately to UI for instant feedback
      final currentUser = _getCurrentUser();
      print('🚀 ChatDetailPage - Current user: ${currentUser?.name} (ID: ${currentUser?.id})');
      
      if (currentUser != null) {
        final tempMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: currentUser,
          chat: widget.chat,
          content: content,
          type: 'text',
          createdAt: DateTime.now(),
        );
        
        print('🚀 ChatDetailPage - Created temp message with ID: ${tempMessage.id}');
        
        setState(() {
          _messages.add(tempMessage);
        });
        print('🚀 ChatDetailPage - Added temp message to UI. Total messages: ${_messages.length}');
        _scrollToBottom();
      } else {
        print('❌ ChatDetailPage - Current user is null!');
      }
      
      // Send via socket
      print('🚀 ChatDetailPage - Dispatching SendMessage event to ChatBloc');
      context.read<ChatBloc>().add(SendMessage(
        chatId: widget.chat.id,
        content: content,
        type: 'text',
      ));
      print('🚀 ChatDetailPage - SendMessage event dispatched');
    } else {
      print('❌ ChatDetailPage - Message content is empty, not sending');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.pink.shade100,
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getOtherUserName(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                const Text('8 members, 5 online', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: const [
          Icon(Icons.call_outlined),
          SizedBox(width: 12),
          Icon(Icons.videocam_outlined),
          SizedBox(width: 12),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MultiBlocListener(
              listeners: [
                // Listen for socket messages
                BlocListener<ChatBloc, ChatState>(
                  listener: (context, state) {
                    print('🚀 ChatDetailPage - BlocListener state: ${state.runtimeType}');
                    
                    if (state is MessageReceived) {
                      print('🚀 ChatDetailPage - MessageReceived state detected');
                      print('🚀 ChatDetailPage - Received message content: "${state.message.content}"');
                      print('🚀 ChatDetailPage - Received message chat ID: "${state.message.chat.id}"');
                      print('🚀 ChatDetailPage - Current chat ID: "${widget.chat.id}"');
                      
                      // Handle incoming socket message
                      final message = state.message;
                      if (message.chat.id == widget.chat.id) {
                        print('✅ ChatDetailPage - Message belongs to current chat, adding to UI');
                        setState(() {
                          // Check if message already exists to avoid duplicates
                          if (!_messages.any((m) => m.id == message.id)) {
                            _messages.add(message);
                            print('✅ ChatDetailPage - Message added to UI. Total messages: ${_messages.length}');
                          } else {
                            print('🔄 ChatDetailPage - Message already exists, skipping');
                          }
                        });
                        _scrollToBottom();
                      } else {
                        print('❌ ChatDetailPage - Message does not belong to current chat');
                      }
                    }
                  },
                ),
              ],
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading && _isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is MessagesLoaded && state.chatId == widget.chat.id) {
                    // Update local messages list with loaded messages
                    if (_isLoading) {
                      _messages = List.from(state.messages);
                      _isLoading = false;
                    }
                    
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMe = _isCurrentUser(message.sender);
                        final selfInitials = _getInitials(_getCurrentUserName());
                        final otherInitials = _getInitials(_getOtherUserName());
                        return MessageBubble(
                          message: message,
                          isMe: isMe,
                          senderLabel: isMe ? 'You' : _getOtherUserName(),
                          avatarText: isMe ? selfInitials : otherInitials,
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${state.message}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChatBloc>().add(LoadMessages(widget.chat.id));
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Default case - show messages if we have any, otherwise show "No messages"
                  if (_messages.isNotEmpty) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMe = _isCurrentUser(message.sender);
                        final selfInitials = _getInitials(_getCurrentUserName());
                        final otherInitials = _getInitials(_getOtherUserName());
                        return MessageBubble(
                          message: message,
                          isMe: isMe,
                          senderLabel: isMe ? 'You' : _getOtherUserName(),
                          avatarText: isMe ? selfInitials : otherInitials,
                        );
                      },
                    );
                  }
                  
                  return const Center(
                    child: Text('No messages yet'),
                  );
                },
              ),
            ),
          ),
          MessageInput(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  String _getOtherUserName() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final currentId = authState.user.id;
      if (widget.chat.user1.id == currentId) return widget.chat.user2.name;
      if (widget.chat.user2.id == currentId) return widget.chat.user1.name;
    }
    return widget.chat.user1.name;
  }

  String _getCurrentUserName() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      return authState.user.name;
    }
    return 'You';
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  bool _isCurrentUser(User sender) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      return sender.id == authState.user.id;
    }
    return false;
  }

  User? _getCurrentUser() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      return authState.user;
    }
    return null;
  }
}
