class ApiResponse {
  List<Data>? data;

  ApiResponse({this.data});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? t;
  String? s;
  String? p;
  String? P;
  String? c;
  String? o;
  String? h;
  String? l;
  String? b;
  String? a;

  Data(
      {this.t,
      this.s,
      this.p,
      this.P,
      this.c,
      this.o,
      this.h,
      this.l,
      this.b,
      this.a});

  Data.fromJson(Map<String, dynamic> json) {
    t = json['T'];
    s = json['s'];
    p = json['p'];
    P = json['P'];
    c = json['c'];
    o = json['o'];
    h = json['h'];
    l = json['l'];
    b = json['b'];
    a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['T'] = this.t;
    data['s'] = this.s;
    data['p'] = this.p;
    data['P'] = this.P;
    data['c'] = this.c;
    data['o'] = this.o;
    data['h'] = this.h;
    data['l'] = this.l;
    data['b'] = this.b;
    data['a'] = this.a;
    return data;
  }
}
