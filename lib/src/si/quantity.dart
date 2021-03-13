import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:quantity/quantity.dart';
import '../../number.dart';
import 'dimensions.dart';
import 'dimensions_exception.dart';
import 'misc_quantity.dart';
import 'number_format_si.dart';
import 'quantity_exception.dart';
import 'types/scalar.dart';
import 'uncertainty_format.dart';
import 'units.dart';
import 'utilities.dart';

/// The abstract base class for all quantities.  The Quantity class represents
/// the value of a physical quantity and its
/// associated dimensions.  It provides methods for constructing and getting the
/// quantity's value in arbitrary units, methods for mathematical manipulation
/// and comparison and optional features such as arbitrary precision and uncertainty.
///
/// ## Definitions
/// _from [NIST's introduction to the International System of Units](http://physics.nist.gov/cuu/Units/introduction.html)_
///
/// * A _quantity in the general sense_ is a property ascribed to phenomena,
/// bodies, or substances that can be quantified for, or assigned to, a
/// particular phenomenon, body, or substance.  Examples are mass and electric
/// charge.
/// * A _quantity in the particular sense_ is a quantifiable or assignable
/// property ascribed to a particular phenomenon, body, or substance.  Examples
/// are the mass of the moon and the electric charge of the proton.
/// * A _physical quantity_ is a quantity that can be used in the mathematical
/// equations of science and technology.
/// * A _unit_ is a particular physical quantity, defined and adopted by
/// convention, with which other particular quantities of the same kind
/// (dimension) are compared to express their value.
/// * The _value of a physical quantity_ is the quantitative expression of a
/// particular physical quantity as the product of a number and a unit, the
/// number being its numerical value.  Thus, the numerical value of a particular
/// physical quantity depends on the unit in which it is expressed.
///
/// ## Immutable
/// Quantity instances are immutable; they may not be changed after creation.
/// Use `MutableQuantity` in the quantity_ext library for situations where
/// changing a Quantity object's value or units is required.
///
/// ## Value Representation,  Arbitrary Precision
/// Quantity supports values specified by [num] or [Number] objects.  `Number` subtypes
/// include [Real], [Imaginary] and [Complex].  Various [Real] subtypes are
/// available, including [Precise], which supports arbitrary precision calculations.
///
/// ## Uncertainty
/// A Quantity object optionally includes an uncertainty, as quantities are
/// often determined by measurement and therefore are only accurate within
/// the capabilities of the measuring devices or techniques.  Internally,
/// the uncertainty of a quantity is modeled as a Normal (Gaussian) distribution.
/// The shape of this 'bell curve' distribution is captured by a single value:
/// the relative standard uncertainty.  This method of expressing uncertainty is
/// used for all physical constants and is accepted for general use with all
/// quantities (because quantities, as measurable entities, all follow the same
/// logic for representing the uncertainty generated by the combination of
/// values from many different experiments).  The relative standard uncertainty
/// corresponds to an approximately 68% confidence level that the quantity's
/// value is in the stated range.  For different confidence levels, alternative
/// coverage factors may be used (k=2 ~95%; k=3 ~99%).  Uncertainty calculations
/// may be switched on or off as desired.  It is automatically on if the Quantity
/// is constructed with any uncertainty and off otherwise.  The setCalcUncertainty
/// method may be called at any point to enable/disable this capability.
abstract class Quantity implements Comparable<dynamic> {
  /// This constructor sets the [value] (as expressed in the accompanying units)
  /// and the relative standard uncertainty.  The value is may be set using any
  /// `num` or `Number` object, including [Precise] for arbitrary precision.
  ///
  /// Both the value and the uncertainty default to zero.
  ///
  /// Quantity dimensions are derived from the [preferredUnits] and default to scalar
  /// dimensions if units are not provided.
  ///
  /// Relative standard uncertainty is defined as the standard uncertainty
  /// divided by the absolute value of the result.  Standard uncertainty, in turn,
  /// is defined as the uncertainty (of a measurement result) by an estimated
  /// standard deviation, which is equal to the positive square root of the
  /// estimated variance.  One standard deviate in a Normal distribution
  /// corresponds to a coverage factor of 1 (k=1) and a confidence of approximately 68%.
  Quantity([dynamic value = Integer.zero, this.preferredUnits, double uncert = 0.0])
      : valueSI = preferredUnits?.toMks(value ?? 0) ?? (value is Number ? value : numToNumber(value as num)),
        dimensions = (preferredUnits is Quantity) ? (preferredUnits as Quantity).dimensions : Scalar.scalarDimensions,
        _ur = uncert;

