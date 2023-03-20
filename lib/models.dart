class NewArrivalResp {
  final int total;
  final List<Book> books;

  NewArrivalResp(
    this.total,
    this.books,
  );

  static NewArrivalResp fromJson(Map<String, dynamic> json) {
    final total = int.parse(json['total']);
    final books =
        List<Book>.from(json['books'].map((model) => Book.fromJson(model)));
    return NewArrivalResp(total, books);
  }
}

class SearchResp {
  final int total;
  final int page;
  final List<Book> books;

  SearchResp(
    this.total,
    this.page,
    this.books,
  );

  static SearchResp fromJson(Map<String, dynamic> json) {
    final total = int.parse(json['total']);
    final int page = int.parse(json['page']);
    final books =
        List<Book>.from(json['books'].map((model) => Book.fromJson(model)));
    return SearchResp(total, page, books);
  }
}

class Book {
  final String title;
  final String subtitle;
  final String isbn13;
  final String price;
  final String image;
  final String url;

  Book(
      this.title, this.subtitle, this.isbn13, this.price, this.image, this.url);

  Book.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        subtitle = json['subtitle'],
        isbn13 = json['isbn13'],
        price = json['price'],
        image = json['image'],
        url = json['url'];
}
