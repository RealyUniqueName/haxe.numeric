package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

using haxe.numeric.Numeric;

/**
 * 16-bit unsigned signed integer.
 * `UInt16` represents values ranging from 0 to 65535 (including).
 *
 * On platforms which don't have native uint16 at runtime `UInt16` is represented by `Int`.
 *
 * If the right side operand of a bitwise shift is negative or takes more than 4 bits,
 * then only 4 less significant bits of it is used:
 * ```haxe
 * UInt16.create(1) << -1
 * //is basically the same as
 * UInt16.create(1) << (-1 & 0xF)
 * ```
 *
 * Types of arithmetic.
 *
 * For binary operations addition, subtraction, multiplication and modulo general rule is
 * if both operands are `UInt16` then the result will be `UInt16` too.
 * Otherwise the type of result will depend on the types of both arguments.
 * For division the result will always be `Float`.
 * For bitwise shifts if the left side operand is `UInt16` the result type is `UInt16` too.
 * For exact result types depending on operand types refer to specification tests of `UInt16`
 *
 * Overflow.
 *
 * If the value calculated for `UInt16` or provided to `UInt16.create(value)`
 * does not fit `UInt16` bounds (from 0 to 65535, including) then overflow happens.
 * The overflow behavior depends on compilation settings.
 * In `-debug` builds or with `-D OVERFLOW_THROW` an exception of type
 * `haxe.numeric.exceptions.OverflowException` is thrown.
 * In release builds or with `-D OVERFLOW_WRAP` only 16 less significant bits are used.
 * That is `UInt16.create(65538)` is equal to `UInt16.create(2)` because `65538 & 0xFFFF == 2`
 *
 * Type conversions.
 *
 * `UInt16` can be converted to `Int`:
 * ```haxe
 * UInt16.MAX.toInt() == 65535;
 * ```
 * To convert `UInt16` to other integer types refer to `haxe.numeric.Numeric.UInt16Utils` methods.
 */
