import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/presentation/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch users only once when the screen is initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : authProvider.users == null || authProvider.users!.isEmpty
              ? const Center(child: Text('No users found.'))
              : ListView.builder(
                  itemCount: authProvider.users!.length,
                  itemBuilder: (context, index) {
                    final user = authProvider.users![index];
                    return ListTile(
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                    );
                  },
                ),
    );
  }
}
