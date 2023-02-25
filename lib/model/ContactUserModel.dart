class ContactUserModel{
  String? name;
  String? mobile;
  String? landline;
  bool? isFavorite;
  String? imagePath;

  ContactUserModel(
      {this.name, this.mobile, this.landline, this.isFavorite, this.imagePath});

  ContactUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    landline = json['landline'];
    isFavorite = json['isFavorite'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['landline'] = this.landline;
    data['isFavorite'] = this.isFavorite;
    data['imagePath'] = this.imagePath;
    return data;
  }
}
