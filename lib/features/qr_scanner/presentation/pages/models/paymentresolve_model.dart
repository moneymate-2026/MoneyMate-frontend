class Resolveaccount {
  final String accountid;
  final String handle;
  final String accounttype;
  final String displayname;
  final String image;

  Resolveaccount({
    required this.accountid,
    required this.handle,
    required this.displayname,
    required this.accounttype,
    required this.image,
  });

  factory Resolveaccount.fromJson(Map<String, dynamic> json) {
    return Resolveaccount(
      accountid: json["account_id"],
      handle: json["handle"],
      displayname: json["display_name"],
      accounttype: json["account_type"],
      image: json["photo_url"],
    );
  }
}
