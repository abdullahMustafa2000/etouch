class DashboardResponse {
  SubmitTypes? valid;
  SubmitTypes? invalid;
  SubmitTypes? cancelled;
  SubmitTypes? rejected;
  SubmitTypes? submitted;
  List<Statistics>? sales;
  List<Statistics>? topReceivers;
  List<Statistics>? invoiceTypes;

  DashboardResponse(
      {this.valid,
      this.invalid,
      this.cancelled,
      this.rejected,
      this.submitted,
      this.sales,
      this.topReceivers,
      this.invoiceTypes});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    valid =
        json['valid'] != null ? SubmitTypes.fromJson(json['valid']) : null;
    invalid = json['invalid'] != null
        ? SubmitTypes.fromJson(json['invalid'])
        : null;
    cancelled = json['cancelled'] != null
        ? SubmitTypes.fromJson(json['cancelled'])
        : null;
    rejected = json['rejected'] != null
        ? SubmitTypes.fromJson(json['rejected'])
        : null;
    submitted = json['submitted'] != null
        ? SubmitTypes.fromJson(json['submitted'])
        : null;
    if (json['sales'] != null) {
      sales = <Statistics>[];
      json['sales'].forEach((v) {
        sales!.add(Statistics.fromJson(v));
      });
    }
    if (json['topReceivers'] != null) {
      topReceivers = <Statistics>[];
      json['topReceivers'].forEach((v) {
        topReceivers!.add(Statistics.fromJson(v));
      });
    }
    if (json['invoiceTypes'] != null) {
      invoiceTypes = <Statistics>[];
      json['invoiceTypes'].forEach((v) {
        invoiceTypes!.add(Statistics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (valid != null) {
      data['valid'] = valid!.toJson();
    }
    if (invalid != null) {
      data['invalid'] = invalid!.toJson();
    }
    if (cancelled != null) {
      data['cancelled'] = cancelled!.toJson();
    }
    if (rejected != null) {
      data['rejected'] = rejected!.toJson();
    }
    if (submitted != null) {
      data['submitted'] = submitted!.toJson();
    }
    if (sales != null) {
      data['sales'] = sales!.map((v) => v.toJson()).toList();
    }
    if (topReceivers != null) {
      data['topReceivers'] = topReceivers!.map((v) => v.toJson()).toList();
    }
    if (invoiceTypes != null) {
      data['invoiceTypes'] = invoiceTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubmitTypes {
  String? status;
  double? total;
  double? tax;
  int? count;
  double? percentage;

  SubmitTypes({this.status, this.total, this.tax, this.count, this.percentage});

  SubmitTypes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = double.parse(json['total'].toString());
    tax = double.parse(json['tax'].toString());
    count = json['count'];
    percentage = double.parse(json['percentage'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total'] = total;
    data['tax'] = tax;
    data['count'] = count;
    data['percentage'] = percentage;
    return data;
  }
}

class Statistics {
  String? key;
  double? value;

  Statistics({this.key, this.value});

  Statistics.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = double.parse(json['value'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
