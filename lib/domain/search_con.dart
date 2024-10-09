class SearchCon {
  String? keyword;
  bool? status;
  Set<int>? categoryId;

  SearchCon(this.keyword, this.status, this.categoryId);

  factory SearchCon.fromJson(Map<String, dynamic> json) => SearchCon(json["keyword"], json["status"], json["categoryId"]);

  Map<String, dynamic> toJson() => {
    "keyword": keyword,
    "status": status,
    "category": categoryId
  };


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchCon &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          status == other.status &&
          categoryId == other.categoryId;

  @override
  int get hashCode =>
      keyword.hashCode ^ status.hashCode ^ categoryId.hashCode;
}