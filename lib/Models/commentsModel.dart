class CommentsModel {
  int? id;
  String? user;
  String? content;
  String? createdAt;
  int? issue;

  CommentsModel({this.id, this.user, this.content, this.createdAt, this.issue});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    content = json['content'];
    createdAt = json['created_at'];
    issue = json['issue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['issue'] = this.issue;
    return data;
  }
}
