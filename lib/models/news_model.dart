class NewsModel {
  String? id;
  String? image;
  String? header;
  String? subtitle;
  String? content;

  NewsModel({
    String? id,
    String? image,
    String? header,
    String? subtitle,
    String? content,
  });

  factory NewsModel.fromMap(Map<String, dynamic>? news) {
    String id = news?['id'];
    String image = news?['image'];
    String header = news?['header'];
    String subtitle = news?['subtitle'];
    String content = news?['content'];
    return NewsModel(
      id: id,
      image: image,
      header: header,
      subtitle: subtitle,
      content: content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image' : image,
      'header' : header,
      'subtitle' : subtitle,
      'content' : content,
    };
  }
}
