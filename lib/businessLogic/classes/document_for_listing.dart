class DocumentForListing {
  String type; // purchases or sales
  int id;
  int registrationId;
  String ownerName;
  DateTime submissionDate;
  int totalAmount;
  String status;

  DocumentForListing(
      { required this.type,
      required this.id,
      required this.registrationId,
      required this.ownerName,
      required this.submissionDate,
      required this.totalAmount,
      required this.status});
}