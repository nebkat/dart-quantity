part of number;

class Complex extends Number {
  final Real real;
  final Imaginary imaginary;

  Complex(this.real, this.imaginary);
  const Complex.constant(this.real, this.imaginary) : super.constant();

  Complex.coeff(realValue, imagValue)
      : real = new Double.constant(realValue.toDouble()),
        imaginary = new Imaginary.constant(
            imagValue is num ? new Double(imagValue.toDouble()) : imagValue);

  Complex.fromMap(Map m)
      : real = m["real"].toJson(),
        imaginary = m["imag"].toJson();

  /// [imag] is a convenient getter for the [imaginary] value
  Imaginary get imag => imaginary;

  Complex get conjugate =>
      new Complex(real, new Imaginary(imaginary.value * -1.0));

  /// Complex modulus represents the magnitude of this complex number in the complex plane.
  ///
  Double get complexModulus => new Double(Math.sqrt(
      real.value * real.value + imaginary.value.value * imaginary.value.value));

  /// Complex norm is synonymous with complex modulus.
  ///
  Double get complexNorm => complexModulus;

  Double get absoluteSquare => complexModulus ^ 2;

  /// In radians.
  ///
  Double get complexArgument =>
      new Double(Math.atan2(imaginary.value.value, real.value));

  /// Phase is synonymous with complex argument.
  ///
  Double get phase => complexArgument;

  bool get isInfinite =>
      real.value == double.INFINITY || real.value == double.NEGATIVE_INFINITY;
  bool get isNaN => real.value == double.NAN;
  bool get isNegative => real.value < 0;

  //TODO
  bool get isInteger => (imaginary == null || imaginary == 0) && real.isInteger;

  double toDouble() => real.toDouble();

  int toInt() => real.toInt();

  int get hashCode {
    if (real == 0) {
      if (imaginary == 0) {
        return 0.hashCode;
      } else {
        return int.parse("${imaginary.hashCode}");
      }
    } else if (imaginary == 0) {
      return int.parse("${real.hashCode}");
    }

    return int.parse("${real.hashCode}${imaginary.hashCode}");
  }

  bool operator ==(obj) {
    if (obj is num) return real == obj && imaginary.value == 0.0;
    if (obj is Complex) return real == obj.real && imaginary == obj.imaginary;
    if (obj is Imaginary) return real == 0.0 && imaginary == obj;
    if (obj is Real) return real == obj && imaginary.value == 0.0;
    return false;
  }

  @override
  Number operator +(addend) {
    if (addend is Complex) return new Complex(
        real + addend.real, imaginary + addend.imaginary);
    if (addend is Imaginary) return new Complex(
        this.real, new Imaginary(imaginary.value + addend.value));
    if (addend is Real) return new Complex(real + addend, this.imaginary);
    if (addend is num) return new Complex(real + addend, this.imaginary);

    // Treat addend as zero
    return this;
  }

  Number operator -() => new Complex(-real, -imaginary);

  Number operator -(subtrahend) {
    if (subtrahend is Complex) return new Complex(
        real - subtrahend.real.value, imaginary - subtrahend.imaginary);
    if (subtrahend
        is Imaginary) return new Complex(real, imaginary - subtrahend);
    if (subtrahend is num) return new Complex(real - subtrahend, imaginary);
    if (subtrahend
        is Real) return new Complex(real - subtrahend.value, imaginary);

    return this;
  }

  Number operator *(multiplier) {
    // i * i = -1
    if (multiplier
        is num) return new Complex(real * multiplier, imaginary * multiplier);
    if (multiplier is Real) return new Complex(
        multiplier * real, new Imaginary(multiplier.value * imaginary));
    if (multiplier is Imaginary)
        // (0+bi)(c+di)=(-bd)+i(bc)
        return new Complex(
            imaginary * multiplier.value * -1, real * multiplier.value);
    if (multiplier is Complex)
        // (a+bi)(c+di)=(ac-bd)+i(ad+bc)
        return new Complex(
            real * multiplier.real - imaginary * multiplier.imaginary,
            real * multiplier.imaginary + imaginary * multiplier.real);

    // Treat multipler as zero
    return Double.zero;
  }

  Number operator /(divisor) {
    if (divisor is num) return new Complex(real / divisor, imaginary / divisor);
    if (divisor is Real) return new Complex(
        real / divisor.value, imaginary / divisor.value);
    if (divisor is Imaginary) return new Complex(
        imaginary / divisor.value, -real / divisor.value);
    if (divisor is Complex) {
      // (a + bi) / (c + di) = (ac + bd) / (c^2 + d^2) + i * (bc - ad) / (c^2 + d^2)
      Number c2d2 = (divisor.real ^ 2.0) + (divisor.imaginary.value ^ 2.0);
      return new Complex(
          (real * divisor.real + imaginary * divisor.imaginary) / c2d2,
          (imaginary * divisor.real - real * divisor.imaginary) / c2d2);
    }

    // Treat divisor as 0
    return new Complex(
        real < 0 ? Double.negInfinity : Double.infinity,
        imaginary < 0
            ? new Imaginary(Double.negInfinity)
            : new Imaginary(Double.infinity));
  }

