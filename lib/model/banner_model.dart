class BannerModel{
  final String bannerUri;
  final String queryString;
  String docid;

  BannerModel(this.bannerUri, this.queryString, this.docid);

  BannerModel.fromFirestore(Map<String, dynamic> dataMap, String id) :
    bannerUri = dataMap['URL'],
    queryString = dataMap['KEY'],
    docid = id;
}