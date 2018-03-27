import 'package:test/test.dart';
import 'package:quantity/quantity.dart';
import 'package:quantity/number.dart';

void main() {
  group('MiscQuantity', () {
    test('constructors', () {
      // no-args
      MiscQuantity mq = new MiscQuantity();
      expect(mq, isNotNull);
      expect(mq.valueSI, isNotNull);
      expect(mq.valueSI.toDouble(), 0.0);
      expect(mq.dimensions, isNotNull);
      expect(mq.dimensions, Scalar.scalarDimensions);
      expect(mq.relativeUncertainty, 0.0);
      expect(mq.preferredUnits, isNull);

      // int value only
      mq = new MiscQuantity(42);
      expect(mq, isNotNull);
      expect(mq.valueSI is Integer, true);
      expect(mq.valueSI.toDouble(), 42.0);
      expect(mq.dimensions, isNotNull);
      expect(mq.dimensions, Scalar.scalarDimensions);
      expect(mq.relativeUncertainty, 0.0);
      expect(mq.preferredUnits, isNull);

      // double value only
      mq = new MiscQuantity(42.42);
      expect(mq, isNotNull);
      expect(mq.valueSI is Double, true);
      expect(mq.valueSI.toDouble(), 42.42);
      expect(mq.dimensions, isNotNull);
      expect(mq.dimensions, Scalar.scalarDimensions);
      expect(mq.relativeUncertainty, 0.0);
      expect(mq.preferredUnits, isNull);

      // Number (Integer) value only
      mq = new MiscQuantity(new Integer(56));
      expect(mq, isNotNull);
      expect(mq.valueSI is Integer, true);
      expect(mq.valueSI.toDouble(), 56.0);
      expect(mq.dimensions, isNotNull);
      expect(mq.dimensions, Scalar.scalarDimensions);
      expect(mq.relativeUncertainty, 0.0);
      expect(mq.preferredUnits, isNull);

      // Number (Double) value only
      mq = new MiscQuantity(new Double(67.89));
      expect(mq, isNotNull);
      expect(mq.valueSI is Double, true);
      expect(mq.valueSI.toDouble(), 67.89);
      expect(mq.dimensions, isNotNull);
      expect(mq.dimensions, Scalar.scalarDimensions);
      expect(mq.relativeUncertainty, 0.0);
      expect(mq.preferredUnits, isNull);

      // with Dimensions
      mq = new MiscQuantity(42.42, Angle.angleDimensions);
      expect(mq, isNotNull);
      expect(mq.dimensions, isNotNull);
      expect(mq.dimensions, Angle.angleDimensions);

      final MiscQuantity q =
          const MiscQuantity.constant(const Double.constant(42.42), const Dimensions.constant(const <String, int>{'Amount': 2}));
      expect(q, isNotNull);

      /*
      /// const
      const MiscQuantity cmq = const MiscQuantity.constant(
          Double.THOUSAND, Angle.ANGLEdimensions, Angle.radians, 0.2);
      expect(cmq, isNotNull);
      */
    });
  });
}
