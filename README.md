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