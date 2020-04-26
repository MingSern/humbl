class Formatter {
  static String getTime(Duration duration) {
    var array = duration.toString().split(".").first;
    var time = array.split(":");
    var minutes = duration.inMinutes;
    var seconds = time.last;

    return "$minutes:$seconds";
  }
}
