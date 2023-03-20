import 'package:flutter/material.dart';
import 'package:itbook/itbook_service.dart';

import 'book_widgets.dart';
import 'models.dart';

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
      bodyWidget = _buildBookListView();
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

  Widget _buildBookListView() {
    List<Book> books = _books!;

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCard(book: books[index]);
      },
    );
  }

  Future<void> loadData(String query) async {
    final resp = await search(query);
    setState(() {
      _books = resp.books;
    });
  }
}