@:allow(haxe.numeric)
abstract UInt16(Int) {
	static inline var MAX_AS_INT = 0xFFFF;
	static inline var MIN_AS_INT = 0;

	static public inline var MAX:UInt16 = new UInt16(MAX_AS_INT);
	static public inline var MIN:UInt16 = new UInt16(MIN_AS_INT);

	static inline var BITS_COUNT = 16;

	/**
	 * Creates UInt16 with `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` is outside of `UInt16` bounds then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` is outside of `UInt16` bounds then only 16 less significant bits are used.
	 * That is `UInt16.create(65538)` is equal to `UInt16.create(2)` because `65538 & 0xFFFF == 2`
	 */
	static public inline function create(value:Int):UInt16 {
		if(value > MAX_AS_INT || value < MIN_AS_INT) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			throw new OverflowException('$value overflows UInt16');
			#else
			return new UInt16(value & 0xFFFF);
			#end
		} else {
			return new UInt16(value);
		}
	}

	/**
	 * Parse string binary representation of a number into `UInt16` value.
	 * E.g. `parseBits("1100 0000 0000 1100")` will produce `49164`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string is less or greater than 16
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 */
	@:noUsing
	static public function parseBits(bits:String):UInt16 {
		return new UInt16(inline Numeric.parseBitsInt(bits, UInt16.BITS_COUNT));
	}

	inline function new(value:Int) {
		this = value;
	}

	public inline function toString():String {
		return '$this';
	}

	/**
	 * Convert `UInt16` to `Int`
	 */
	public inline function toInt():Int {
		return this;
	}

	@:op(-A) inline function negative():Int {
		return -this;
	}

	@:op(++A) inline function prefixIncrement():UInt16 {
		this = create(this + 1).toInt();
		return new UInt16(this);
	}

	@:op(A++) inline function postfixIncrement():UInt16 {
		var result = new UInt16(this);
		this = create(this + 1).toInt();
		return result;
	}

	@:op(--A) inline function prefixDecrement():UInt16 {
		this = create(this - 1).toInt();
		return new UInt16(this);
	}

	@:op(A--) inline function postfixDecrement():UInt16 {
		var result = new UInt16(this);
		this = create(this - 1).toInt();
		return result;
	}

	@:op(A + B) inline function addition(b:UInt16):UInt16 {
		return create(this + b.toInt());
	}
	@:op(A + B) function int8Addition(b:Int8):Int;
	@:op(A + B) function uint8Addition(b:UInt8):Int;
	@:op(A + B) function int16Addition(b:Int16):Int;
	@:op(A + B) @:commutative static function intAddition(a:UInt16, b:Int):Int;
	@:op(A + B) @:commutative static function floatAddition(a:UInt16, b:Float):Float;

	@:op(A - B) inline function subtraction(b:UInt16):UInt16 {
		return create(this - b.toInt());
	}
	@:op(A - B) function int8Subtraction(b:Int8):Int;
	@:op(A - B) function uint8Subtraction(b:UInt8):Int;
	@:op(A - B) function int16Subtraction(b:Int16):Int;
	@:op(A - B) static function intSubtractionFirst(a:UInt16, b:Int):Int;
	@:op(A - B) static function intSubtractionSecond(a:Int, b:UInt16):Int;
	@:op(A - B) static function floatSubtractionFirst(a:UInt16, b:Float):Float;
	@:op(A - B) static function floatSubtractionSecond(a:Float, b:UInt16):Float;

	@:op(A * B) inline function multiplication(b:UInt16):UInt16 {
		return create(this * b.toInt());
	}
	@:op(A * B) function int8Multiplication(b:Int8):Int;
	@:op(A * B) function uint8Multiplication(b:UInt8):Int;
	@:op(A * B) function int16Multiplication(b:Int16):Int;
	@:op(A * B) @:commutative static function intMultiplication(a:UInt16, b:Int):Int;
	@:op(A * B) @:commutative static function floatMultiplication(a:UInt16, b:Float):Float;

	@:op(A / B) function division(b:UInt16):Float;
	@:op(A / B) function int8DivisionFirst(b:Int8):Float;
	@:op(A / B) function uint8DivisionFirst(b:UInt8):Float;
	@:op(A / B) function int16DivisionFirst(b:Int16):Float;
	@:op(A / B) static function intDivisionFirst(a:UInt16, b:Int):Float;
	@:op(A / B) static function intDivisionSecond(a:Int, b:UInt16):Float;
	@:op(A / B) static function floatDivisionFirst(a:UInt16, b:Float):Float;
	@:op(A / B) static function floatDivisionSecond(a:Float, b:UInt16):Float;

	@:op(A % B) function modulo(b:UInt16):UInt16;
	@:op(A % B) function int8Modulo(b:Int8):UInt16;
	@:op(A % B) function uint8Modulo(b:UInt8):UInt16;
	@:op(A % B) function int16Modulo(b:Int16):UInt16;
	@:op(A % B) static function intModuloFirst(a:UInt16, b:Int):UInt16;
	@:op(A % B) static function intModuloSecond(a:Int, b:UInt16):UInt16;
	@:op(A % B) static function floatModuloFirst(a:UInt16, b:Float):Float;
	@:op(A % B) static function floatModuloSecond(a:Float, b:UInt16):Float;

	@:op(A == B) function equal(b:UInt16):Bool;
	@:op(A == B) function int8Equal(b:Int8):Bool;
	@:op(A == B) function uint8Equal(b:UInt8):Bool;
	@:op(A == B) function int16Equal(b:Int16):Bool;
	@:op(A == B) @:commutative static function intEqual(a:UInt16, b:Int):Bool;
	@:op(A == B) @:commutative static function floatEqual(a:UInt16, b:Float):Bool;

	@:op(A != B) function notEqual(b:UInt16):Bool;
	@:op(A != B) function int8NotEqual(b:Int8):Bool;
	@:op(A != B) function uint8NotEqual(b:UInt8):Bool;
	@:op(A != B) function int16NotEqual(b:Int16):Bool;
	@:op(A != B) @:commutative static function intNotEqual(a:UInt16, b:Int):Bool;
	@:op(A != B) @:commutative static function floatNotEqual(a:UInt16, b:Float):Bool;

	@:op(A > B) function greater(b:UInt16):Bool;
	@:op(A > B) function int8Greater(b:Int8):Bool;
	@:op(A > B) function uint8Greater(b:UInt8):Bool;
	@:op(A > B) function int16Greater(b:Int16):Bool;
	@:op(A > B) static function intGreaterFirst(a:UInt16, b:Int):Bool;
	@:op(A > B) static function intGreaterSecond(a:Int, b:UInt16):Bool;
	@:op(A > B) static function floatGreaterFirst(a:UInt16, b:Float):Bool;
	@:op(A > B) static function floatGreaterSecond(a:Float, b:UInt16):Bool;

	@:op(A >= B) function greaterOrEqual(b:UInt16):Bool;
	@:op(A >= B) function int8GreaterOrEqual(b:Int8):Bool;
	@:op(A >= B) function uint8GreaterOrEqual(b:UInt8):Bool;
	@:op(A >= B) function int16GreaterOrEqual(b:Int16):Bool;
	@:op(A >= B) static function intGreaterOrEqualFirst(a:UInt16, b:Int):Bool;
	@:op(A >= B) static function intGreaterOrEqualSecond(a:Int, b:UInt16):Bool;
	@:op(A >= B) static function floatGreaterOrEqualFirst(a:UInt16, b:Float):Bool;
	@:op(A >= B) static function floatGreaterOrEqualSecond(a:Float, b:UInt16):Bool;

	@:op(A < B) function less(b:UInt16):Bool;
	@:op(A < B) function int8Less(b:Int8):Bool;
	@:op(A < B) function uint8Less(b:UInt8):Bool;
	@:op(A < B) function int16Less(b:Int16):Bool;
	@:op(A < B) static function intLessFirst(a:UInt16, b:Int):Bool;
	@:op(A < B) static function intLessSecond(a:Int, b:UInt16):Bool;
	@:op(A < B) static function floatLessFirst(a:UInt16, b:Float):Bool;
	@:op(A < B) static function floatLessSecond(a:Float, b:UInt16):Bool;

	@:op(A <= B) function lessOrEqual(b:UInt16):Bool;
	@:op(A <= B) function int8LessOrEqual(b:Int8):Bool;
	@:op(A <= B) function uint8LessOrEqual(b:UInt8):Bool;
	@:op(A <= B) function int16LessOrEqual(b:Int16):Bool;
	@:op(A <= B) static function intLessOrEqualFirst(a:UInt16, b:Int):Bool;
	@:op(A <= B) static function intLessOrEqualSecond(a:Int, b:UInt16):Bool;
	@:op(A <= B) static function floatLessOrEqualFirst(a:UInt16, b:Float):Bool;
	@:op(A <= B) static function floatLessOrEqualSecond(a:Float, b:UInt16):Bool;

	@:op(~A) inline function negate():UInt16 {
		var value = ~this;
		return new UInt16(value < 0 ? value + 1 + MAX_AS_INT : value);
	}

	// &
	@:op(A & B) function and(b:UInt16):UInt16;
	@:op(A & B) inline function andInt8(b:Int8):Int {
		return this & b.toIntBits();
	}
	@:op(A & B) function andUInt8(b:UInt8):Int;
	@:op(A & B) inline function andInt16(b:Int16):Int {
		return this & b.toIntBits();
	}
	@:op(A & B) @:commutative static function andInt(a:UInt16, b:Int):Int;

	// |
	@:op(A | B) function or(b:UInt16):UInt16;
	@:op(A | B) inline function orInt8(b:Int8):Int {
		return this | b.toIntBits();
	}
	@:op(A | B) function orUInt8(b:UInt8):Int;
	@:op(A | B) inline function orInt16(b:Int16):Int {
		return this | b.toIntBits();
	}
	@:op(A | B) @:commutative static function orInt(a:UInt16, b:Int):Int;

	// ^
	@:op(A ^ B) function xor(b:UInt16):UInt16;
	@:op(A ^ B) inline function xorInt8(b:Int8):Int {
		return this ^ b.toIntBits();
	}
	@:op(A ^ B) function xorUInt8(b:UInt8):Int;
	@:op(A ^ B) inline function xorInt16(b:Int16):Int {
		return this ^ b.toIntBits();
	}
	@:op(A ^ B) @:commutative static function xorInt(a:UInt16, b:Int):Int;

	// <<
	@:op(A << B) inline function shiftLeft(b:UInt16):UInt16 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function int8ShiftLeft(b:Int8):UInt16 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function uint8ShiftLeft(b:UInt8):UInt16 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function int16ShiftLeft(b:Int16):UInt16 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function intShiftLeftFirst(b:Int):UInt16 {
		var bits = (this << (b & 0xF)) & 0xFFFF;
		return new UInt16(bits);
	}
	@:op(A << B) static function intShiftLeftSecond(a:Int, b:UInt16):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:UInt16):UInt16 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function int8ShiftRight(b:Int8):UInt16 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function uint8ShiftRight(b:UInt8):UInt16 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function int16ShiftRight(b:Int16):UInt16 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function intShiftRightFirst(b:Int):UInt16 {
		var result = this >> (b & 0xF);
		return new UInt16(result);
	}
	@:op(A >> B) static function intShiftRightSecond(a:Int, b:UInt16):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:UInt16):UInt16 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function int8UnsignedShiftRight(b:Int8):UInt16 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function uint8UnsignedShiftRight(b:UInt8):UInt16 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function int16UnsignedShiftRight(b:Int16):UInt16 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function intUnsignedShiftRightFirst(b:Int):UInt16 {
		var result = this >> (b & 0xF);
		return new UInt16(result);
	}
	@:op(A >>> B) static function intUnsignedShiftRightSecond(a:Int, b:UInt16):Int;
}