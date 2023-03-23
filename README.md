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

Future<NewArrivalResp> getNewArrivals2() async {
  var dataURL = Uri.parse('https://api.itbook.store/1.0/new');
  http.Response response = await http.get(dataURL);
  var json = jsonDecode(response.body);
  return NewArrivalResp.fromJson(json);
}
```