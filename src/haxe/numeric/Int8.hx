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
 * If the right side operand of a bitwise shift is negative or takes more than 7 bits,
 * then only 7 less significant bits of it is used:
 * ```haxe
 * Int8.create(1) << -1
 * //is basically the same as
 * Int8.create(1) << (-1 & 0x7)
 * ```
 *
 * Types of arithmetic.
 *
 * For binary operations addition, subtraction, multiplication and modulo general rule is
 * if both operands are `Int8` then the result will be `Int8` too.
 * Otherwise the type of result will depend on the types of both arguments.
 * For division the result will always be `Float`.
 * For bitwise shifts if the left side operand is `Int8` the result type is `Int8` too.
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
@:allow(haxe.numeric)
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
	 * Creates `Int8` from 8 less significant bits of `value`.
	 *
	 * ```haxe
	 * using haxe.numeric.Numeric
	 *
	 * 255.toInt8Bits() == Int8.create(-1);
	 * ```
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` has non-zeros on 9th or more significant bits
	 * then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` has non-zeros on 9th or more significant bits
	 * then only 8 less significant bits are used.
	 * That is `Int8.create(514)` is equal to `Int8.create(2)` because `514 & 0xFF == 2`
	 */
	static public inline function createBits(value:Int):Int8 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if(value & ~0xFF != 0) {
			throw new OverflowException('$value has non-zeros on 9th or more significant bits');
		}
		#end
		return new Int8(bitsToValue(value & 0xFF));
	}

	/**
	 * Parse string binary representation of a number into `Int8` value.
	 * E.g. `parseBits("1000 0010")` will produce `130`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string is less or greater than 8
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
	@:op(A + B) function additionUInt8(b:UInt8):Int;
	@:op(A + B) function additionInt16(b:Int16):Int;
	@:op(A + B) function additionUInt16(b:UInt16):Int;
	@:op(A + B) @:commutative static function additionIint(a:Int8, b:Int):Int;
	@:op(A + B) @:commutative static function additionFloat(a:Int8, b:Float):Float;

	@:op(A - B) inline function subtraction(b:Int8):Int8 {
		return create(this - b.toInt());
	}
	@:op(A - B) function subtractionUInt8(b:UInt8):Int;
	@:op(A - B) function subtractionInt16(b:Int16):Int;
	@:op(A - B) function subtractionUInt16(b:UInt16):Int;
	@:op(A - B) static function subtractionFirstInt(a:Int8, b:Int):Int;
	@:op(A - B) static function subtractionSecondInt(a:Int, b:Int8):Int;
	@:op(A - B) static function subtractionFirstFloat(a:Int8, b:Float):Float;
	@:op(A - B) static function subtractionSecondFloat(a:Float, b:Int8):Float;

	@:op(A * B) inline function multiplication(b:Int8):Int8 {
		return create(this * b.toInt());
	}
	@:op(A * B) function multiplicationUInt8(b:UInt8):Int;
	@:op(A * B) function multiplicationInt16(b:Int16):Int;
	@:op(A * B) function multiplicationUInt16(b:UInt16):Int;
	@:op(A * B) @:commutative static function multiplicationInt(a:Int8, b:Int):Int;
	@:op(A * B) @:commutative static function multiplicationFloat(a:Int8, b:Float):Float;

	@:op(A / B) function division(b:Int8):Float;
	@:op(A / B) function divisionUInt8(b:UInt8):Float;
	@:op(A / B) function divisionInt16(b:Int16):Float;
	@:op(A / B) function divisionUInt16(b:UInt16):Float;
	@:op(A / B) static function divisionFirstInt(a:Int8, b:Int):Float;
	@:op(A / B) static function divisionSecondInt(a:Int, b:Int8):Float;
	@:op(A / B) static function divisionFirstFloat(a:Int8, b:Float):Float;
	@:op(A / B) static function divisionSecondFloat(a:Float, b:Int8):Float;

	@:op(A % B) function modulo(b:Int8):Int8;
	@:op(A % B) function moduloUInt8(b:UInt8):Int8;
	@:op(A % B) function moduloInt16(b:Int16):Int8;
	@:op(A % B) function moduloUInt16(b:UInt16):Int8;
	@:op(A % B) static function moduloFirstInt(a:Int8, b:Int):Int8;
	@:op(A % B) static function moduloSecondIint(a:Int, b:Int8):Int8;
	@:op(A % B) static function moduloFirstFloat(a:Int8, b:Float):Float;
	@:op(A % B) static function moduloSecondFloat(a:Float, b:Int8):Float;

	@:op(A == B) function equal(b:Int8):Bool;
	@:op(A == B) function equalUInt8(b:UInt8):Bool;
	@:op(A == B) function equalInt16(b:Int16):Bool;
	@:op(A == B) function equalUInt16(b:UInt16):Bool;
	@:op(A == B) @:commutative static function equalInt(a:Int8, b:Int):Bool;
	@:op(A == B) @:commutative static function equalFloat(a:Int8, b:Float):Bool;

	@:op(A != B) function notEqual(b:Int8):Bool;
	@:op(A != B) function notEqualUInt8(b:UInt8):Bool;
	@:op(A != B) function notEqualInt16(b:Int16):Bool;
	@:op(A != B) function notEqualUInt16(b:UInt16):Bool;
	@:op(A != B) @:commutative static function notEqualInt(a:Int8, b:Int):Bool;
	@:op(A != B) @:commutative static function notEqualFloat(a:Int8, b:Float):Bool;

	@:op(A > B) function greater(b:Int8):Bool;
	@:op(A > B) function greaterUInt8(b:UInt8):Bool;
	@:op(A > B) function greaterInt16(b:Int16):Bool;
	@:op(A > B) function greaterUInt16(b:UInt16):Bool;
	@:op(A > B) static function greaterFirstInt(a:Int8, b:Int):Bool;
	@:op(A > B) static function greaterSecondInt(a:Int, b:Int8):Bool;
	@:op(A > B) static function greaterFirstFloat(a:Int8, b:Float):Bool;
	@:op(A > B) static function greaterSecondFloat(a:Float, b:Int8):Bool;

	@:op(A >= B) function greaterOrEqual(b:Int8):Bool;
	@:op(A >= B) function greaterOrEqualUInt8(b:UInt8):Bool;
	@:op(A >= B) function greaterOrEqualInt16(b:Int16):Bool;
	@:op(A >= B) function greaterOrEqualUInt16(b:UInt16):Bool;
	@:op(A >= B) static function greaterOrEqualFirstInt(a:Int8, b:Int):Bool;
	@:op(A >= B) static function greaterOrEqualSecondInt(a:Int, b:Int8):Bool;
	@:op(A >= B) static function greaterOrEqualFirstFloat(a:Int8, b:Float):Bool;
	@:op(A >= B) static function greaterOrEqualSecondFloat(a:Float, b:Int8):Bool;

	@:op(A < B) function less(b:Int8):Bool;
	@:op(A < B) function lessUInt8(b:UInt8):Bool;
	@:op(A < B) function lessInt16(b:Int16):Bool;
	@:op(A < B) function lessUInt16(b:UInt16):Bool;
	@:op(A < B) static function lessFirstInt(a:Int8, b:Int):Bool;
	@:op(A < B) static function lessSecondInt(a:Int, b:Int8):Bool;
	@:op(A < B) static function lessFirstFloat(a:Int8, b:Float):Bool;
	@:op(A < B) static function lessSecondFloat(a:Float, b:Int8):Bool;

	@:op(A <= B) function lessOrEqual(b:Int8):Bool;
	@:op(A <= B) function lessOrEqualUInt8(b:UInt8):Bool;
	@:op(A <= B) function lessOrEqualInt16(b:Int16):Bool;
	@:op(A <= B) function lessOrEqualUInt16(b:UInt16):Bool;
	@:op(A <= B) static function lessOrEqualFirstInt(a:Int8, b:Int):Bool;
	@:op(A <= B) static function lessOrEqualSecondInt(a:Int, b:Int8):Bool;
	@:op(A <= B) static function lessOrEqualFirstFloat(a:Int8, b:Float):Bool;
	@:op(A <= B) static function lessOrEqualSecondFloat(a:Float, b:Int8):Bool;

	@:op(~A) function negate():Int8;

	// &
	@:op(A & B) function and(b:Int8):Int8;
	@:op(A & B) inline function andUInt8(b:UInt8):Int {
		return valueToBits(this) & b.toInt();
	}
	@:op(A & B) inline function andInt16(b:Int16):Int {
		return valueToBits(this) & Int16.valueToBits(b.toInt());
	}
	@:op(A & B) inline function andUInt16(b:UInt16):Int {
		return valueToBits(this) & b.toInt();
	}
	@:op(A & B) @:commutative static inline function andInt(a:Int8, b:Int):Int {
		return valueToBits(a.toInt()) & b;
	}

	// |
	@:op(A | B) function or(b:Int8):Int8;
	@:op(A | B) inline function orUInt8(b:UInt8):Int {
		return valueToBits(this) | b.toInt();
	}
	@:op(A | B) inline function orInt16(b:Int16):Int {
		return valueToBits(this) | valueToBits(b.toInt());
	}
	@:op(A | B) inline function orUInt16(b:UInt16):Int {
		return valueToBits(this) | b.toInt();
	}
	@:op(A | B) @:commutative static inline function orInt(a:Int8, b:Int):Int {
		return valueToBits(a.toInt()) | b;
	}

	// ^
	@:op(A ^ B) function xor(b:Int8):Int8;
	@:op(A ^ B) inline function xorUInt8(b:UInt8):Int {
		return valueToBits(this) ^ b.toInt();
	}
	@:op(A ^ B) inline function xorInt16(b:Int16):Int {
		return valueToBits(this) ^ Int16.valueToBits(b.toInt());
	}
	@:op(A ^ B) inline function xorUInt16(b:UInt16):Int {
		return valueToBits(this) ^ b.toInt();
	}
	@:op(A ^ B) @:commutative static inline function xorInt(a:Int8, b:Int):Int {
		return valueToBits(a.toInt()) ^ b;
	}

	// <<
	@:op(A << B) inline function shiftLeft(b:Int8):Int8 {
		return shiftLeftFirstInt(valueToBits(b.toInt()));
	}
	@:op(A << B) inline function shiftLeftUInt8(b:UInt8):Int8 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftInt16(b:Int16):Int8 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftUInt16(b:UInt16):Int8 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftFirstInt(b:Int):Int8 {
		var bits = (this << (b & 0x7)) & 0xFF;
		return new Int8(bitsToValue(bits));
	}
	@:op(A << B) static function shiftLeftSecondInt(a:Int, b:Int8):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:Int8):Int8 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightUInt8(b:UInt8):Int8 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightInt16(b:Int16):Int8 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightUInt16(b:UInt16):Int8 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightFirstInt(b:Int):Int8 {
		var result = this >> (b & 0x7);
		return new Int8(result);
	}
	@:op(A >> B) static function shiftRightSecondInt(a:Int, b:Int8):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:Int8):Int8 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightUInt8(b:UInt8):Int8 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightInt16(b:Int16):Int8 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightUInt16(b:UInt16):Int8 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightFirstInt(b:Int):Int8 {
		var result = valueToBits(this) >> (b & 0x7);
		return new Int8(result);
	}
	@:op(A >>> B) static function unsignedShiftRightSecondInt(a:Int, b:Int8):Int;
}