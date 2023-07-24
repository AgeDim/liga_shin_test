class Data {
  String id;
  String pageTitle;
  String content;
  String? image;
  String? thumb;
  String tvAddress;
  String tvCoords;
  String? tvTrass;
  String? tvDistance;
  String? tvPhonetv;

  Data({
    required this.id,
    required this.pageTitle,
    required this.content,
    this.image,
    this.thumb,
    required this.tvAddress,
    required this.tvCoords,
    required this.tvTrass,
    required this.tvDistance,
    required this.tvPhonetv,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      pageTitle: json['pagetitle'],
      content: json['content'],
      image: json['image'],
      thumb: json['thumb'],
      tvAddress: json['tv.address'],
      tvCoords: json['tv.coords'],
      tvTrass: json['tv.trass'],
      tvDistance: json['tv.distance'],
      tvPhonetv: json['tv.phonetv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pagetitle': pageTitle,
      'content': content,
      'image': image,
      'thumb': thumb,
      'tv.address': tvAddress,
      'tv.coords': tvCoords,
      'tv.trass': tvTrass,
      'tv.distance': tvDistance,
      'tv.phonetv': tvPhonetv,
    };
  }

  @override
  String toString() {
    return 'Data{id: $id, pagetitle: $pageTitle, '
        'content: $content, image: $image, '
        'thumb: $thumb, tv.address: $tvAddress, '
        'tv.coords: $tvCoords, tv.trass: $tvTrass, '
        'tv.distance: $tvDistance, tv.phonetv: $tvPhonetv}';
  }
}
