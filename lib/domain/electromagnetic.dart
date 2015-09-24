library electromagnetic;

import 'package:quantity/quantity.dart';

export 'package:quantity/quantity.dart' show elementaryCharge, magneticConstant;

const MagneticFlux magneticFluxQuantum =
    const MagneticFlux.constant(const Double.constant(2.067833831e-15), uncert: 6.1e-9);

const Conductance conductanceQuantum =
    const Conductance.constant(const Double.constant(7.7480917310e-5), uncert: 2.3e-10);
const Conductance G0 = conductanceQuantum;

const MiscQuantity josephsonConstant = const MiscQuantity.constant(const Double.constant(483597.8525e9),
    const Dimensions.constant(const {"length": -2, "mass": -1, "current": 1, "time": 2}),
    uncert: 6.1e-9);
const MiscQuantity KJ = josephsonConstant;

const Conductance vonKlitzingConstant =
    const Conductance.constant(const Double.constant(25812.8074555), uncert: 2.3e-10);
const Conductance RK = vonKlitzingConstant;

const MiscQuantity bohrMagneton = const MiscQuantity.constant(
    const Double.constant(927.4009994e-26), const Dimensions.constant(const {"length": 2, "current": 1}),
    uncert: 6.2e-9);
const MiscQuantity muB = bohrMagneton;

const MiscQuantity nuclearMagneton = const MiscQuantity.constant(
    const Double.constant(5.050783699e-27), const Dimensions.constant(const {"length": 2, "current": 1}),
    uncert: 6.2e-9);
const MiscQuantity muN = nuclearMagneton;

const Permeability vacuum = magneticConstant;
