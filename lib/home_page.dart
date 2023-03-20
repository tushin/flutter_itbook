import 'package:flutter/material.dart';
import 'package:itbook/itbook_service.dart';

import 'book_widgets.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book>? _books;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget bodyWidget;
    if (_books == null) {
      bodyWidget = const Center(child: CircularProgressIndicator());
    } else {
      bodyWidget = BookListView(books: _books!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("IT books"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: bodyWidget,
    );
  }

  Future<void> loadData() async {
    final resp = await getNewArrivals();
    setState(() {
      _books = resp.books;
    });
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textFieldController = TextEditingController();
  String? _query;
  List<Book>? _books;

  @override
  Widget build(BuildContext context) {
    final Widget bodyWidget;
    if (_query == null) {
      bodyWidget = const SizedBox();
    } else if (_books == null) {
      bodyWidget = const Center(child: CircularProgressIndicator());
    } else if (_books!.isEmpty) {
      bodyWidget = const Center(
        child: Text("검색 결과 없음"),
      );
    } else {
      bodyWidget = BookListView(books: _books!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: TextField(
            controller: textFieldController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _query = null;
                    textFieldController.clear();
                  });
                },
              ),
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              _query = value;
              loadData(value);
            },
          ),
        ),
      ),
      body: bodyWidget,
    );
  }

  Future<void> loadData(String query) async {
    final resp = await search(query);
    setState(() {
      _books = resp.books;
    });
  }
}
