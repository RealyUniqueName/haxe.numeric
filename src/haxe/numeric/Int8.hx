package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

/**
 * 8-bit signed integer.
 * `Int8` represents values ranging from -128 to 127 (including).
 *
 * On platforms which don't have native int8 at runtime `Int8` is represented by `Int` of the same value.
 * That is, `Int8.create(-1)` is `-1` at runtime.
 * However for bitwise operations actual 8-bit representation is used:
 * ```haxe
 * Int8.parseBits('0111 1111') == 127;            // true
 * Int8.parseBits('0111 1111') << 1 == -2;        // true
 * // But
 * Int8.parseBits('0111 1111').toInt() << 1 == 254; // also true
 * ```
 *
 * Types of arithmetic.
 *
 * For binary operations addition, subtraction, multiplication and modulo general rule is
 * if both operands are `Int8` then the result will be `Int8` too.
 * Otherwise the type of result will depend on the types of both arguments.
 * For division the result will always be `Float`.
 * For exact result types depending on operand types refer to specification tests of `Int8`
 *
 * Overflow.
 *
 * If the value calculated for `Int8` or provided to `Int8.create(value)`
 * does not fit `Int8` bounds (from -128 to 127, including) then overflow happens.
 * The overflow behavior depends on compilation settings.
 * In `-debug` builds or with `-D OVERFLOW_THROW` an exception of type
 * `haxe.numeric.exceptions.OverflowException` is thrown.
 * In release builds or with `-D OVERFLOW_WRAP` only 8 less significant bits are used.
 * That is `Int8.create(514)` is equal to `Int8.create(2)` because `514 & 0xFF == 2`
 *
 * Type conversions.
 *
 * `Int8` can be converted to `Int` by value:
 * ```haxe
 * Int8.MIN.toInt() == -1;
 * ```
 * and by bits:
 * ```haxe
 * using haxe.numeric.Numeric;
 *
 * Int8.MIN.toIntBits() == 255;
 * ```
 * To convert `Int8` to other integer types refer to `haxe.numeric.Numeric.Int8Utils` methods.
 */
