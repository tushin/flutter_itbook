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
              Navigator.pushNamed(context, "/search");
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
