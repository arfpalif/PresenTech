class SplitTime {
  String formatClockInOut(String clockIn, String clockOut) {
    clockIn = clockIn.split('+').first;
    clockOut = clockOut.split('+').first;
    return clockIn.substring(0, 5) + ' - ' + clockOut.substring(0, 5);
  }
}
