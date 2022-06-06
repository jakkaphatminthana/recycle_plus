class SponsorModel {
  final String image;

  SponsorModel({
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'image' : image,
  };

  static SponsorModel formJson(Map<String, dynamic> json) => SponsorModel(
        image: json['image'],
      );
}