  ///  The truncating division operator.
  ///
  Number operator ~/(divisor) {
    if (divisor == 0) {
      // Treat divisor as 0
      return new Complex(
          real < 0 ? Double.negInfinity : Double.infinity,
          imaginary < 0
              ? new Imaginary(Double.negInfinity)
              : new Imaginary(Double.infinity));
    }

    if (divisor is num) new Complex(real ~/ divisor, imaginary ~/ divisor);
    if (divisor is Imaginary) new Complex(
        imaginary ~/ divisor.value, -real ~/ divisor.value);
    if (divisor is Real) new Complex(real ~/ divisor, imaginary ~/ divisor);
    if (divisor is Complex) {
      // (a + bi) / (c + di) = (ac + bd) / (c^2 + d^2) + i * (bc - ad) / (c^2 + d^2)
      Number c2d2 = (divisor.real ^ 2.0) + (divisor.imaginary.value ^ 2.0);
      return new Complex(
          ((real * divisor.real + imaginary * divisor.imaginary) / c2d2)
              .truncate(),
          new Imaginary(((imaginary * divisor.real - real * divisor.imaginary) /
              c2d2).truncate()));
    }

    // Treat divisor as 0
    return new Complex(
        real < 0 ? Double.negInfinity : Double.infinity,
        imaginary < 0
            ? new Imaginary(Double.negInfinity)
            : new Imaginary(Double.infinity));
  }

  /**
   *  The modulo operator.
   *
   *  See http://math.stackexchange.com/questions/274694/modulo-complex-number
   */
  Number operator %(divisor) {
    /*
    if(divisor is num) return new Double(value % divisor);
    else if(divisor is Real) return new Double(value % divisor.value);
    else if(divisor is Complex) {
      // (a + 0i) / (c + di) = (ac - adi) / (c^2 + d^2)
      Number c2d2 = (divisor.real ^ 2.0)  + (divisor.imaginary.value ^ 2.0);
      Number aOverc2d2 = this / c2d2;

      //return new Complex(aOverc2d2 * divisor.real, new Imaginary(aOverc2d2 * divisor.imaginary.value * -1.0));
      //TODO
      return null;
    } else if(divisor is Imaginary) {//return new Imaginary((this / divisor.value) * -1);
      //TODO
      return null;

    }
    */
    // Treat divisor as 0
    return Double.zero;
  }

  /// The power operator (note: NOT bitwise XOR).
  ///
  /// In order to provide a convenient power operator for all [Number]s, the number library
  /// overrides the caret operator.  In Dart the caret operator is ordinarily used
  /// for bitwise XOR operations on [int]s.
  ///
  Number operator ^(exponent) {
    if (exponent is num) {
      double scaledPhase = exponent * phase.value;
      Number expModulus = (complexModulus ^ exponent);
      return new Complex(expModulus * Math.cos(scaledPhase),
          expModulus * Math.sin(scaledPhase));
    } else if (exponent is Real) {
      double scaledPhase = (exponent * phase.value).toDouble();
      Number expModulus = (complexModulus ^ exponent.value);
      return new Complex(expModulus * Math.cos(scaledPhase),
          expModulus * Math.sin(scaledPhase));
    } else if (exponent is Complex) {
      //TODO see http://mathworld.wolfram.com/ComplexNumber.html
    } else if (exponent is Imaginary) {
      //TODO
    }

    return Double.one;
  }

  bool operator >(obj) {
    //TODO if(obj is num)
    return false;
  }

  bool operator >=(obj) {
    //TODO if(obj is num)
    return false;
  }

  bool operator <(obj) {
    //TODO if(obj is num)
    return false;
  }

  bool operator <=(obj) {
    //TODO if(obj is num)
    return false;
  }

  /// The absolute value of a Complex number is its distance from zero in the Complex number space (e.g. the
  /// absolute value of 3 + 4i = 5).  The absolute value is always a real number.
  ///
  Real abs() => ((real * real) + (imaginary.value * imaginary.value)) ^ 0.5;

  Integer ceil() => real.ceil();

  Integer truncate() => real.truncate();

  Number reciprocal() {
    // (a - bi) / (a^2 + b^2)
    num a2b2 = Math.pow(real.value, 2) + Math.pow(imaginary.value.value, 2);
    return new Complex(real / a2b2, new Imaginary(imaginary.value / -a2b2));
  }

  /// Support [dart:json] stringify.
  ///
  /// Map Contents:
  ///     "real" : toJson map of real number
  ///     "imag" : toJson map of imaginary number
  ///
  /// Example:
  ///     {"real":{"i":5},"imag":{"d":3.3}}
  ///
  Map toJson() {
    return {"real": real.toJson(), "imag": imaginary.toJson()};
  }
}