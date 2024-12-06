// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/presentation/providers/auth_provider.dart';
import '../../core/validation/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _onSignup() async {
    if (!_formKey.currentState!.validate()) {
      // Process signup logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all correctly.')),
      );
      return;
    }

    final String address =
        '${_streetController.text.trim()} ${_cityController.text.trim()}, ${_stateController.text.trim()}, ${_zipController.text.trim()}';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.registerUser(
      name: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phone: _phoneController.text.trim(),
      address: address,
    );
    if (!authProvider.isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Please login.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) =>
                      Validators.validateNotEmpty(value, 'Full Name'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: Validators.validateEmail,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: Validators.validatePhoneNumber,
                ),
                TextFormField(
                  controller: _streetController,
                  decoration:
                      const InputDecoration(labelText: 'Street Address'),
                  validator: (value) =>
                      Validators.validateNotEmpty(value, 'Street Address'),
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) =>
                      Validators.validateNotEmpty(value, 'City'),
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: (value) =>
                      Validators.validateNotEmpty(value, 'State'),
                ),
                TextFormField(
                  controller: _zipController,
                  decoration: const InputDecoration(labelText: 'ZIP Code'),
                  validator: (value) =>
                      Validators.validateNotEmpty(value, 'ZIP Code'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onSignup,
                  child: const Text('Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
