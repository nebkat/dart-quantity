part of quantity_core;

/**
 * This Exception is thrown when an attempt is made to modify an
 * immutable Quantity object (for example through its setMKS method).
 */

class ImmutableQuantityException extends QuantityException {
  /**
   *  Constructs a new DimensionsException with an optional message (str).
   */
  ImmutableQuantityException(
      {String str: "An attempt was made to modify an immutable quantity:  ",
      Quantity q})
      : super(q.toString());
}
