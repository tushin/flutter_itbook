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
  int? _page;
  int? _total;
  var _isLoading = false;

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
    debugPrint("_buildBookListView");

    List<Book> books = _books!;
    var hasNext = books.length < _total!;

    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        if (!_isLoading) {
          _isLoading = true;
          append();
        }
        debugPrint("maxScrollExtent");
      }
    });

    return ListView.builder(
      controller: scrollController,
      itemCount: books.length + (hasNext ? 1 : 0),
      itemBuilder: (context, index) {
        if (hasNext && index == books.length) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          return BookCard(book: books[index]);
        }
      },
    );
  }

  Future<void> loadData(String query) async {
    final resp = await search(query);
    setState(() {
      _total = resp.total;
      _page = resp.page;
      _books = resp.books;
    });
  }

  Future<void> append() async {
    if (_query != null && _page != null && _books != null) {
      final resp = await(search(_query!, _page! + 1));
      setState(() {
        _page = resp.page;
        _books!.addAll(resp.books);
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
  }
}

