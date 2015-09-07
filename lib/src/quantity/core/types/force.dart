part of quantity_core;

class Force extends Quantity {
  /// Dimensions for this type of quantity
  static const Dimensions forceDimensions =
      const Dimensions.constant(const {"Length": 1, "Mass": 1, "Time": -2});

  /// The standard SI unit.
  static final ForceUnits newtons =
      new ForceUnits("newtons", null, "N", null, 1.0, true);

  Force({dynamic N, double uncert: 0.0})
      : super(N != null ? N : 0.0, Force.newtons, uncert);

  Force._internal(conv) : super._dimensions(conv, Force.forceDimensions);

  /// Constructs a Force based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  ///
  Force.inUnits(value, ForceUnits units, [double uncert = 0.0])
      : super(value, units != null ? units : Force.newtons, uncert);

  const Force.constant(Number valueSI, {ForceUnits units, num uncert: 0.0})
      : super.constant(valueSI, Force.forceDimensions, units, uncert);

  Force.ma(Mass m, Acceleration a)
      : super(m.valueSI * a.valueSI, Force.newtons,
            Math.sqrt(m._ur * m._ur + a._ur * a._ur));
}

/// Units acceptable for use in describing Force quantities.
///
class ForceUnits extends Force with Units {
  ForceUnits(String name, String abbrev1, String abbrev2, String singular,
      dynamic conv,
      [bool metricBase = false, num offset = 0.0])
      : super._internal(conv) {
    this.name = name;
    this.singular = singular;
    this._convToMKS = objToNumber(conv);
    this._abbrev1 = abbrev1;
    this._abbrev2 = abbrev2;
    this.metricBase = metricBase;
    this.offset = offset;
  }

  /// Returns the Type of the Quantity to which these Units apply
  Type get quantityType => Force;

  /// Derive new ForceUnits using this ForceUnits object as the base.
  ///
  Units derive(String fullPrefix, String abbrevPrefix, double conv) {
    return new ForceUnits(
        "${fullPrefix}${name}",
        _abbrev1 != null ? "${abbrevPrefix}${_abbrev1}" : null,
        _abbrev2 != null ? "${abbrevPrefix}${_abbrev2}" : null,
        "${fullPrefix}${singular}",
        valueSI * conv,
        false,
        this.offset);
  }
}