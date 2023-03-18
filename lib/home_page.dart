import 'package:flutter/material.dart';
import 'package:itbook/itbook_service.dart';

import 'book_card.dart';
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
  NewArrivalResp? _resp;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_resp == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      var books = _resp!.books;
      return ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(book: books[index]);
        },
      );
    }
  }

  Future<void> loadData() async {
    final resp = await getNewArrivals();
    setState(() {
      _resp = resp;
    });
  }
}


