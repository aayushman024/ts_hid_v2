class ProfileModel {
  String? employeeId;
  String? username;
  String? email;
  String? region;
  String? technology;
  String? role;
  String? country;

  ProfileModel(
      {this.employeeId,
        this.username,
        this.email,
        this.region,
        this.technology,
        this.role,
        this.country});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    username = json['username'];
    email = json['email'];
    region = json['region'];
    technology = json['technology'];
    role = json['role'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['region'] = this.region;
    data['technology'] = this.technology;
    data['role'] = this.role;
    data['country'] = this.country;
    return data;
  }
}
