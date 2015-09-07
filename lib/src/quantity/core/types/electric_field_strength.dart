part of quantity_core;

class ElectricFieldStrength extends Quantity {
  /// Dimensions for this type of quantity
  static const Dimensions electricFieldStrengthDimensions =
      const Dimensions.constant(
          const {"Current": -1, "Time": -3, "Length": 1, "Mass": 1});

  /// The standard SI unit.
  static final ElectricFieldStrengthUnits voltPerMeter =
      new ElectricFieldStrengthUnits.potentialLength(
          ElectricPotentialDifference.volts, Length.meters);

  ElectricFieldStrength({dynamic V_per_m, double uncert: 0.0})
      : super(V_per_m != null ? V_per_m : 0.0,
            ElectricFieldStrength.voltPerMeter, uncert);

  ElectricFieldStrength._internal(conv)
      : super._dimensions(
            conv, ElectricFieldStrength.electricFieldStrengthDimensions);

  /// Constructs a ElectricFieldStrength based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  ///
  ElectricFieldStrength.inUnits(value, ElectricFieldStrengthUnits units,
      [double uncert = 0.0])
      : super(value, units != null ? units : ElectricFieldStrength.voltPerMeter,
            uncert);

  const ElectricFieldStrength.constant(Number valueSI,
      {ElectricFieldStrengthUnits units, num uncert: 0.0})
      : super.constant(
            valueSI,
            ElectricFieldStrength.electricFieldStrengthDimensions,
            units,
            uncert);
}

/// Units acceptable for use in describing ElectricFieldStrength quantities.
///
class ElectricFieldStrengthUnits extends ElectricFieldStrength with Units {
  ElectricFieldStrengthUnits(String name, String abbrev1, String abbrev2,
      String singular, dynamic conv,
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

  ElectricFieldStrengthUnits.potentialLength(
      ElectricPotentialDifferenceUnits epdu, LengthUnits lu)
      : super._internal(epdu.valueSI * lu.valueSI) {
    this.name = "${epdu.name} per ${lu.singular}";
    this.singular = "${epdu.singular} per ${lu.singular}";
    this._convToMKS = epdu.valueSI * lu.valueSI;
    this._abbrev1 = epdu._abbrev1 != null && lu._abbrev1 != null
        ? "${epdu._abbrev1} / ${lu._abbrev1}"
        : null;
    this._abbrev2 = epdu._abbrev2 != null && lu._abbrev2 != null
        ? "${epdu._abbrev2}/${lu._abbrev2}"
        : null;
    ;
    this.metricBase = false;
    this.offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  Type get quantityType => ElectricFieldStrength;

  /// Derive new ElectricFieldStrengthUnits using this ElectricFieldStrengthUnits object as the base.
  ///
  Units derive(String fullPrefix, String abbrevPrefix, double conv) {
    return new ElectricFieldStrengthUnits(
        "${fullPrefix}${name}",
        _abbrev1 != null ? "${abbrevPrefix}${_abbrev1}" : null,
        _abbrev2 != null ? "${abbrevPrefix}${_abbrev2}" : null,
        "${fullPrefix}${singular}",
        valueSI * conv,
        false,
        this.offset);
  }
}