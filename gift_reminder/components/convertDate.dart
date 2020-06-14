class ConvertDate {
  static String seprateDataAndTime(String dateAndTime) {
    var dateAndTimeArr = dateAndTime.split(" ");
    var date = dateAndTimeArr[0].split("-");
    return "${date[2]}-${date[1]}-${date[0]} ${dateAndTimeArr[1]}";
  }
}
