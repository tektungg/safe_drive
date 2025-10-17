class SignInModel {
  int? statusCode;
  Data? data;
  String? message;

  SignInModel({
    this.statusCode,
    this.data,
    this.message,
  });

  SignInModel.fromJson(Map<String, dynamic> json) {
    statusCode = json["status_code"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status_code"] = statusCode;
    if (this.data != null) {
      data["data"] = this.data!.toJson();
    }
    data["message"] = message;

    return data;
  }
}

class Data {
  String? accessToken;
  String? tokenType;
  int? expireIn;
  User? user;

  Data({this.accessToken, this.tokenType, this.expireIn, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json["access_token"];
    tokenType = json["token_type"];
    expireIn = json["expire_in"];
    user = json["user"] != null ? User.fromJson(json["user"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["access_token"] = accessToken;
    data["token_type"] = tokenType;
    data["expire_in"] = expireIn;
    if (user != null) {
      data["user"] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? rtId;
  String? name;
  String? phone;
  String? email;
  String? role;

  User({this.id, this.rtId, this.name, this.phone, this.email, this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    rtId = json["rt_id"];
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
    role = json["role"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["rt_id"] = rtId;
    data["name"] = name;
    data["phone"] = phone;
    data["email"] = email;
    data["role"] = role;
    return data;
  }
}
