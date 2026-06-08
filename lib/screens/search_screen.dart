import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uchinaguchi_jisho/data/database_provider.dart';
import 'package:uchinaguchi_jisho/screens/entry_screen.dart';
import 'package:uchinaguchi_jisho/widgets/search_entry.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _loadedQuery = [];
  Timer? _inputTimer;
  bool _isLoading = false;

  void _onInputChange(String query) {
    List<Map<String, dynamic>> results = [];
    //Check if the timer is active, if is cancel because a new input has been made
    //When using null check operator ??, you can conditionally access the variable with ? (as opposed to !)
    if (_inputTimer?.isActive ?? false) {
      _inputTimer!.cancel();
    }

    //If search bar is empty (cleared), clear results.
    if (query.trim().isEmpty) {
      setState(() {
        _loadedQuery = [];
        _isLoading = false;
      });
      return;
    }

    _inputTimer = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isLoading = true;
      });

      results = await ref.read(databaseProvider.notifier).searchWords(query);

      setState(() {
        _loadedQuery = results;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '沖縄辞典',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 30),
        ),
      ),
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
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white60,
                  filled: true,
                  focusColor: Colors.white,
                ),
                onChanged: _onInputChange,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _loadedQuery.length,
                itemBuilder: (context, index) {
                  final word = _loadedQuery[index];
                  return SearchEntry(
                    word: word,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EntryScreen(word: word),
                      ),
                    ),
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
