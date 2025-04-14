import 'package:flutter/material.dart';
import 'package:scantfacecamera/home.dart';

class RegisterName extends StatefulWidget {
  const RegisterName({super.key});

  @override
  State<RegisterName> createState() => _RegisterNameState();
}

class _RegisterNameState extends State<RegisterName> {
  final TextEditingController _nameController = TextEditingController();

  void _onContinuePressed() {
    String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home(name: name)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tên")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nhập tên của bạn",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onContinuePressed,
              child: const Text("Tiếp tục"),
            ),
          ],
        ),
      ),
    );
  }
}
