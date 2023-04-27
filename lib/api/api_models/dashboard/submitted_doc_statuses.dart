import 'package:flutter/cupertino.dart';

class SubmissionsStatuses {
  String status;
  double total, tax, percentage;
  int count;

  SubmissionsStatuses(
      {required this.status,
      required this.total,
      required this.tax,
      required this.percentage,
      required this.count});

  Map<String, dynamic> toJson(SubmissionsStatuses statuses) {
    return {
      'status': statuses.status,
      'total': statuses.total,
      'tax': statuses.tax,
      'count': statuses.count,
      'percentage': statuses.percentage,
    };
  }

  factory SubmissionsStatuses.fromJson(Map<String, dynamic> json) {
    return SubmissionsStatuses(
        status: json['status'],
        total: json['total'],
        tax: json['tax'],
        percentage: json['percentage'],
        count: json['count']);
  }
}
