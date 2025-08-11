import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart'; // <-- Import your routeObserver here
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_list_item.dart';
import '../../domain/entities/chat.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with RouteAware {
  List<User> _users = [];
  List<Chat> _chats = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    // Initial load
    context.read<ChatBloc>().add(LoadChats());
    context.read<ChatBloc>().add(LoadUsers());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when returning to this page from another page
    print('🔄 ChatListPage - didPopNext: Reloading chats and users');
    context.read<ChatBloc>().add(LoadChats());
    context.read<ChatBloc>().add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    // ... your existing build method remains unchanged ...
    // (copy everything from your current build method here)
    // No changes needed to the rest of your code!
    // ...
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Chat App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Start chatting with friends',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('All Chats'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('New Chat'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New chat feature coming soon!')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () async {
                print('🚀 ChatListPage - Sign out button tapped');
                Navigator.pop(context);
                
                // Trigger sign out event
                print('🚀 ChatListPage - Dispatching SignOutEvent');
                context.read<AuthBloc>().add(SignOutEvent());
                
                // Wait a bit for the sign out to complete
                await Future.delayed(const Duration(milliseconds: 500));
                
                print('🚀 ChatListPage - Navigating to sign in page');
                // Navigate to sign in and clear all routes
                Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Authentication'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/signin');
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Product Home'),
              onTap: () {
                print('🚀 ChatListPage - Product Home button tapped');
                Navigator.pop(context);
                print('🚀 ChatListPage - Navigating to /home route');
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                print('🔐 ChatListPage: User authenticated, refreshing chats and users...');
                context.read<ChatBloc>().add(LoadChats());
                context.read<ChatBloc>().add(LoadUsers());
              } else if (state is Unauthenticated) {
                print('🔐 ChatListPage: User unauthenticated');
                // Navigate to sign in when user logs out
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
                }
              }
            },
          ),
        ],
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            print('🔍 ChatListPage - Current state: ${state.runtimeType}');
            print('🔍 ChatListPage - Local users count: ${_users.length}');
            print('🔍 ChatListPage - Local chats count: ${_chats.length}');
            // Update local state based on bloc state
            if (state is UsersLoaded) {
              _users = state.users;
              print('🔍 ChatListPage - Users loaded: ${_users.length} users');
              for (int i = 0; i < _users.length; i++) {
                print('🔍 ChatListPage - User $i: "${_users[i].name}" (${_users[i].email})');
              }
            } else if (state is ChatsLoaded) {
              _chats = state.chats;
              print('🔍 ChatListPage - Chats loaded: ${_chats.length} chats');
              for (int i = 0; i < _chats.length; i++) {
                print('🔍 ChatListPage - Chat $i: ID="${_chats[i].id}", User1="${_chats[i].user1.name}", User2="${_chats[i].user2.name}"');
              }
            }
            
            if (state is ChatLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UsersLoaded || state is ChatsLoaded || _chats.isNotEmpty || _users.isNotEmpty) {
              return Column(
                children: [
                  // Top header with search and stories/status row
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5AA2F7), Color(0xFF4C84F3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar (non-functional placeholder to preserve behavior)
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Search feature coming soon!')),
                            );
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Search',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Icon(Icons.mic_none, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 86,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            itemCount: _users.isEmpty ? 1 : _users.length + 1,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              // First item: "My status"
                              if (index == 0) {
                                return SizedBox(
                                  width: 70,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 26,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.blue.shade50,
                                              child: const Icon(Icons.person, color: Colors.blue),
                                            ),
                                          ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.add, size: 14, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'My status',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                );
                              }
                              final user = _users[index - 1];
                              final name = user.name;
                              return SizedBox(
                                width: 70,
                                child: Column(
                                  children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [Colors.white, Colors.white24],
                                      ),
                                      border: Border.all(color: Colors.white24, width: 1),
                                    ),
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            _getInitials(name),
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    name.split(' ').first,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Chat List
                  Expanded(
                    child: _chats.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No chats yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start a conversation to see chats here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              context.read<ChatBloc>().add(LoadChats());
                              context.read<ChatBloc>().add(LoadUsers());
                            },
                            child: ListView.builder(
                              itemCount: _chats.length,
                              itemBuilder: (context, index) {
                                final chat = _chats[index];
                                return ChatListItem(
                                  chat: chat,
                                  onTap: ()  {
                                    // Debug print to see what chat is being passed
                                    print('🔍 ChatListPage - Tapping chat: ${chat.id}');
                                    print('🔍 ChatListPage - Full chat object: $chat');
                                    // Navigate to chat detail page
                                    Navigator.pushNamed(
                                      context,
                                      '/chat-detail',
                                      arguments: chat,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            } else if (state is ChatError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ChatBloc>().add(LoadChats());
                        context.read<ChatBloc>().add(LoadUsers());
                      },
                      child: const Text('Retry'),
                    ),
                    const SizedBox(height: 16),
                    if (state.message.contains('AuthFailure') || state.message.contains('Unauthorized'))
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Sign In'),
                      ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text('No chats available'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show options for new chat or other actions
          _showOptionsDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chat Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('New Chat'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement new chat functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New chat feature coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out'),
                onTap: () async {
                  print('🚀 ChatListPage - Sign out button tapped (dialog)');
                  Navigator.pop(context);
                  
                  // Trigger sign out event
                  print('🚀 ChatListPage - Dispatching SignOutEvent (dialog)');
                  context.read<AuthBloc>().add(SignOutEvent());
                  
                  // Wait a bit for the sign out to complete
                  await Future.delayed(const Duration(milliseconds: 500));
                  
                  print('🚀 ChatListPage - Navigating to sign in page (dialog)');
                  // Navigate to sign in and clear all routes
                  Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Authentication'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/signin');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