  /// Used to construct a constant Quantity.
  const Quantity.constant(this.valueSI, this.dimensions, this.preferredUnits, this._ur);

  /// A constructor to support miscellaneous quantities:  dimensions are known, units are not.
  Quantity.misc([dynamic value = 0.0, Dimensions? dimensions, double uncert = 0.0])
      : valueSI = (value is num)
            ? numToNumber(value)
            : value is Number
                ? value
                : Integer.zero,
        dimensions = dimensions ?? Scalar.scalarDimensions,
        preferredUnits = null,
        _ur = uncert;

  /// The value of the quantity in the [base units](http://physics.nist.gov/cuu/Units/current.html),
  /// of the International System of Units (SI).
  ///
  /// This is often referred to as the _MKS_ value to highlight that the units reference meters
  /// and kilograms rather than centimeters and grams (_CGS_) as was often done before standardization.
  /// The [mks] getter offers a shorthand way to retrieve this value.
  final Number valueSI;

  /// Dimensions.
  final Dimensions dimensions;

  /// Sets whether or not uncertainty is to be calculated within mathematical methods.
  // bool calcUncertainty = false;

  /// The relative standard uncertainty.
  final double _ur;

  /// Preferred units for display.
  final Units? preferredUnits;

  ///  Whether or not this Quantity is represented using arbitrary precision.
  ///
  /// The values of arbitrarily precise Quantities are stored internally as
  /// [Precise] Number objects.
  ///
  /// Arbitrary precision calculations will generally be
  /// significantly slower than limited precision (double) calculations because
  /// arbitrary precision calculations typically occur in software while
  /// double precision calculations often are accelerated directly in hardware.
  bool get arbitraryPrecision => valueSI is Precise;

  /// Whether or not this Quantity has scalar dimensions, including having no angle or
  /// solid angle dimensions.
  ///
  /// Use `isScalarSI` to see if these Dimensions are scalar in the strict
  /// International System of Units (SI) sense, which allows non-zero angular and
  /// solid angular dimensions.
  bool get isScalar => dimensions.isScalar;

  /// Whether or not this Quantity has scalar dimensions in the strict
  /// International System of Units (SI) sense, which allows non-zero angle and
  /// solid angle dimensions.
  ///
  /// Use `isScalarSI` to see if these Dimensions are scalar in the strict
  /// International System of Units sense, which allows non-zero angular and
  /// solid angular dimensions.
  bool get isScalarSI => dimensions.isScalarSI;

  /// The relative standard uncertainty in this Quantity object's value.
  ///
  /// Relative standard uncertainty is defined as the standard uncertainty
  /// divided by the absolute value of the quantity.  Standard uncertainty, in turn,
  /// is defined as the uncertainty (of a measurement result) by an estimated
  /// standard deviation, which is equal to the positive square root of the
  /// estimated variance.  One standard deviate in a Normal distribution
  /// corresponds to a coverage factor of 1 (k=1) and a confidence of approximately 68%.
  double get relativeUncertainty => _ur;

  /// Returns the expanded uncertainty for coverage factor, [k], in this
  /// Quantity's value as a typed Quantity object.
  ///
  /// * The expanded uncertainty is defined as a multiple of the standard
  /// uncertainty and may be used when the 68.27% confidence represented by the
  /// standard uncertainty (k=1) is not adequate.
  /// * Confidence values (i.e., the percentage of the distribution encompassed)
  /// for other values of the coverage factor 'k' include:
  ///
  /// 1. 90% for k=1.645,
  /// 2. 95.45% for k=2,
  /// 3. 99% for k=2.576 and
  /// 4. 99.73% for k=3.
  Quantity calcExpandedUncertainty(double k) => dimensions.toQuantity(valueSI.abs() * _ur * k);

