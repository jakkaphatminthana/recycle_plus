class SponsorModel {
  final String logo;
  final String name;

  SponsorModel({
    required this.logo,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'logo' : logo,
    'name' : name,
  };

  static SponsorModel formJson(Map<String, dynamic> json) => SponsorModel(
        logo: json['logo'],
        name: json['name'],
      );
}