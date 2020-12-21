class PoiModel {
  String name;
  String poiid;
  Coordinate coordinate;

  PoiModel({this.name, this.poiid, this.coordinate});

  PoiModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    poiid = json['poiid'];
    coordinate = json['coordinate'] != null ? new Coordinate.fromJson(json['coordinate']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['poiid'] = this.poiid;
    if (this.coordinate != null) {
      data['coordinate'] = this.coordinate.toJson();
    }
    return data;
  }
}

class Coordinate {
  dynamic latitude;
  dynamic longitude;

  Coordinate({this.latitude, this.longitude});

  Coordinate.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