  /// Returns the standard uncertainty in this Quantity object's value as a typed
  /// Quantity object.
  ///
  /// Standard uncertainty
  /// is defined as the uncertainty (of a measurement result) by an estimated
  /// standard deviation, which is equal to the positive square root of the
  /// estimated variance.  One standard deviate in a Normal distribution
  /// corresponds to a coverage factor of 1 (k=1) and a confidence of approximately
  /// 68%.
  Quantity get standardUncertainty => dimensions.toQuantity(valueSI.abs() * _ur);

  /// Randomly generates a Quantity from this Quantity's value and uncertainty.
  /// The uncertainty is represented by a Normal (Gaussian) continuous
  /// distribution.
  ///
  /// Because the uncertainty is represented by the continuous normal
  /// distribution there are no upper or lower limits on the value that this
  /// method will return.
  ///
  /// If the relative uncertainty is zero, then this Quantity will be returned.
  Quantity randomSample() {
    if (_ur == 0.0) return this;

    // Generate a random number btw 0.0 and 1.0
    final rand = math.Random().nextDouble();

    final test = 2.0 * rand - 1.0;

    // Iterate on erf until we get a close enough match
    var delta = 1.0;
    const eps = 0.0001;
    var x = -4.0;
    var count = 0;
    while (count < 10000) {
      final fx = erf(x);
      if ((fx - test).abs() < eps) {
        final z = x * math.sqrt(2.0);
        return this + (standardUncertainty * z);
      }

      // Reverse direction and halve it if past it
      if (fx > test) {
        x -= delta; // backtrack... went too far
        delta *= 0.5; // take smaller steps
      } else {
        x += delta;
      }

      count++; // safety valve
    }

    // just in case
    return this;
  }

  /// Returns the absolute value of this Quantity.
  /// If the value of this Quantity is not negative it is returned directly.
  Quantity abs() {
    if (valueSI >= 0) return this;
    return dimensions.toQuantity(valueSI.abs(), preferredUnits, _ur);
  }

  /// Returns the sum of this Quantity and [addend].
  ///
  /// * If an attempt is made to add two Quantity objects having different
  /// dimensions, this method will throw a [DimensionsException].
  /// * If the uncertainty is calculated it will be equal to the combined
  /// standard uncertainty divided by the absolute value of the sum of the
  /// quantities.  The standard uncertainty is the square root of the sum
  /// of the squares of the two quantities' standard uncertainties. See
  /// (NIST Reference on Constants, Units, and Uncertainty: Combining
  /// Uncertainty Components](http://physics.nist.gov/cuu/Uncertainty/combination.html))
  Quantity operator +(dynamic addend) {
    if (addend == null) throw const QuantityException('Cannot add NULL to Quantity');

    // Scalars allow addition of numbers (the standard uncertainty remains the same).
    if (isScalar && (addend is num || addend is Number)) return this + Scalar(value: addend);

    // Every other Quantity type can only add another Quantity.
    if (addend is! Quantity) {
      throw const QuantityException('Cannot add a anything other than a Quantity to a non-Scalar Quantity');
    }
    final q2 = addend;
    if (dimensions != q2.dimensions) {
      throw DimensionsException('Can\'t add Quantities having different dimensions:  $dimensions and ${q2.dimensions}');
    }

    // Calculate the uncertainty, if necessary.
    final newValueSI = valueSI + q2.valueSI;
    final sumUr = calcRelativeCombinedUncertaintySumDiff(this, addend, newValueSI);

    if (dynamicQuantityTyping) {
      return dimensions.toQuantity(newValueSI, null, sumUr);
    } else {
      return MiscQuantity(newValueSI, dimensions, sumUr);
    }
  }

