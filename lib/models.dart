class NewArrivalResp {
  final String total;
  final List<Book> books;

  NewArrivalResp(
      this.total,
      this.books,
      );

  static NewArrivalResp fromJson(Map<String, dynamic> json) {
    var total = json['total'];
    var books =
    List<Book>.from(json['books'].map((model) => Book.fromJson(model)));
    return NewArrivalResp(total, books);
  }
}

class Book {
  final String title;
  final String subtitle;
  final String isbn13;
  final String price;
  final String image;
  final String url;

  Book(this.title, this.subtitle, this.isbn13, this.price, this.image,
      this.url);

  Book.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        subtitle = json['subtitle'],
        isbn13 = json['isbn13'],
        price = json['price'],
        image = json['image'],
        url = json['url'];

}
