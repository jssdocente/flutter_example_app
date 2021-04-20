import 'dart:math' as math;
import 'package:intl/intl.dart';

extension IntegerExtension on int {
  toStrZero(int count) {
    return this.toString().padLeft(count, '0');
  }

  int min(int value) {
    return (this < value) ? value : this;
  }

  int max(int value) {
    return (this > value) ? value : this;
  }

}

/// https://api.flutter.dev/flutter/intl/NumberFormat-class.html
/// [NumberFormat]
extension DoubleExtension on double {
  String format(String mask, {String lang}) {
    final oCcy = new NumberFormat(mask, lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  String format2d({String lang}) {
    final oCcy = new NumberFormat("#,###,###,##0.00", lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  String format3d({String lang}) {
    final oCcy = new NumberFormat("#,###,###,##0.000", lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  String format1d({String lang}) {
    final oCcy = new NumberFormat("#,###,###,##0.0", lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  String format0d({String lang}) {
    final oCcy = new NumberFormat("#,###,###,###", lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  num min(num value) {
    return (this < value) ? value : this;
  }

  num max(num value) {
    return (this > value) ? value : this;
  }

  num roundTo(int decs) {
    if (decs < 0) decs = -decs;
    int fac = math.pow(10, decs);
    return (this * fac).round() / fac;
  }

  fraction() {
    return this - this.truncate();
  }

  bool odd(num value) {
    return (value % 2) == 1;
  }

  double simpleRoundTo([int digit = -2]) {
    double result;
    double lfactor;
    if (digit > 0) digit = -digit;
    lfactor = math.pow(10.0, digit);
    if (this < 0)
      result = ((this / lfactor).truncate() - 0.5) * lfactor;
    else
      result = ((this / lfactor) + 0.5).truncate() * lfactor;
    return result;
  }
}

extension NumExtension on num {
  String format(String mask, {String lang}) {
    final oCcy = new NumberFormat(mask, lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  String format2d({String lang}) {
    final oCcy = new NumberFormat("#,###,###,##0.00", lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  String format1d({String lang}) {
    final oCcy = new NumberFormat("#,###,###,##0.0", lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  String format0d({String lang}) {
    final oCcy = new NumberFormat("#,###,###,###", lang ?? Intl.defaultLocale);
    return oCcy.format(this);
  }

  num min(num value) {
    return (this < value) ? value : this;
  }

  num max(num value) {
    return (this > value) ? value : this;
  }

  num roundTo(int decs) {
    if (decs < 0) decs = -decs;
    int fac = math.pow(10, decs);
    return (this * fac).round() / fac;
  }

  fraction() {
    return this - this.truncate();
  }

  bool odd(num value) {
    return (value % 2) == 1;
  }

  num simpleRoundTo([int digit = -2]) {
    num result;
    num lfactor;
    if (digit > 0) digit = -digit;
    lfactor = math.pow(10.0, digit);
    if (this < 0)
      result = ((this / lfactor).truncate() - 0.5) * lfactor;
    else
      result = ((this / lfactor) + 0.5).truncate() * lfactor;
    return result;
  }
}
