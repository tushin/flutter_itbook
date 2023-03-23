# it book codelab

## 디펜던시 추가
```yaml
dependencies:  
  flutter:  
    sdk: flutter  
  
  cupertino_icons: ^1.0.2  
  http: ^0.13.5 # http 디펜던시 추가 
```

## 뼈대 만들기
```dart 
// main.dart
import 'package:flutter/material.dart';  
  
import 'home_page.dart';  

void main() {  
  runApp(const MyApp());  
}  
  
class MyApp extends StatelessWidget {  
  const MyApp({Key? key}) : super(key: key);  
  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      theme: ThemeData(  
        primarySwatch: Colors.pink,  
      ),  
      home: const HomePage(),  
    );  
  }  
}
```

```dart
// home_page.dart
import 'package:flutter/material.dart';  
  
class HomePage extends StatelessWidget {  
  const HomePage({Key? key}) : super(key: key);  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: const Text("IT books"),  
      ),  
      body: ListView(  
        children: const [  
          Text('book1'),  
          Text('book2'),  
        ],  
      ),  
    );  
  }  
}
```

## http 요청해보기 
```dart
// itbook_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> getNewArrivals() async {
  var dataURL = Uri.parse('https://api.itbook.store/1.0/new');
  http.Response response = await http.get(dataURL);
  var json = jsonDecode(response.body);
  return json;
}
```

### 모델 작성
```dart
// models.dart
class Book {
  final String title;
  final String subtitle;
  final String isbn13;
  final String price;
  final String image;
  final String url;

  Book(this.title, this.subtitle, this.isbn13, this.price, this.image, this.url);
}

class NewArrivalResp {
  final int total;
  final List<Book> books;

  NewArrivalResp(this.total, this.books);
}
```

## json 역직렬화 해보기
```dart
class Book {
  final String title;
  final String subtitle;
  final String isbn13;
  final String price;
  final String image;
  final String url;

  Book(this.title, this.subtitle, this.isbn13, this.price, this.image, this.url);

  static Book fromJson(Map<String, dynamic> json) {
    return Book(
      json['title'],
      json['subtitle'],
      json['isbn13'],
      json['price'],
      json['image'],
      json['url'],
    );
  }
}

class NewArrivalResp {
  final int total;
  final List<Book> books;

  NewArrivalResp(this.total, this.books);

  static NewArrivalResp fromJson(Map<String, dynamic> json) {
    final total = int.parse(json['total']);
    final books = List<Book>.from(json['books']
        .map((model) => Book.fromJson(model)));
    return NewArrivalResp(total, books);
  }
}
```

### api 에 역직렬화 적용
```dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

Future<NewArrivalResp> getNewArrivals() async {
  var dataURL = Uri.parse('https://api.itbook.store/1.0/new');
  http.Response response = await http.get(dataURL);
  var json = jsonDecode(response.body);
  return NewArrivalResp.fromJson(json);
}
```

## HomePage 작성 

HomePage 위젯을 stateful 로 변경 

데이터 로드 해서 그리기 
```dart
// home_page.dart
class _HomePageState extends State<HomePage> {
  var _books;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = _books ?? <Book>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text("IT books"),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Text(books[index].title);
        },
      ),
    );
  }

  Future<void> loadData() async {
    final resp = await getNewArrivals();
    setState(() {
      _books = resp.books;
    });
  }
}
```

로딩화면 그리기 
```dart
// home_page.dart
class _HomePageState extends State<HomePage> {
  var _books;
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
      List<Book> books = _books!;
      bodyWidget = ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Text(books[index].title);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("IT books"),
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
```

북카드 꾸미기 
```dart
import 'package:flutter/material.dart';

import 'models.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
        child: Row(
          children: [
            SizedBox(
                width: 140,
                child: Image.network(book.image)
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.price,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 페이지 네비게이션 
```dart
// search_page.dart
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

```dart
// home_page.dart
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
          ),
        ],
      ),
      body: bodyWidget,
    );
```