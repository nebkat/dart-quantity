part of quantity_ext;

// Metric units
final LengthUnits yottameters = Length.meters.yotta();
final LengthUnits zettameters = Length.meters.zetta();
final LengthUnits exameters = Length.meters.exa();
final LengthUnits petameters = Length.meters.peta();
final LengthUnits terameters = Length.meters.tera();
final LengthUnits gigameters = Length.meters.giga();
final LengthUnits megameters = Length.meters.mega();
final LengthUnits kilometers = Length.meters.kilo();
final LengthUnits hectometers = Length.meters.hecto();
final LengthUnits dekameters = Length.meters.deka();
final LengthUnits meters = Length.meters;
final LengthUnits decimeters = Length.meters.deci();
final LengthUnits centimeters = Length.meters.centi();
final LengthUnits millimeters = Length.millimeters;
final LengthUnits micrometers = Length.meters.micro();
final LengthUnits nanometers = Length.nanometers;
final LengthUnits picometers = Length.meters.pico();
final LengthUnits femtometers = Length.meters.femto();
final LengthUnits attometers = Length.meters.atto();
final LengthUnits zeptometers = Length.meters.zepto();
final LengthUnits yoctometers = Length.meters.yocto();

final LengthUnits fermis =
    new LengthUnits("fermis", null, null, null, 1.0e-15, true);
final LengthUnits cables =
    new LengthUnits("cables", null, null, null, 2.19456e2, false);
final LengthUnits calibers =
    new LengthUnits("calibers", null, null, null, 2.54e-4, false);
final LengthUnits chainsSurveyor = new LengthUnits(
    "chains (surveyor)", null, null, "chain (surveyor)", 2.01168e1, false);
final LengthUnits chainsEngineer = new LengthUnits(
    "chains (engineer)", null, null, "chain (engineer)", 3.048e1, false);
final LengthUnits cubits =
    new LengthUnits("cubits", null, null, null, 5.472e-1, false);
final LengthUnits fathoms =
    new LengthUnits("fathoms", null, null, null, 1.8288, false);
final LengthUnits feet =
    new LengthUnits("feet", "'", "ft", "foot", 3.048e-1, false);
final LengthUnits feetUsSurvey = new LengthUnits("feet (US survey)", "ft (US)",
    null, "foot (US survey)", 3.048006096e-1, false);
final LengthUnits furlongs =
    new LengthUnits("furlongs", null, null, null, 2.01168e2, false);
final LengthUnits hands =
    new LengthUnits("hands", null, null, null, 1.016e-1, false);
final LengthUnits inches =
    new LengthUnits("inches", "\"", "in", "inch", 2.54e-2, false);
final LengthUnits leaguesUkNautical = new LengthUnits("leagues (UK nautical)",
    null, null, "league (UK nautical)", 5.559552e3, false);
final LengthUnits leaguesNautical = new LengthUnits(
    "leagues (nautical)", null, null, "league (nautical)", 5.556e3, false);
final LengthUnits leaguesStatute = new LengthUnits(
    "leagues (statute)", null, null, "league (statute)", 4.828032e3, false);
final LengthUnits lightYears =
    new LengthUnits("light years", "LY", null, null, 9.46055e15, false);
final LengthUnits linksEngineer = new LengthUnits(
    "links (engineer)", null, null, "link (engineer)", 3.048e-1, false);
final LengthUnits linksSurveyor = new LengthUnits(
    "links (surveyor)", null, null, "link (surveyor)", 2.01168e-1, false);
final LengthUnits microns = Length.meters.micro();
final LengthUnits mils =
    new LengthUnits("mils", null, null, null, 2.54e-5, false);
final LengthUnits miles =
    new LengthUnits("miles", "mi", null, null, 1.609344e3, false);
final LengthUnits nauticalMilesUk = new LengthUnits("nautical miles (UK)",
    "NM (UK)", null, "nautical mile (UK)", 1.853184e3, false);
final LengthUnits paces =
    new LengthUnits("paces", null, null, null, 7.62e-1, false);
final LengthUnits parsecs =
    new LengthUnits("parsecs", "pc", null, null, 3.0857e16, false);
final LengthUnits perches =
    new LengthUnits("perches", null, null, "perch", 5.0292, false);
final LengthUnits picas =
    new LengthUnits("picas", null, null, null, 4.2175176e-3, false);
final LengthUnits points =
    new LengthUnits("points", null, null, null, 3.514598e-4, false);
final LengthUnits poles =
    new LengthUnits("poles", null, null, null, 5.0292, false);
final LengthUnits rods =
    new LengthUnits("rods", null, null, null, 5.0292, false);
final LengthUnits skeins =
    new LengthUnits("skeins", null, null, null, 1.09728e2, false);
final LengthUnits spans =
    new LengthUnits("spans", null, null, null, 2.286e-1, false);
final LengthUnits yards =
    new LengthUnits("yards", "yd", null, null, 9.144e-1, false);
final LengthUnits xUnits =
    new LengthUnits("X units", "Siegbahn", "Xu", null, 1.00208e-13, false);
final LengthUnits angstromStars =
    new LengthUnits("Angstrom stars", "A*", null, null, 1.00001509e-10, false);

// CONSTANTS
const Length LENGTH_ZERO = const Length.constant(Double.zero);

final Length planckLength = new Length(m: 1.616199e-35, uncert: 6.0e-5);
final Length angstromStar = new Length(m: 1.00001509e-10, uncert: 9.0e-7);
final Length bohrRadius = new Length(m: 0.5291772108e-10, uncert: 3.3e-9);
final Length comptonWavelength = new Length(m: 2.426310238e-12, uncert: 6.7e-9);
final Length tauComptonWavelength = new Length(m: 0.69772e-15, uncert: 1.6e-4);
final Length classicalElectronRadius =
    new Length(m: 2.817940325e-15, uncert: 1.0e-8);
