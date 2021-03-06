package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

using haxe.numeric.Numeric;

/**
 * 8-bit unsigned signed integer.
 * `UInt8` represents values ranging from 0 to 255 (including).
 *
 * On platforms which don't have native uint8 at runtime `UInt8` is represented by `Int`.
 *
 * If the right side operand of a bitwise shift is negative or takes more than 7 bits,
 * then only 7 less significant bits of it is used:
 * ```haxe
 * UInt8.create(1) << -1
 * //is basically the same as
 * UInt8.create(1) << (-1 & 0x7)
 * ```
 *
 * Types of arithmetic.
 *
 * For binary operations addition, subtraction, multiplication and modulo general rule is
 * if both operands are `UInt8` then the result will be `UInt8` too.
 * Otherwise the type of result will depend on the types of both arguments.
 * For division the result will always be `Float`.
 * For bitwise shifts if the left side operand is `UInt8` the result type is `UInt8` too.
 * For exact result types depending on operand types refer to specification tests of `UInt8`
 *
 * Overflow.
 *
 * If the value calculated for `UInt8` or provided to `UInt8.create(value)`
 * does not fit `UInt8` bounds (from 0 to 255, including) then overflow happens.
 * The overflow behavior depends on compilation settings.
 * In `-debug` builds or with `-D OVERFLOW_THROW` an exception of type
 * `haxe.numeric.exceptions.OverflowException` is thrown.
 * In release builds or with `-D OVERFLOW_WRAP` only 8 less significant bits are used.
 * That is `UInt8.create(514)` is equal to `UInt8.create(2)` because `514 & 0xFF == 2`
 *
 * Type conversions.
 *
 * `UInt8` can be converted to `Int`:
 * ```haxe
 * UInt8.MAX.toInt() == 255;
 * ```
 * To convert `UInt8` to other integer types refer to `haxe.numeric.Numeric.UInt8Utils` methods.
 */
