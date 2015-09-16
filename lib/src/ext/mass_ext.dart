part of quantity_ext;

// Metric units
final MassUnits yottagrams = Mass.grams.yotta();
final MassUnits zettagrams = Mass.grams.zetta();
final MassUnits exagrams = Mass.grams.exa();
final MassUnits petagrams = Mass.grams.peta();
final MassUnits teragrams = Mass.grams.tera();
final MassUnits gigagrams = Mass.grams.giga();
final MassUnits megagrams = Mass.grams.mega();
final MassUnits kilograms = Mass.kilograms;
final MassUnits hectograms = Mass.grams.hecto();
final MassUnits dekagrams = Mass.grams.deka();
final MassUnits grams = Mass.grams;
final MassUnits decigrams = Mass.grams.deci();
final MassUnits centigrams = Mass.grams.centi();
final MassUnits milligrams = Mass.grams.milli();
final MassUnits micrograms = Mass.grams.micro();
final MassUnits nanograms = Mass.grams.nano();
final MassUnits picograms = Mass.grams.pico();
final MassUnits femtograms = Mass.grams.femto();
final MassUnits attograms = Mass.grams.atto();
final MassUnits zeptograms = Mass.grams.zepto();
final MassUnits yoctograms = Mass.grams.yocto();

// Metric abbreviations
final MassUnits Yg = yottagrams;
final MassUnits Zg = zettagrams;
final MassUnits Eg = exagrams;
final MassUnits Pg = petagrams;
final MassUnits Tg = teragrams;
final MassUnits Gg = gigagrams;
final MassUnits Mg = megagrams;
final MassUnits kg = kilograms;
final MassUnits hg = hectograms;
final MassUnits dag = dekagrams;
final MassUnits g = grams; // ?
final MassUnits dg = decigrams;
final MassUnits cg = centigrams;
final MassUnits mg = milligrams;
//????final MassUnits micrograms = Mass.grams.micro();  // ug ???  mcg???
final MassUnits ng = nanograms;
final MassUnits pg = picograms;
final MassUnits fg = femtograms;
final MassUnits ag = attograms;
final MassUnits zg = zeptograms;
final MassUnits yg = yoctograms;

// Convenience units
final MassUnits gammas = Mass.grams.micro();

/// Accepted for use with the SI.
final MassUnits metricTons = Mass.metricTons;

/// Accepted for use with the SI.
final MassUnits tonnes = metricTons;

/// Accepted for use with the SI.
final MassUnits unifiedAtomicMassUnits = Mass.unifiedAtomicMassUnits;

// non-SI mass units

final MassUnits caratsMetric = new MassUnits("carats (metric)", null, null, "carat (metric)", 2.0e-4, false);

final MassUnits dramsApothecary =
    new MassUnits("drams (apothecary)", null, null, "dram (apothecary)", 3.8879e-3, false);

final MassUnits dramsAvoirdupois =
    new MassUnits("drams (avoirdupois)", null, null, "dram (avoirdupois)", 1.7718e-3, false);

final MassUnits grains = new MassUnits("grains", null, null, null, 6.4799e-5, false);

final MassUnits hundredweightLong =
    new MassUnits("hundredweight (long)", null, null, "hundredweight (long)", 50.802, false);

final MassUnits hundredweightShort =
    new MassUnits("hundredweight (short)", null, null, "hundredweight (short)", 45.359, false);

final MassUnits ouncesAvoirdupois =
    new MassUnits("ounces (avoirdupois)", "oz (avoirdupois)", null, "ounce (avoirdupois)", 2.8350e-2, false);

final MassUnits ouncesApothecary =
    new MassUnits("ounces (apothecary)", "oz (apothecary)", null, "ounce (apothecary)", 3.1103e-2, false);

final MassUnits pennyweightTroy =
    new MassUnits("pennyweight (troy)", null, null, "pennyweight (troy)", 1.5552e-3, false);

final MassUnits poundsAvoirdupois =
    new MassUnits("pounds (avoirdupois)", "lbm (avoirdupois)", null, "pound (avoirdupois)", 0.45359, false);

final MassUnits poundsApothecary =
    new MassUnits("pounds (apothecary)", "lbs (apothecary)", null, "pound (apothecary)", 0.37324, false);

final MassUnits quintals = new MassUnits("quintals", null, null, null, 100.0, true);

final MassUnits scruples = new MassUnits("scruples", null, null, null, 1.2960e-3, false);

final MassUnits slugs = new MassUnits("slugs", null, null, null, 14.594, false);

final MassUnits tonsLong = new MassUnits("tons (long)", null, null, "ton (long)", 1016.0, false);

final MassUnits tonsShort = new MassUnits("tons (short)", null, null, "ton (short)", 907.18, false);

final MassUnits tonsAssay = new MassUnits("tons (assay)", null, null, "ton (assay)", 2.9166666e-2, false);

final MassUnits kgfSecondSquaredMeter = new MassUnits("kgf second squared meter", null, null, null, 9.80665, false);

// Constants
const Mass planckMass = const Mass.constant(const Double.constant(2.176470e-8), uncert: 2.3e-5);
const Mass alphaParticleMass = const Mass.constant(const Double.constant(6.644657230e-27), uncert: 1.2e-8);
const Mass atomicMass = const Mass.constant(const Double.constant(1.660539040e-27), uncert: 1.2e-8);
const Mass electronMass = const Mass.constant(const Double.constant(9.10938356e-31), uncert: 1.2e-8);
const Mass protonMass = const Mass.constant(const Double.constant(1.672621898e-27), uncert: 1.2e-8);
const Mass neutronMass = const Mass.constant(const Double.constant(1.674927471e-27), uncert: 1.2e-8);
const Mass tauMass = const Mass.constant(const Double.constant(3.16747e-27), uncert: 9.0e-5);
const Mass deuteronMass = const Mass.constant(const Double.constant(3.343583719e-27), uncert: 1.2e-8);
const Mass helionMass = const Mass.constant(const Double.constant(5.006412700e-27), uncert: 1.2e-8);
const Mass muonMass = const Mass.constant(const Double.constant(1.883531594e-28), uncert: 2.5e-8);