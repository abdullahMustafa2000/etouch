import 'package:etouch/api/api_models/dashboard/submitted_doc_statuses.dart';
import 'package:etouch/api/api_models/map_response.dart';
import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';

class DashboardResponse {

  SubmissionsStatuses valid, invalid, cancelled, rejected, submitted;
  List<APIMapResponse> sales, topReceivers, invoiceTypes;

  DashboardResponse(
      {required this.valid,
      required this.invalid,
      required this.cancelled,
      required this.rejected,
      required this.submitted,
      required this.sales,
      required this.topReceivers,
      required this.invoiceTypes});

  Map<String, dynamic> toJson(DashboardResponse response) {
    return {
      'valid' : response.valid,
      'invalid' : response.invalid,
      'cancelled' : response.cancelled,
      'submitted' : response.submitted,
      'sales' : response.sales,
      'topReceivers' : response.topReceivers,
      'invoiceTypes' : response.invoiceTypes,
    };
  }

  static List<APIMapResponse> basicObjList(Map<String, dynamic> json) {
    return (json['invoiceTypes'] as List<APIMapResponse>)
        .map((sale) => APIMapResponse(key: json['key'], value: json['value']))
        .toList();
  }
}
