// class NewsModel {
//   String? id;
//   String? image;
//   String? header;
//   String? subtitle;
//   String? content;

//   NewsModel({
//     String? id,
//     String? image,
//     String? header,
//     String? subtitle,
//     String? content,
//   });

//   factory NewsModel.fromMap(Map<String, dynamic>? news) {
//     String id = news?['id'];
//     String image = news?['image'];
//     String header = news?['header'];
//     String subtitle = news?['subtitle'];
//     String content = news?['content'];
//     return NewsModel(
//       id: id,
//       image: image,
//       header: header,
//       subtitle: subtitle,
//       content: content,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'image': image,
//       'header': header,
//       'subtitle': subtitle,
//       'content': content,
//     };
//   }
// }

// //======================================================================================================
//New template ไปดูใน youtube มา

class NewsModel {
  String? id;
  String? title;
  String? image;
  String? content;

  NewsModel({
    this.id,
    this.image,
    this.title,
    this.content,
  });

  Map<String, dynamic> toJson() => {
    'id' : id,
    'image' : image,
    'title' : title,
    'content' : content,
  };

  static NewsModel formJson(Map<String, dynamic> json) => NewsModel(
        id: json['id'],
        image: json['image'],
        title: json['title'],
        content: json['content'],
      );
}
