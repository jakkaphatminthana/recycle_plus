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
  String id;
  final String header;
  final String subtitle;
  final String image;
  final String content;

  NewsModel({
    this.id = '',
    required this.header,
    required this.subtitle,
    required this.image,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'id' : id,
    'header' : header,
    'subtitle' : subtitle,
    'image' : image,
    'content' : content,
  };

  static NewsModel formJson(Map<String, dynamic> json) => NewsModel(
        id: json['id'],
        image: json['image'],
        header: json['header'],
        subtitle: json['subtitle'],
        content: json['content'],
      );
}
