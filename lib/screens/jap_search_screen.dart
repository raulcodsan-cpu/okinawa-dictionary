import 'package:flutter/material.dart';
import 'package:uchinaguchi_jisho/data/database_helper.dart';

class JapSearchScreen extends StatefulWidget {
  const JapSearchScreen({super.key});

  @override
  State<JapSearchScreen> createState() => _JapSearchScreenState();
}

class _JapSearchScreenState extends State<JapSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _loadedQuery = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('標準語➞うちなぐち')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white60,
                  filled: true,
                  focusColor: Colors.white,
                ),
                onChanged: (value) async {
                  final result = await DatabaseHelper.instance.searchWords(
                    value,
                  );
                  setState(() {
                    _loadedQuery = result;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _loadedQuery.length,
                itemBuilder: (context, index) {
                  final word = _loadedQuery[index];
                  return ListTile(
                    title: Text(word['okinawan'] ?? ''),
                    subtitle: Text(word['japanese'] ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