@:allow(haxe.numeric)
abstract UInt8(Int) {
	static inline var MAX_AS_INT = 0xFF;
	static inline var MIN_AS_INT = 0;

	static public inline var MAX:UInt8 = new UInt8(MAX_AS_INT);
	static public inline var MIN:UInt8 = new UInt8(MIN_AS_INT);

	static inline var BITS_COUNT = 8;

	/**
	 * Creates UInt8 with `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` is outside of `UInt8` bounds then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` is outside of `UInt8` bounds then only 8 less significant bits are used.
	 * That is `UInt8.create(514)` is equal to `UInt8.create(2)` because `514 & 0xFF == 2`
	 */
	static public inline function create(value:Int):UInt8 {
		if(value > MAX_AS_INT || value < MIN_AS_INT) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			throw new OverflowException('$value overflows UInt8');
			#else
			return new UInt8(value & 0xFF);
			#end
		} else {
			return new UInt8(value);
		}
	}

	/**
	 * Parse string binary representation of a number into `UInt8` value.
	 * E.g. `parseBits("1100 1100")` will produce `204`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string is less or greater than 8
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 */
	@:noUsing
	static public function parseBits(bits:String):UInt8 {
		return new UInt8(inline Numeric.parseBitsInt(bits, UInt8.BITS_COUNT));
	}

	inline function new(value:Int) {
		this = value;
	}

	public inline function toString():String {
		return '$this';
	}

	/**
	 * Convert `UInt8` to `Int`
	 */
	public inline function toInt():Int {
		return this;
	}

	@:op(-A) inline function negative():Int {
		return -this;
	}

	@:op(++A) inline function prefixIncrement():UInt8 {
		this = create(this + 1).toInt();
		return new UInt8(this);
	}

	@:op(A++) inline function postfixIncrement():UInt8 {
		var result = new UInt8(this);
		this = create(this + 1).toInt();
		return result;
	}

	@:op(--A) inline function prefixDecrement():UInt8 {
		this = create(this - 1).toInt();
		return new UInt8(this);
	}

	@:op(A--) inline function postfixDecrement():UInt8 {
		var result = new UInt8(this);
		this = create(this - 1).toInt();
		return result;
	}

	@:op(A + B) inline function addition(b:UInt8):UInt8 {
		return create(this + b.toInt());
	}
	@:op(A + B) function additionInt8(b:Int8):Int;
	@:op(A + B) function additionInt16(b:Int16):Int;
	@:op(A + B) function additionUInt16(b:UInt16):Int;
	@:op(A + B) @:commutative static function additionInt(a:UInt8, b:Int):Int;
	@:op(A + B) @:commutative static function additionFloat(a:UInt8, b:Float):Float;

	@:op(A - B) inline function subtraction(b:UInt8):UInt8 {
		return create(this - b.toInt());
	}
	@:op(A - B) function subtractionInt8(b:Int8):Int;
	@:op(A - B) function subtractionInt16(b:Int16):Int;
	@:op(A - B) function subtractionUInt16(b:UInt16):Int;
	@:op(A - B) static function subtractionFirstInt(a:UInt8, b:Int):Int;
	@:op(A - B) static function subtractionSecondInt(a:Int, b:UInt8):Int;
	@:op(A - B) static function subtractionFirstFloat(a:UInt8, b:Float):Float;
	@:op(A - B) static function subtractionSecondFloat(a:Float, b:UInt8):Float;

	@:op(A * B) inline function multiplication(b:UInt8):UInt8 {
		return create(this * b.toInt());
	}
	@:op(A * B) function multiplicationInt8(b:Int8):Int;
	@:op(A * B) function multiplicationInt16(b:Int16):Int;
	@:op(A * B) function multiplicationUInt16(b:UInt16):Int;
	@:op(A * B) @:commutative static function multiplicationInt(a:UInt8, b:Int):Int;
	@:op(A * B) @:commutative static function multiplicationFloat(a:UInt8, b:Float):Float;

	@:op(A / B) function division(b:UInt8):Float;
	@:op(A / B) function divisionFirstInt8(b:Int8):Float;
	@:op(A / B) function divisionFirstInt16(b:Int16):Float;
	@:op(A / B) function divisionFirstUInt16(b:UInt16):Float;
	@:op(A / B) static function divisionFirstInt(a:UInt8, b:Int):Float;
	@:op(A / B) static function divisionSecondInt(a:Int, b:UInt8):Float;
	@:op(A / B) static function divisionFirstFloat(a:UInt8, b:Float):Float;
	@:op(A / B) static function divisionSecondFloat(a:Float, b:UInt8):Float;

	@:op(A % B) function modulo(b:UInt8):UInt8;
	@:op(A % B) function moduloInt8(b:Int8):UInt8;
	@:op(A % B) function moduloInt16(b:Int16):UInt8;
	@:op(A % B) function moduloUInt16(b:UInt16):UInt8;
	@:op(A % B) static function moduloFirstInt(a:UInt8, b:Int):UInt8;
	@:op(A % B) static function moduloSecondInt(a:Int, b:UInt8):UInt8;
	@:op(A % B) static function moduloFirstFloat(a:UInt8, b:Float):Float;
	@:op(A % B) static function moduloSecondFloat(a:Float, b:UInt8):Float;

	@:op(A == B) function equal(b:UInt8):Bool;
	@:op(A == B) function equalInt8(b:Int8):Bool;
	@:op(A == B) function equalInt16(b:Int16):Bool;
	@:op(A == B) function equalUInt16(b:UInt16):Bool;
	@:op(A == B) @:commutative static function equalInt(a:UInt8, b:Int):Bool;
	@:op(A == B) @:commutative static function equalFloat(a:UInt8, b:Float):Bool;

	@:op(A != B) function notEqual(b:UInt8):Bool;
	@:op(A != B) function notEqualInt8(b:Int8):Bool;
	@:op(A != B) function notEqualInt16(b:Int16):Bool;
	@:op(A != B) function notEqualUInt16(b:UInt16):Bool;
	@:op(A != B) @:commutative static function notEqualInt(a:UInt8, b:Int):Bool;
	@:op(A != B) @:commutative static function notEqualFloat(a:UInt8, b:Float):Bool;

	@:op(A > B) function greater(b:UInt8):Bool;
	@:op(A > B) function greaterInt8(b:Int8):Bool;
	@:op(A > B) function greaterInt16(b:Int16):Bool;
	@:op(A > B) function greaterUInt16(b:UInt16):Bool;
	@:op(A > B) static function greaterFirstInt(a:UInt8, b:Int):Bool;
	@:op(A > B) static function greaterSecondInt(a:Int, b:UInt8):Bool;
	@:op(A > B) static function greaterFirstFloat(a:UInt8, b:Float):Bool;
	@:op(A > B) static function greaterSecondFloat(a:Float, b:UInt8):Bool;

	@:op(A >= B) function greaterOrEqual(b:UInt8):Bool;
	@:op(A >= B) function greaterOrEqualInt8(b:Int8):Bool;
	@:op(A >= B) function greaterOrEqualInt16(b:Int16):Bool;
	@:op(A >= B) function greaterOrEqualUInt16(b:UInt16):Bool;
	@:op(A >= B) static function greaterOrEqualFirstInt(a:UInt8, b:Int):Bool;
	@:op(A >= B) static function greaterOrEqualSecondInt(a:Int, b:UInt8):Bool;
	@:op(A >= B) static function greaterOrEqualFirstFloat(a:UInt8, b:Float):Bool;
	@:op(A >= B) static function greaterOrEqualSecondFloat(a:Float, b:UInt8):Bool;

	@:op(A < B) function less(b:UInt8):Bool;
	@:op(A < B) function lessInt8(b:Int8):Bool;
	@:op(A < B) function lessInt16(b:Int16):Bool;
	@:op(A < B) function lessUInt16(b:UInt16):Bool;
	@:op(A < B) static function lessFirstInt(a:UInt8, b:Int):Bool;
	@:op(A < B) static function lessSecondInt(a:Int, b:UInt8):Bool;
	@:op(A < B) static function lessFirstFloat(a:UInt8, b:Float):Bool;
	@:op(A < B) static function lessSecondFloat(a:Float, b:UInt8):Bool;

	@:op(A <= B) function lessOrEqual(b:UInt8):Bool;
	@:op(A <= B) function lessOrEqualInt8(b:Int8):Bool;
	@:op(A <= B) function lessOrEqualInt16(b:Int16):Bool;
	@:op(A <= B) function lessOrEqualUInt16(b:UInt16):Bool;
	@:op(A <= B) static function lessOrEqualFirstInt(a:UInt8, b:Int):Bool;
	@:op(A <= B) static function lessOrEqualSecondInt(a:Int, b:UInt8):Bool;
	@:op(A <= B) static function lessOrEqualFirstFloat(a:UInt8, b:Float):Bool;
	@:op(A <= B) static function lessOrEqualSecondFloat(a:Float, b:UInt8):Bool;

	@:op(~A) inline function negate():UInt8 {
		var value = ~this;
		return new UInt8(value < 0 ? value + 1 + MAX_AS_INT : value);
	}

	// &
	@:op(A & B) function and(b:UInt8):UInt8;
	@:op(A & B) inline function andInt8(b:Int8):Int {
		return this & b.toIntBits();
	}
	@:op(A & B) inline function andInt16(b:Int16):Int {
		return this & b.toIntBits();
	}
	@:op(A & B) inline function andUInt16(b:UInt16):Int {
		return this & b.toInt();
	}
	@:op(A & B) @:commutative static function andInt(a:UInt8, b:Int):Int;

	// |
	@:op(A | B) function or(b:UInt8):UInt8;
	@:op(A | B) inline function orInt8(b:Int8):Int {
		return this | b.toIntBits();
	}
	@:op(A | B) inline function orInt16(b:Int16):Int {
		return this | b.toIntBits();
	}
	@:op(A | B) inline function orUInt16(b:UInt16):Int {
		return this | b.toInt();
	}
	@:op(A | B) @:commutative static function orInt(a:UInt8, b:Int):Int;


	// ^
	@:op(A ^ B) function xor(b:UInt8):UInt8;
	@:op(A ^ B) inline function xorInt8(b:Int8):Int {
		return this ^ b.toIntBits();
	}
	@:op(A ^ B) inline function xorInt16(b:Int16):Int {
		return this ^ b.toIntBits();
	}
	@:op(A ^ B) inline function xorUInt16(b:UInt16):Int {
		return this ^ b.toInt();
	}
	@:op(A ^ B) @:commutative static function xorInt(a:UInt8, b:Int):Int;

	// <<
	@:op(A << B) inline function shiftLeft(b:UInt8):UInt8 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftInt8(b:Int8):UInt8 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftInt16(b:Int16):UInt8 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftUInt16(b:UInt16):UInt8 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftFirstInt(b:Int):UInt8 {
		var bits = (this << (b & 0x7)) & 0xFF;
		return new UInt8(bits);
	}
	@:op(A << B) static function shiftLeftSecondInt(a:Int, b:UInt8):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:UInt8):UInt8 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightInt8(b:Int8):UInt8 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightInt16(b:Int16):UInt8 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightUInt16(b:UInt16):UInt8 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightFirstInt(b:Int):UInt8 {
		var result = this >> (b & 0x7);
		return new UInt8(result);
	}
	@:op(A >> B) static function shiftRightSecondInt(a:Int, b:UInt8):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:UInt8):UInt8 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightInt8(b:Int8):UInt8 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightInt16(b:Int16):UInt8 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightUInt16(b:UInt16):UInt8 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightFirstInt(b:Int):UInt8 {
		var result = this >> (b & 0x7);
		return new UInt8(result);
	}
	@:op(A >>> B) static function unsignedShiftRightSecondInt(a:Int, b:UInt8):Int;
}