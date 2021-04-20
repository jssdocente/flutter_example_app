import 'package:intl/intl.dart';
import 'duration_extensions.dart';
import 'time_ago.dart';

extension DateTimeTimeExtension on DateTime {

  /// Format DateTime to custom mask
  format(String dateMask, [lang = 'es-ES']) {
    var formatter = new DateFormat(dateMask, lang);
    return formatter.format(this);
  }

  e(f) {
    return this.format('E').substring(0, 1).toUpperCase() +
        this.format(f ?? '');
  }

  dateFormat(String mask, [lang = 'es-ES']) => DateFormat(mask, lang);

  /// Adds this DateTime and Duration and returns the sum as a new DateTime object.
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts the Duration from this DateTime returns the difference as a new DateTime object.
  DateTime operator -(Duration duration) => subtract(duration);

  /// Returns only year, month and day
  DateTime get date => DateTime(year, month, day);

  /// Returns only the time
  //Duration get timeOfDay => hour.hours + minute.minutes + second.seconds;

  toTimeString() => DateFormat.Hms().format(this);
  toDateString() => DateFormat.yMd().format(this);

  addDays(int value) => this.add(Duration(days: value));
  addHours(int value) => this.add(Duration(hours: value));
  addMinutes(int value) => this.add(Duration(minutes: value));
  addMonths(int value) => DateTime(this.year, this.month + value, this.day,
      this.hour, this.minute, this.second);
  addYears(int value) => DateTime(this.year + value, this.month, this.day,
      this.hour, this.minute, this.second);

  bool isLeapYear() {
    int value = this.year;
    return value % 400 == 0 || (value % 4 == 0 && value % 100 != 0);
  }

  bool between(DateTime a, DateTime b) {
    var t = this.toDateTimeSql();
    return (t.compareTo(a.toDateTimeSql()) == 1) &&
        (t.compareTo(b.toDateTimeSql()) == -1);
  }

  String timeAgo({String lang}) {
    int timeStamp = this.millisecondsSinceEpoch;
    lang = lang ?? Intl.defaultLocale;
    Language lg = Language.ENGLISH;
    if (lang.indexOf('es') >= 0) lg = Language.SPANISH;
    return TimeAgo.getTimeAgo(timeStamp, language: lg);
  }

  DateTime toDate() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime toTime() {
    return DateTime(0, 0, 0, this.hour, this.minute, this.second);
  }

  String toTimeSql() {
    return this.toIso8601String().substring(11, 19);
  }

  String toDateTimeSql() {
    return this.toIso8601String().substring(0, 19).replaceAll('T', ' ');
  }

  String toDateSql() {
    return this.toIso8601String().substring(0, 10);
  }

  DateTime endOfHour([int hour]) {
    return DateTime(this.year, this.month, this.day, hour ?? this.hour, 59, 0);
  }

  DateTime startOfHour([int hour]) {
    return DateTime(this.year, this.month, this.day, hour ?? this.hour, 0, 0);
  }

  DateTime startOfDay() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime endOfDay() {
    return DateTime(this.year, this.month, this.day, 23, 59, 00);
  }

  ///  Obtem o primeiro dia da semana {first indica o primeiro dia da semana}
  DateTime startOfWeek({first = 1}) {
    return this.add(Duration(days: -(this.weekday - first)));
  }

  /// Obtem o ultimo dia da semana
  DateTime endOfWeek({first = 1}) {
    return this.add(Duration(days: (6 + first) - this.weekday));
  }

  DateTime startOfMonth() {
    return DateTime(this.year, this.month, 1);
  }

  double get hours => this.hour + ((this.minute / 60));

  DateTime endOfMonth() {
    return DateTime(this.year, this.month + 1, 0);
  }

  int lastDayOfMonth() {
    return endOfMonth().day;
  }

  DateTime startOfYear() {
    return DateTime(this.year, 1, 1);
  }

  DateTime endOfYear() {
    return DateTime(this.year, 12, 31);
  }

  DateTime toIso8601StringDate({format = 'yyyy-MM-dd'}) {
    return this.format(format);
  }

  DateTime dayBefore() {
    return this.add(Duration(days: -1));
  }

  DateTime dayAfter() {
    return this.add(Duration(days: 1));
  }

  static DateTime yesterday() {
    return today().addDays(-1);
  }

  static DateTime tomorrow() {
    return today().addDays(1);
  }

  static DateTime today() {
    DateTime d = DateTime.now();
    return DateTime(d.year, d.month, d.day);
  }

  static DateTime fromUnixEpoc(int timeUnixEpoc) {
    return new DateTime.fromMillisecondsSinceEpoch(timeUnixEpoc, isUtc: true);
  }



  /// Returns a range of dates to [to], exclusive start, inclusive end
  /// ```dart
  /// final start = DateTime(2019);
  /// final end = DateTime(2020);
  /// start.to(end, by: const Duration(days: 365)).forEach(print); // 2020-01-01 00:00:00.000
  /// ```
  Iterable<DateTime> to(DateTime to, {Duration by = const Duration(days: 1)}) sync* {
    if (isAtSameMomentAs(to)) return;

    if (isBefore(to)) {
      var value = this + by;
      yield value;

      var count = 1;
      while (value.isBefore(to)) {
        value = this + (by * ++count);
        yield value;
      }
    } else {
      var value = this - by;
      yield value;

      var count = 1;
      while (value.isAfter(to)) {
        value = this - (by * ++count);
        yield value;
      }
    }
  }



  DateTime copyWith({
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

/// credits: https://github.com/jogboms/time.dart
extension NumTimeExtension<T extends num> on T {
  /// Returns a Duration represented in weeks
  Duration get weeks => days * DurationTimeExtension.daysPerWeek;

  /// Returns a Duration represented in days
  Duration get days => milliseconds * Duration.millisecondsPerDay;

  /// Returns a Duration represented in hours
  Duration get hours => milliseconds * Duration.millisecondsPerHour;

  /// Returns a Duration represented in minutes
  Duration get minutes => milliseconds * Duration.millisecondsPerMinute;

  /// Returns a Duration represented in seconds
  Duration get seconds => milliseconds * Duration.millisecondsPerSecond;

  /// Returns a Duration represented in milliseconds
  Duration get milliseconds => Duration(
      microseconds: (this * Duration.microsecondsPerMillisecond).toInt());

  /// Returns a Duration represented in microseconds
  Duration get microseconds =>
      milliseconds ~/ Duration.microsecondsPerMillisecond;

  /// Returns a Duration represented in nanoseconds
  Duration get nanoseconds =>
      microseconds ~/ DurationTimeExtension.nanosecondsPerMicrosecond;
}