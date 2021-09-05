class Post {
  late DateTime date;
  late String imageURL;
  late int quantity;
  late double latitude;
  late double longitude;

  Post({required this.date, required this.imageURL, required this.quantity, required this.latitude, required this.longitude});

  String printWeekDay(bool shortHand) {
    if (shortHand) {
      switch (date.weekday) {
        case 1:
          return "Mon";
          break;
        case 2:
          return "Tue";
          break;
        case 3:
          return "Wed";
          break;
        case 4:
          return "Thu";
          break;
        case 5:
          return "Fri";
          break;
        case 6:
          return "Sat";
          break;
        case 7:
          return "Sun";
          break;
      }
    }
    switch (date.weekday) {
      case 1:
        return "Monday";
        break;
      case 2:
        return "Tuesday";
        break;
      case 3:
        return "Wednesday";
        break;
      case 4:
        return "Thursday";
        break;
      case 5:
        return "Friday";
        break;
      case 6:
        return "Saturday";
        break;
      case 7:
        return "Sunday";
        break;
    }
    return "";
  }

  String printDate() {
    String month = "";
    switch (date.month) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sep";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }
    return '$month ${date.day}, ${date.year}';
  }
}