  /// Returns the difference of this Quantity and [subtrahend] or (this - q2).
  ///
  /// Only a Quantity object
  /// having the same dimensions as this Quantity object may be subtracted from it.
  ///
  /// * If an attempt is made to subtract a Quantity object having different
  /// dimensions from this Quantity object, this operator will throw a
  /// [DimensionsException].
  /// * If the uncertainty is calculated it will be equal to the combined
  /// standard uncertainty divided by the absolute value of the difference of the
  /// quantities.  The standard uncertainty is the square root of the sum
  /// of the squares of the two quantities' standard uncertainties.
  ///
  /// See <a href='http://physics.nist.gov/cuu/Uncertainty/combination.html'>
  /// NIST Reference on Constants, Units, and Uncertainty: Combining
  /// uncertainty components.
  Quantity operator -(dynamic subtrahend) {
    // Null check
    if (subtrahend == null) throw const QuantityException('Cannot subtract NULL from Quantity');

    // Scalars allow subtraction of numbers.
    if (isScalar && (subtrahend is num || subtrahend is Number)) return this - Scalar(value: subtrahend);

    // Every other Quantity type can only subtract another Quantity.
    if (subtrahend is! Quantity) {
      throw QuantityException('Cannot subtract a ${subtrahend.runtimeType} from a non-Scalar Quantity');
    }
    final q2 = subtrahend;
    if (dimensions != q2.dimensions) {
      throw DimensionsException('''Can't subtract Quantities having different 
        dimensions:  $dimensions and ${q2.dimensions}''');
    }

    final newValueSI = valueSI - q2.valueSI;
    final diffUr = calcRelativeCombinedUncertaintySumDiff(this, subtrahend, newValueSI);

    if (dynamicQuantityTyping) {
      return dimensions.toQuantity(valueSI - q2.valueSI, null, diffUr);
    } else {
      return MiscQuantity(valueSI - q2.valueSI, dimensions, diffUr);
    }
  }

  /// Returns the product of this quantity and [multiplier], which is expected
  /// to be either a Quantity, num or Number object.  All other
  /// types will cause a QuantityException to be thrown.
  ///
  /// * This Quantity object is unaffected.
  /// * The uncertainty of the resulting product Quantity
  /// is equal to the relative combined standard uncertainty,
  /// defined as the square root of the sum of the squares of the two
  /// quantities' relative standard uncertainties.
  Quantity operator *(dynamic multiplier) {
    if (multiplier is num || multiplier is Number) return this * Scalar(value: multiplier);

    // Product uncertainty
    var productUr = _ur;

    // Product value
    Number productValue;

    // Product dimensions
    var productDimensions = dimensions;

    // Branch on Quantity, num, Number
    if (multiplier is Quantity) {
      final q2 = multiplier;
      productDimensions = dimensions * q2.dimensions;
      productValue = valueSI * q2.valueSI;
      productUr = (_ur != 0.0 || q2._ur != 0.0) ? math.sqrt(_ur * _ur + q2._ur * q2._ur) : 0.0;
    } else {
      throw const QuantityException('Expected a Quantity, num or Number object');
    }

    if (dynamicQuantityTyping) {
      return productDimensions.toQuantity(productValue, null, productUr);
    } else {
      return MiscQuantity(productValue, productDimensions, productUr);
    }
  }

  /// Returns the quotient of this quantity and [divisor],
  /// including both value and dimensions.
  ///
  /// * This Quantity object is unaffected.
  /// * If the uncertainty of the resulting product Quantity is calculated it
  /// will be equal to the relative combined standard uncertainty, which is
  /// defined as the square root of the sum of the squares of the two quantities'
  /// relative standard uncertainties.
  Quantity operator /(dynamic divisor) {
    if (divisor is num || divisor is Number) return this / Scalar(value: divisor);

    if (divisor is Quantity) {
      return this * divisor.inverse();
    } else {
      throw const QuantityException('Expected a Quantity, num or Number object');
    }
  }

  /// Returns this Quantity raised to the power of [exponent].
  ///
  /// * This Quantity object is unaffected.
  /// * If the combined relative standard uncertainty of the resulting product
  ///  Quantity is calculated it will be equal to the exponent times the
  ///  relative standard uncertainty of this Quantity.
  ///
  /// See [NIST Reference on Constants, Units, and Uncertainty: Combining uncertainty components](http://physics.nist.gov/cuu/Uncertainty/combination.html)
  Quantity operator ^(dynamic exponent) {
    if (exponent == 1) return this;
    if (exponent == 0) {
      if (valueSI.toDouble() == 0) return Scalar(value: Double.NaN);
      return Scalar.one;
    }

    if (exponent is num) {
      return (dimensions ^ exponent).toQuantity(valueSI ^ exponent, null, _ur * exponent);
    } else if (exponent is Number) {
      return (dimensions ^ exponent.toDouble()).toQuantity(valueSI ^ exponent, null, _ur * exponent.toDouble());
    } else if (exponent is Scalar) {
      return (dimensions ^ exponent.valueSI.toDouble())
          .toQuantity(valueSI ^ exponent, null, _ur * exponent.valueSI.toDouble());
    }

    throw const QuantityException('Cannot raise a quantity to a non-numeric power');
  }