abstract Int8(Int) {
	static inline var MAX_AS_INT = 0x7F;
	static inline var MIN_AS_INT = -0x80;
	static inline var BITS_COUNT = 8;

	/** Maximum `Int8` value: `127` */
	static public inline var MAX:Int8 = new Int8(MAX_AS_INT);
	/** Minimum `Int8` value: `-128` */
	static public inline var MIN:Int8 = new Int8(MIN_AS_INT);


	/**
	 * Creates Int8 from `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` is outside of `Int8` bounds then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` is outside of `Int8` bounds then only 8 less significant bits are used.
	 * That is `Int8.create(514)` is equal to `Int8.create(2)` because `514 & 0xFF == 2`
	 */
	static public inline function create(value:Int):Int8 {
		if(value > MAX_AS_INT || value < MIN_AS_INT) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			throw new OverflowException('$value overflows Int8');
			#else
			return new Int8(bitsToValue(value & 0xFF));
			#end
		} else {
			return new Int8(value);
		}
	}

	/**
	 * Parse string binary representation of a number into `Int8` value.
	 * E.g. `parseBits("1000 0010")` will produce `130`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string less or greater than 8
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 */
	@:noUsing
	static public function parseBits(bits:String):Int8 {
		return new Int8(bitsToValue(inline Numeric.parseBitsInt(bits, BITS_COUNT)));
	}

	/**
	 * `bits` must be greater or equal to `MIN_AS_INT` and lesser or equal to `0xFF`
	 */
	static inline function bitsToValue(bits:Int):Int {
		return if(bits > MAX_AS_INT) {
			(bits - MAX_AS_INT - 1) + MIN_AS_INT;
		} else {
			bits;
		}
	}

	/**
	 * `value` must be in bounds of Int8 range
	 */
	static inline function valueToBits(value:Int):Int {
		return if(value < 0) {
			value - MIN_AS_INT + 1 + MAX_AS_INT;
		} else {
			value;
		}
	}

	inline function new(value:Int) {
		this = value;
	}

	/**
	 * Convert `Int8` to `Int` by value.
	 * ```haxe
	 * Int8.create(-1).toInt() == -1
	 * ```
	 *
	 * For binary conversion see `Int8Utils.toIntBits` method in `haxe.numeric.Numeric` module
	 */
	public inline function toInt():Int {
		return this;
	}

	public inline function toString():String {
		return '$this';
	}

	@:op(-A) inline function negative():Int8 {
		return create(-this);
	}

	@:op(++A) inline function prefixIncrement():Int8 {
		this = create(this + 1).toInt();
		return new Int8(this);
	}

	@:op(A++) inline function postfixIncrement():Int8 {
		var result = new Int8(this);
		this = create(this + 1).toInt();
		return result;
	}

	@:op(--A) inline function prefixDecrement():Int8 {
		this = create(this - 1).toInt();
		return new Int8(this);
	}

	@:op(A--) inline function postfixDecrement():Int8 {
		var result = new Int8(this);
		this = create(this - 1).toInt();
		return result;
	}

	@:op(A + B) inline function addition(b:Int8):Int8 {
		return create(this + b.toInt());
	}
	@:op(A + B) function uint8Addition(b:UInt8):Int;
	@:op(A + B) @:commutative static function intAddition(a:Int8, b:Int):Int;
	@:op(A + B) @:commutative static function floatAddition(a:Int8, b:Float):Float;

	@:op(A - B) inline function subtraction(b:Int8):Int8 {
		return create(this - b.toInt());
	}
	@:op(A - B) function uint8Subtraction(b:UInt8):Int;
	@:op(A - B) static function intSubtractionFirst(a:Int8, b:Int):Int;
	@:op(A - B) static function intSubtractionSecond(a:Int, b:Int8):Int;
	@:op(A - B) static function floatSubtractionFirst(a:Int8, b:Float):Float;
	@:op(A - B) static function floatSubtractionSecond(a:Float, b:Int8):Float;

	@:op(A * B) inline function multiplication(b:Int8):Int8 {
		return create(this * b.toInt());
	}
	@:op(A * B) function uint8Addition(b:UInt8):Int;
	@:op(A * B) @:commutative static function intMultiplication(a:Int8, b:Int):Int;
	@:op(A * B) @:commutative static function floatMultiplication(a:Int8, b:Float):Float;

	@:op(A / B) function division(b:Int8):Float;
	@:op(A / B) function uint8Division(b:UInt8):Float;
	@:op(A / B) static function intDivisionFirst(a:Int8, b:Int):Float;
	@:op(A / B) static function intDivisionSecond(a:Int, b:Int8):Float;
	@:op(A / B) static function floatDivisionFirst(a:Int8, b:Float):Float;
	@:op(A / B) static function floatDivisionSecond(a:Float, b:Int8):Float;

	@:op(A % B) function modulo(b:Int8):Int8;
	@:op(A % B) function uint8Modulo(b:UInt8):Int8;
	@:op(A % B) static function intModuloFirst(a:Int8, b:Int):Int8;
	@:op(A % B) static function intModuloSecond(a:Int, b:Int8):Int8;
	@:op(A % B) static function floatModuloFirst(a:Int8, b:Float):Float;
	@:op(A % B) static function floatModuloSecond(a:Float, b:Int8):Float;

	@:op(A == B) function equal(b:Int8):Bool;
	@:op(A == B) function uint8Equal(b:UInt8):Bool;
	@:op(A == B) @:commutative static function intEqual(a:Int8, b:Int):Bool;
	@:op(A == B) @:commutative static function floatEqual(a:Int8, b:Float):Bool;

	@:op(A != B) function notEqual(b:Int8):Bool;
	@:op(A != B) function uint8NotEqual(b:UInt8):Bool;
	@:op(A != B) @:commutative static function intNotEqual(a:Int8, b:Int):Bool;
	@:op(A != B) @:commutative static function floatNotEqual(a:Int8, b:Float):Bool;

	@:op(A > B) function greater(b:Int8):Bool;
	@:op(A > B) function uint8Greater(b:UInt8):Bool;
	@:op(A > B) static function intGreaterFirst(a:Int8, b:Int):Bool;
	@:op(A > B) static function intGreaterSecond(a:Int, b:Int8):Bool;
	@:op(A > B) static function floatGreaterFirst(a:Int8, b:Float):Bool;
	@:op(A > B) static function floatGreaterSecond(a:Float, b:Int8):Bool;

	@:op(A >= B) function greaterOrEqual(b:Int8):Bool;
	@:op(A >= B) function uint8GreaterOrEqual(b:UInt8):Bool;
	@:op(A >= B) static function intGreaterOrEqualFirst(a:Int8, b:Int):Bool;
	@:op(A >= B) static function intGreaterOrEqualSecond(a:Int, b:Int8):Bool;
	@:op(A >= B) static function floatGreaterOrEqualFirst(a:Int8, b:Float):Bool;
	@:op(A >= B) static function floatGreaterOrEqualSecond(a:Float, b:Int8):Bool;

	@:op(A < B) function less(b:Int8):Bool;
	@:op(A < B) function uint8Less(b:UInt8):Bool;
	@:op(A < B) static function intLessFirst(a:Int8, b:Int):Bool;
	@:op(A < B) static function intLessSecond(a:Int, b:Int8):Bool;
	@:op(A < B) static function floatLessFirst(a:Int8, b:Float):Bool;
	@:op(A < B) static function floatLessSecond(a:Float, b:Int8):Bool;

	@:op(A <= B) function lessOrEqual(b:Int8):Bool;
	@:op(A <= B) function uint8LessOrEqual(b:UInt8):Bool;
	@:op(A <= B) static function intLessOrEqualFirst(a:Int8, b:Int):Bool;
	@:op(A <= B) static function intLessOrEqualSecond(a:Int, b:Int8):Bool;
	@:op(A <= B) static function floatLessOrEqualFirst(a:Int8, b:Float):Bool;
	@:op(A <= B) static function floatLessOrEqualSecond(a:Float, b:Int8):Bool;

	@:op(~A) function negate():Int8;

	@:op(A & B) function and(b:Int8):Int8;
	@:op(A & B) inline function uint8And(b:UInt8):Int {
		return valueToBits(this) & b.toInt();
	}
	@:op(A & B) @:commutative static inline function andInt(a:Int8, b:Int):Int {
		return valueToBits(a.toInt()) & b;
	}

	@:op(A | B) function or(b:Int8):Int8;
	@:op(A | B) inline function uint8Or(b:UInt8):Int {
		return valueToBits(this) | b.toInt();
	}
	@:op(A | B) @:commutative static inline function orInt(a:Int8, b:Int):Int {
		return valueToBits(a.toInt()) | b;
	}

	@:op(A ^ B) function xor(b:Int8):Int8;
	@:op(A ^ B) inline function uint8Xor(b:UInt8):Int {
		return valueToBits(this) ^ b.toInt();
	}
	@:op(A ^ B) @:commutative static inline function xorInt(a:Int8, b:Int):Int {
		return valueToBits(a.toInt()) ^ b;
	}

	// <<
	@:op(A << B) inline function shiftLeft(b:Int8):Int8 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function uint8ShiftLeft(b:UInt8):Int8 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function intShiftLeftFirst(b:Int):Int8 {
		var bits = (this << (b & 0x7)) & 0xFF;
		return new Int8(bitsToValue(bits));
	}
	@:op(A << B) static function intShiftLeftSecond(a:Int, b:Int8):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:Int8):Int8 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function uint8ShiftRight(b:UInt8):Int8 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function intShiftRightFirst(b:Int):Int8 {
		var result = this >> (b & 0x7);
		return new Int8(result);
	}
	@:op(A >> B) static function intShiftRightSecond(a:Int, b:Int8):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:Int8):Int8 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function uint8UnsignedShiftRight(b:UInt8):Int8 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function intUnsignedShiftRightFirst(b:Int):Int8 {
		var result = valueToBits(this) >> (b & 0x7);
		return new Int8(result);
	}
	@:op(A >>> B) static function intUnsignedShiftRightSecond(a:Int, b:Int8):Int;
}