part of quantity_si;

class Concentration extends Quantity {
  /// Dimensions for this type of quantity
  static const Dimensions concentrationDimensions = const Dimensions.constant(const {"Amount": 1, "Length": -3});

  /// The standard SI unit **/
  static final ConcentrationUnits molesPerCubicMeter =
      new ConcentrationUnits.amountVolume(AmountOfSubstance.moles, Volume.cubicMeters);

  Concentration({dynamic rad_per_s2, dynamic deg_per_s2, double uncert: 0.0})
      : super(rad_per_s2 != null ? rad_per_s2 : (deg_per_s2 != null ? deg_per_s2 : 0.0),
            Concentration.molesPerCubicMeter, uncert);

  Concentration._internal(conv) : super._dimensions(conv, Concentration.concentrationDimensions);

  /// Constructs a Concentration based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  ///
  Concentration.inUnits(value, ConcentrationUnits units, [double uncert = 0.0])
      : super(value, units != null ? units : Concentration.molesPerCubicMeter, uncert);

  const Concentration.constant(Number valueSI, {ConcentrationUnits units, num uncert: 0.0})
      : super.constant(valueSI, Concentration.concentrationDimensions, units, uncert);
}

/// Units acceptable for use in describing Concentration quantities.
///
class ConcentrationUnits extends Concentration with Units {
  ConcentrationUnits(String name, String abbrev1, String abbrev2, String singular, dynamic conv,
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

  ConcentrationUnits.amountVolume(AmountOfSubstanceUnits asu, VolumeUnits vu)
      : super._internal(asu.valueSI * vu.valueSI) {
    this.name = "${asu.name} per ${vu.singular}";
    this.singular = "${asu.singular} per ${vu.singular}";
    this._convToMKS = asu.valueSI * vu.valueSI;
    this._abbrev1 = asu._abbrev1 != null && vu._abbrev1 != null ? "${asu._abbrev1} / ${vu._abbrev1}" : null;
    this._abbrev2 = asu._abbrev2 != null && vu._abbrev2 != null ? "${asu._abbrev2}/${vu._abbrev2}" : null;
    ;
    this.metricBase = false;
    this.offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  Type get quantityType => Concentration;

  /// Derive new ConcentrationUnits using this ConcentrationUnits object as the base.
  ///
  Units derive(String fullPrefix, String abbrevPrefix, double conv) {
    return new ConcentrationUnits(
        "${fullPrefix}${name}",
        _abbrev1 != null ? "${abbrevPrefix}${_abbrev1}" : null,
        _abbrev2 != null ? "${abbrevPrefix}${_abbrev2}" : null,
        "${fullPrefix}${singular}",
        valueSI * conv,
        false,
        this.offset);
  }
}