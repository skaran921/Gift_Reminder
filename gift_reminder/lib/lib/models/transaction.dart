import 'dart:ffi';

class Transaction {
  int transactionId;
  String name;
  String address;
  Float amount;
  int pageNumber;
  int bookId;
  int adminId;
  DateTime createDate;
  DateTime updateDate;
  String status;
  Transaction(
      {this.transactionId,
      this.name,
      this.address,
      this.adminId,
      this.amount,
      this.bookId,
      this.createDate,
      this.pageNumber,
      this.status,
      this.updateDate});
}