  /// The unary minus operator returns a Quantity whose value
  /// is the negative of this Quantity's value.
  Quantity operator -() => dimensions.toQuantity(valueSI * -1, preferredUnits, _ur);

  /// Returns a [Quantity] that represents the square root of this Quantity,
  /// in terms of both value and dimensions (for example, if this Quantity were an
  /// Area of 16 square meters, a Length of 4 meters will be returned).
  Quantity sqrt() => this ^ (0.5);

  /// Determines the inverse of the quantity represented by this object,
  /// creating and returning a Quantity object (which may have different
  /// dimensions and therefore be of a different type).  This object is not
  /// modified.
  ///
  /// * Inversion occurs when a Quantity is divided into 1 and is
  /// accomplished by simply inverting the dimensions and dividing the SI MKS value
  /// into 1.0.
  /// * The relative standard uncertainty is unchanged by inversion.
  Quantity inverse() => dimensions.inverse().toQuantity(valueSI.reciprocal(), null, _ur);

  /// Determines whether on not this Quantity is less than a specified Quantity by
  /// comparing their MKS values.  The two Quantities need not be of the same
  /// type or dimensions.
  bool operator <(Quantity other) => compareTo(other) < 0;

  /// Determines whether on not this Quantity is less than or equal to a
  /// specified Quantity by comparing their MKS values.  The two Quantities
  /// need not be of the same type or dimensions.
  bool operator <=(Quantity other) => compareTo(other) <= 0;

  /// Determines whether on not this Quantity is greater than a specified Quantity by
  /// comparing their MKS values.  The two Quantities need not be of the same
  /// type or dimensions.
  bool operator >(Quantity other) => compareTo(other) > 0;

  /// Determines whether on not this Quantity is greater than or equal to a specified
  /// Quantity by comparing their MKS values.  The two Quantities need not be of
  /// the same type or dimensions.
  bool operator >=(Quantity other) => compareTo(other) >= 0;

  /// Returns true if this Quantity is equal to [obj].  Two Quantity
  /// objects are considered equal if their MKS values and dimensions are equal.
  /// Only values and dimensions are considered; other attributes such as
  /// uncertainty and preferred units are ignored.
  ///
  /// Scalar quantities are also considered equal to num and Number objects
  /// with matching values.
  @override
  bool operator ==(Object obj) {
    if (this is Scalar && (obj is num || obj is Number)) return valueSI == obj;

    if (obj is Quantity) {
      if (!(dimensions == obj.dimensions)) return false;
      return compareTo(obj) == 0;
    }
    return false;
  }

  /// The hash code is based on the value and dimensions.
  /// Uncertainty and preferred units are not considered.
  @override
  int get hashCode => hashObjects(<Object>[valueSI, dimensions]);

  /// Compares this Quantity to [q2] by comparing MKS values.  The
  /// Quantities need not have the same dimensions.
  ///
  /// Returns a negative integer, zero, or a positive integer as this Quantity is
  /// less than, equal to, or greater than [q2].
  @override
  int compareTo(dynamic q2) {
    if (q2 is! Quantity) {
      throw const QuantityException('A Quantity cannot be compared to anything besides another Quantity');
    }
    return valueSI.compareTo(q2.valueSI);
  }

  /// Returns the value of this quantity in standard MKS (or meter-kilogram-second) units.
  Number get mks => valueSI;

  /// Returns the value of this quantity in alternative CGS
  /// (or centimeter-gram-second) units.  MKS (meter-kilogram-second) units are
  /// preferred.
  ///
  /// Although CGS units were once commonly used and contended for the role
  /// of standard units, their use is now discouraged in favor of the adopted
  /// standard MKS (or meter-kilogram-second) units.
  ///
  /// See [get mks].
  Number get cgs {
    var value = valueSI;

    // Adjust for centimeters vs. meters
    final lengthExp = dimensions.getComponentExponent(Dimensions.baseLengthKey);
    value *= Double.hundred ^ lengthExp;

    // Adjust for grams vs. kilograms
    final massExp = dimensions.getComponentExponent(Dimensions.baseMassKey);
    return value *= Double.thousand ^ massExp;
  }

