import 'package:intl/intl.dart';
import 'duration_extensions.dart';
import 'time_ago.dart';

// extension ListExtension<num,T> on List {
//
//   num sum<num,T>(num Function(T) fn) {
//     return this.map<num>(fn).fold<num>(0,(num a, num b) => a + b);
//   }
//
//   double sumd<double,T>(double Function(T) fn) {
//     double x = 0.0;
//     return this.map<double>(fn).fold(0,(double a, double b) => a + b);
//   }
// }

extension IterableExtension on Iterable {

  Map<Y, List<T>> groupBy<T, Y>(Y Function(T) fn) {
    return Map.fromIterable(this.map<Y>(fn).toSet(), value: (i) => this.where((v) => fn(v) == i).toList());
  }

  Map<Y, num> groupByAndSum<T, Y>(Y Function(T) fn, num Function(T) fnsum) {
    return Map.fromIterable(this.map<Y>(fn).toSet(), value: (i) => this.where((v) => fn(v) == i).sum(fnsum));
  }

  num sum<T>(num Function(T) fn) {
    num xdefault = 0;
    return this.map<num>(fn).fold<num>(xdefault,(num a, num b) => a + b);
  }

}


