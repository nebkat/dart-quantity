part of number;

/// The abstract base class for all Number types.
///
abstract class Number implements Comparable<dynamic> {
  const Number.constant();
  Number();

  // Abstract operators

  /// Two Numbers will be equal when the represented values are equal,
  /// even if the Number subtypes are different.
  ///
  bool operator ==(dynamic obj);

  /// The hashcodes for two Numbers will be equal when the represented values are equal,
  /// even if the Number subtypes are different.
  ///
  /// Additionally, Numbers having integer values will have the same hashcode as
  /// the corresponding dart:core `int`.
  ///
  int get hashCode;

  Number operator +(dynamic addend);
  Number operator -();
  Number operator -(dynamic subtrahend);
  Number operator *(dynamic multiplicand);
  Number operator /(dynamic divisor);
  Number operator ~/(dynamic divisor);
  Number operator %(dynamic divisor);

  Number operator ^(dynamic exponent);

  bool operator >(dynamic obj);
  bool operator >=(dynamic obj);
  bool operator <(dynamic obj);
  bool operator <=(dynamic obj);

  // Mirror num's abstract properties
  bool get isFinite => !isInfinite;
  bool get isInfinite;
  bool get isNaN;
  bool get isNegative;

  /// Returns minus one, zero or plus one depending on the sign and numerical value of the number.
  ///
  /// Returns minus one if the number is less than zero, plus one if the number is greater than zero,
  /// and zero if the number is equal to zero. Returns NaN if the number is NaN.
  ///
  /// Returns an `int` if this Number's value is an integer, a `double` otherwise.
  ///
  num get sign {
    if (isNaN) return double.NAN;
    if (isNegative) return isInteger ? -1 : -1.0;
    if (this == 0) return isInteger ? 0 : 0.0;
    return isInteger ? 1 : 1.0;
  }

  // Mirror num's abstract methods

  /// Returns the absolute value of this Number.
  Number abs();

  /// Returns the least Number having integer components no smaller than this Number.
  Number ceil();

  /// Returns this num clamped to be in the range lowerLimit-upperLimit.
  ///
  /// The comparison is done using compareTo and therefore takes -0.0 into account.
  /// This also implies that double.NAN is treated as the maximal double value.
  ///
  /// `lowerLimit` and `upperLimit` are expected to be `num` or `Number' objects.
  ///
  Number clamp(dynamic lowerLimit, dynamic upperLimit);

  /// Returns the greatest Number with an integer value no greater than this Number.
  ///
  /// If this is not finite (NaN or infinity), throws an UnsupportedError.
  ///
  Number floor();

  /// Returns the remainder of the truncating division of this Number by `divisor`.
  ///
  /// The result r of this operation satisfies: this == (this ~/ other) * other + r.
  /// As a consequence the remainder r has the same sign as the [operator /(divisor)].
  ///
  Number remainder(dynamic divisor);

  /// Returns the integer Number closest to this Number.
  ///
  /// Rounds away from zero when there is no closest integer:
  /// (3.5).round() == 4 and (-3.5).round() == -4.
  ///
  /// If this is not finite (NaN or infinity), throws an UnsupportedError.
  ///
  Number round();

  int toInt();
  double toDouble();
  Number truncate();

  // Add some of our own
  Number reciprocal();

  /// Subclasses must support dart:json for stringify.
  ///
  Map toJson();

  /// True if the Number represents an integer value.
  ///
  /// Note that the Number does not have to be of type
  /// Integer for this to be true.
  ///
  bool get isInteger;

  /// Compares this Number to another Number by comparing values.
  ///
  /// [n2] is expected to be a num or Number.  If it is not it will
  /// be considered to have a value of 0.
  ///
  @override
  int compareTo(dynamic n2) {
    if (n2 is Number) return Comparable.compare(this.toDouble(), n2.toDouble());
    if (n2 is num) return Comparable.compare(this.toDouble(), n2);

    // If n2 is not a num or Number, treat it as a zero
    return Comparable.compare(this.toDouble(), 0);
  }

  /// Detect the type of Number by inspecting
  /// map contents and create it.
  ///
  static Number _fromMap(Map m) {
    if (m.containsKey("imag")) return new Imaginary.fromMap(m);
    if (m.containsKey("real")) return new Complex.fromMap(m);
    if (m.containsKey("pd")) return null; //return new Precise()
    return Integer.zero;
  }
}