  /// Gets the Quantity's value in the specified [units].  If units is null,
  /// the MKS value is returned.  If not null, [units] must have dimensions
  /// compatible with this Quantity or a DimensionsException will be thrown.
  Number valueInUnits(Units? units) {
    if (units == null) {
      return mks;
    } else {
      // First check for compatible dimensions
      if (units is Quantity && (units as Quantity).dimensions == dimensions) {
        return units.fromMks(valueSI);
      } else {
        throw DimensionsException('Cannot retrieve quantity value using units with incompatible dimensions');
      }
    }
  }

  /// Appends a String representation of this [Quantity] to the [buffer]
  /// using the preferred units and number format.  If no preferred units have
  /// been specified, then MKS units are used.  Uncertainty in the value of the
  /// Quantity is optionally shown as a plus/minus value in the same units.
  void outputText(StringBuffer buffer,
      {UncertaintyFormat uncertFormat = UncertaintyFormat.none, bool symbols = true, NumberFormat? numberFormat}) {
    if (preferredUnits != null) {
      final val = preferredUnits!.fromMks(mks);

      final nf = numberFormat ?? NumberFormatSI();

      // Format the number.
      buffer.write(nf.format(val));

      // Uncertainty.
      if (_ur != 0 && uncertFormat != UncertaintyFormat.none) {
        final uncert = preferredUnits != null
            ? standardUncertainty.valueInUnits(preferredUnits).toDouble()
            : standardUncertainty.mks.toDouble();

        if (uncertFormat == UncertaintyFormat.parens) {
          buffer.write('(${nf.format(uncert)})');
        } else if (uncertFormat == UncertaintyFormat.plusMinus) {
          final unicode = nf is NumberFormatSI && nf.unicode == true;
          buffer.write(' ${unicode ? '\u{00b1}' : '+/-'} ${nf.format(uncert)}');
        }
      }

      // Get the units string (singular or plural, as appropriate).
      String unitStr;
      if (symbols) {
        unitStr = preferredUnits!.getShortestName(val.abs() <= 1.0);
      } else {
        if (val.abs() <= 1.0) {
          unitStr = preferredUnits!.singular ?? preferredUnits!.name;
        } else {
          unitStr = preferredUnits!.name;
        }
      }

      if (!(unitStr == '1')) buffer..write(' ')..write(unitStr);
    } else {
      // Couldn't find any preferred units.
      buffer..write(mks)..write(' [MKS]');
    }
  }

  /// Returns a String representation of this [Quantity] using the [preferredUnits].
  /// If no preferred units have been specified, then MKS units are used.
  @override
  String toString() {
    final buffer = StringBuffer();
    outputText(buffer);
    return buffer.toString();
  }

  /// Support [dart:convert] stringify.
  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};

    // Use value in preferred units, if available, for better readability.
    if (preferredUnits != null) {
      m['value'] = valueInUnits(preferredUnits).toJson();
      m['prefUnits'] = preferredUnits!.name;
    }

    // Only include non-zero relative uncertainty
    if (_ur != 0.0) m['ur'] = _ur;

    return m;
  }

  /// Calculates the relative combined uncertainty resulting from the addition or
  /// subtraction of two Quantities.
  static double calcRelativeCombinedUncertaintySumDiff(Quantity q1, Quantity q2, Number valueSI) {
    if (q1._ur != 0.0 || q2._ur != 0.0) {
      // Standard uncertainties (derived from relative standard uncertainties).
      final u1 = q1._ur * q1.valueSI.abs().toDouble();
      final u2 = q2._ur * q2.valueSI.abs().toDouble();

      // Combined standard uncertainty.
      final uc = math.sqrt(u1 * u1 + u2 * u2);

      // Relative combined standard uncertainty.
      return uc / valueSI.abs().toDouble();
    }

    return 0;
  }
}
