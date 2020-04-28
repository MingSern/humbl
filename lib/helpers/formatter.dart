class Formatter {
  static String getTime(Duration duration) {
    var array = duration.toString().split(".").first;
    var time = array.split(":");
    var minutes = duration.inMinutes;
    var seconds = time.last;

    return "$minutes:$seconds";
  }

  static String getTimeFromDouble(double value, Duration duration) {
    double maxValue = duration.inMilliseconds.toDouble();
    Duration position = duration * (value / maxValue);
    var array = position.toString().split(".").first;
    var time = array.split(":");
    var minutes = position.inMinutes;
    var seconds = time.last;

    return "$minutes:$seconds";
  }
}
