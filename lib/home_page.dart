import 'package:flutter/material.dart';
import 'package:itbook/itbook_service.dart';

import 'book_widgets.dart';
import 'models.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IT books"),
      ),
      body: const NewArrivalPage(),
    );
  }
}

class NewArrivalPage extends StatefulWidget {
  const NewArrivalPage({Key? key}) : super(key: key);

  @override
  State<NewArrivalPage> createState() => _NewArrivalPageState();
}

class _NewArrivalPageState extends State<NewArrivalPage> {
  List<Book>? _books;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_books == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return BookListView(books: _books!);
    }
  }

  Future<void> loadData() async {
    final resp = await getNewArrivals();
    setState(() {
      _books = resp.books;
    });
  }
}