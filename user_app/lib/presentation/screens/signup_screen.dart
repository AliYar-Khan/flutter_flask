import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      // Process signup logic here
      if (kDebugMode) {
        print('Signup Successful');
      }
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
