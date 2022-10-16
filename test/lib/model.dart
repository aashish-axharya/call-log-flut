class CallModel {
  String table = "callLog";

  int? id;
  String? called_from;
  String? call_site;
  String? called_to;
  String? call_type;
  String? call_date;
  String? call_duration;
  String? call_remarks;

  CallModel({
    this.id,
    this.called_from,
    this.call_site,
    this.called_to,
    this.call_type,
    this.call_date,
    this.call_duration,
    this.call_remarks,
  });

  factory CallModel.fromMap(Map<String, dynamic> json) => CallModel(
        id: json["id"],
        called_from: json["called_from"],
        call_site: json["call_site"],
        called_to: json["called_to"],
        call_type: json["call_type"],
        call_date: json["call_date"],
        call_duration: json["call_duration"],
        call_remarks: json["call_remarks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "called_from": called_from,
        "call_site": call_site,
        "called_to": called_to,
        "call_type": call_type,
        "call_date": call_date,
        "call_duration": call_duration,
        "call_remarks": call_remarks,
      };
}
