package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

/**
 * 16-bit signed integer.
 * `Int16` represents values ranging from -32768 to 32767 (including).
 *
 * On platforms which don't have native int16 at runtime `Int16` is represented by `Int` of the same value.
 * That is, `Int16.create(-1)` is `-1` at runtime.
 * However for bitwise operations actual 16-bit representation is used:
 * ```haxe
 * Int16.parseBits('0111 1111 1111 1111') == 32767;   // true
 * Int16.parseBits('0111 1111 1111 1111') << 1 == -2; // true
 * // But
 * Int16.parseBits('0111 1111 1111 1111').toInt() << 1 == 65534; // also true
 * ```
 * If the right side operand of a bitwise shift is negative or takes more than 4 bits,
 * then only 4 less significant bits of it is used:
 * ```haxe
 * Int16.create(1) << -1
 * //is basically the same as
 * Int16.create(1) << (-1 & 0xF)
 * ```
 *
 * Types of arithmetic.
 *
 * For binary operations addition, subtraction, multiplication and modulo general rule is
 * if both operands are `Int16` then the result will be `Int16` too.
 * Otherwise the type of result will depend on the types of both arguments.
 * For division the result will always be `Float`.
 * For bitwise shifts if the left side operand is `Int16` the result type is `Int16` too.
 * For exact result types depending on operand types refer to specification tests of `Int16`
 *
 * Overflow.
 *
 * If the value calculated for `Int16` or provided to `Int16.create(value)`
 * does not fit `Int16` bounds (from -32768 to 32767, including) then overflow happens.
 * The overflow behavior depends on compilation settings.
 * In `-debug` builds or with `-D OVERFLOW_THROW` an exception of type
 * `haxe.numeric.exceptions.OverflowException` is thrown.
 * In release builds or with `-D OVERFLOW_WRAP` only 16 less significant bits are used.
 * That is `Int16.create(851970)` is equal to `Int16.create(2)` because `851970 & 0xFFFF == 2`
 *
 * Type conversions.
 *
 * `Int16` can be converted to `Int` by value:
 * ```haxe
 * Int16.MIN.toInt() == -1;
 * ```
 * and by bits:
 * ```haxe
 * using haxe.numeric.Numeric;
 *
 * Int16.MIN.toIntBits() == 65535;
 * ```
 * To convert `Int16` to other integer types refer to `haxe.numeric.Numeric.Int8Utils` methods.
 */
@:allow(haxe.numeric)
abstract Int16(Int) {
	static inline var MAX_AS_INT = 0x7FFF;
	static inline var MIN_AS_INT = -0x8000;
	static inline var BITS_COUNT = 16;

	/** Maximum `Int16` value: `32767` */
	static public inline var MAX:Int16 = new Int16(MAX_AS_INT);
	/** Minimum `Int16` value: `-32768` */
	static public inline var MIN:Int16 = new Int16(MIN_AS_INT);


	/**
	 * Creates Int16 from `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` is outside of `Int16` bounds then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` is outside of `Int16` bounds then only 16 less significant bits are used.
	 * That is `Int16.create(851970)` is equal to `Int16.create(2)` because `851970 & 0xFFFF == 2`
	 */
	static public inline function create(value:Int):Int16 {
		if(value > MAX_AS_INT || value < MIN_AS_INT) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			throw new OverflowException('$value overflows Int16');
			#else
			return new Int16(bitsToValue(value & 0xFFFF));
			#end
		} else {
			return new Int16(value);
		}
	}

	/**
	 * Creates `Int16` from 16 less significant bits of `value`.
	 *
	 * ```haxe
	 * using haxe.numeric.Numeric
	 *
	 * 0xFFFF.toInt16Bits() == Int16.create(-1);
	 * ```
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` has non-zeros on 9th or more significant bits
	 * then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` has non-zeros on 9th or more significant bits
	 * then only 16 less significant bits are used.
	 * That is `Int16.create(851970)` is equal to `Int16.create(2)` because `851970 & 0xFFFF == 2`
	 */
	static public inline function createBits(value:Int):Int16 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if(value & ~0xFFFF != 0) {
			throw new OverflowException('$value has non-zeros on 17th or more significant bits');
		}
		#end
		return new Int16(bitsToValue(value & 0xFFFF));
	}

	/**
	 * Parse string binary representation of a number into `Int16` value.
	 * E.g. `parseBits("1000 0010 0000 1111")` will produce `-32241`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string is less or greater than 16
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 */
	@:noUsing
	static public function parseBits(bits:String):Int16 {
		return new Int16(bitsToValue(inline Numeric.parseBitsInt(bits, BITS_COUNT)));
	}

	/**
	 * `bits` must be greater or equal to `MIN_AS_INT` and lesser or equal to `0xFFFF`
	 */
	static inline function bitsToValue(bits:Int):Int {
		return if(bits > MAX_AS_INT) {
			(bits - MAX_AS_INT - 1) + MIN_AS_INT;
		} else {
			bits;
		}
	}

	/**
	 * `value` must be in bounds of Int16 range
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
	 * Convert `Int16` to `Int` by value.
	 * ```haxe
	 * Int16.create(-1).toInt() == -1
	 * ```
	 *
	 * For binary conversion see `Int16Utils.toIntBits` method in `haxe.numeric.Numeric` module
	 */
	public inline function toInt():Int {
		return this;
	}

	public inline function toString():String {
		return '$this';
	}

	@:op(-A) inline function negative():Int16 {
		return create(-this);
	}

	@:op(++A) inline function prefixIncrement():Int16 {
		this = create(this + 1).toInt();
		return new Int16(this);
	}

	@:op(A++) inline function postfixIncrement():Int16 {
		var result = new Int16(this);
		this = create(this + 1).toInt();
		return result;
	}

	@:op(--A) inline function prefixDecrement():Int16 {
		this = create(this - 1).toInt();
		return new Int16(this);
	}

	@:op(A--) inline function postfixDecrement():Int16 {
		var result = new Int16(this);
		this = create(this - 1).toInt();
		return result;
	}

	@:op(A + B) inline function addition(b:Int16):Int16 {
		return create(this + b.toInt());
	}
	@:op(A + B) function additionInt8(b:Int8):Int;
	@:op(A + B) function additionUInt8(b:UInt8):Int;
	@:op(A + B) function additionUInt16(b:UInt16):Int;
	@:op(A + B) @:commutative static function additionInt(a:Int16, b:Int):Int;
	@:op(A + B) @:commutative static function additionFloat(a:Int16, b:Float):Float;

	@:op(A - B) inline function subtraction(b:Int16):Int16 {
		return create(this - b.toInt());
	}
	@:op(A - B) function subtractionInt8(b:Int8):Int;
	@:op(A - B) function subtractionUInt8(b:UInt8):Int;
	@:op(A - B) function subtractionUInt16(b:UInt16):Int;
	@:op(A - B) static function subtractionFirstInt(a:Int16, b:Int):Int;
	@:op(A - B) static function subtractionSecondInt(a:Int, b:Int16):Int;
	@:op(A - B) static function subtractionFirstFloat(a:Int16, b:Float):Float;
	@:op(A - B) static function subtractionSecondFloat(a:Float, b:Int16):Float;

	@:op(A * B) inline function multiplication(b:Int16):Int16 {
		return create(this * b.toInt());
	}
	@:op(A * B) function multiplicationInt8(b:Int8):Int;
	@:op(A * B) function multiplicationUInt8(b:UInt8):Int;
	@:op(A * B) function multiplicationUInt16(b:UInt16):Int;
	@:op(A * B) @:commutative static function multiplicationInt(a:Int16, b:Int):Int;
	@:op(A * B) @:commutative static function multiplicationFloat(a:Int16, b:Float):Float;

	@:op(A / B) function division(b:Int16):Float;
	@:op(A / B) function divisionInt8(b:Int8):Float;
	@:op(A / B) function divisionUInt8(b:UInt8):Float;
	@:op(A / B) function divisionUInt16(b:UInt16):Float;
	@:op(A / B) static function divisionFirstInt(a:Int16, b:Int):Float;
	@:op(A / B) static function divisionSecondInt(a:Int, b:Int16):Float;
	@:op(A / B) static function divisionFirstFloat(a:Int16, b:Float):Float;
	@:op(A / B) static function divisionSecondFloat(a:Float, b:Int16):Float;

	@:op(A % B) function modulo(b:Int16):Int16;
	@:op(A % B) function moduloInt8(b:Int8):Int16;
	@:op(A % B) function moduloUInt8(b:UInt8):Int16;
	@:op(A % B) function moduloUInt16(b:UInt16):Int16;
	@:op(A % B) static function moduloFirstInt(a:Int16, b:Int):Int16;
	@:op(A % B) static function moduloSecondInt(a:Int, b:Int16):Int16;
	@:op(A % B) static function moduloFirstFloat(a:Int16, b:Float):Float;
	@:op(A % B) static function moduloSecondFloat(a:Float, b:Int16):Float;

	@:op(A == B) function equal(b:Int16):Bool;
	@:op(A == B) function equalInt8(b:Int8):Bool;
	@:op(A == B) function equalUInt8(b:UInt8):Bool;
	@:op(A == B) function equalUInt16(b:UInt16):Bool;
	@:op(A == B) @:commutative static function equalInt(a:Int16, b:Int):Bool;
	@:op(A == B) @:commutative static function equalFloat(a:Int16, b:Float):Bool;

	@:op(A != B) function notEqual(b:Int16):Bool;
	@:op(A != B) function notEqualInt8(b:Int8):Bool;
	@:op(A != B) function notEqualUInt8(b:UInt8):Bool;
	@:op(A != B) function notEqualUInt16(b:UInt16):Bool;
	@:op(A != B) @:commutative static function notEqualInt(a:Int16, b:Int):Bool;
	@:op(A != B) @:commutative static function notEqualFloat(a:Int16, b:Float):Bool;

	@:op(A > B) function greater(b:Int16):Bool;
	@:op(A > B) function greaterInt8(b:Int8):Bool;
	@:op(A > B) function greaterUInt8(b:UInt8):Bool;
	@:op(A > B) function greaterUInt16(b:UInt16):Bool;
	@:op(A > B) static function greaterFirstInt(a:Int16, b:Int):Bool;
	@:op(A > B) static function greaterSecondInt(a:Int, b:Int16):Bool;
	@:op(A > B) static function greaterFirstFloat(a:Int16, b:Float):Bool;
	@:op(A > B) static function greaterSecondFloat(a:Float, b:Int16):Bool;

	@:op(A >= B) function greaterOrEqual(b:Int16):Bool;
	@:op(A >= B) function greaterOrEqualInt8(b:Int8):Bool;
	@:op(A >= B) function greaterOrEqualUInt8(b:UInt8):Bool;
	@:op(A >= B) function greaterOrEqualUInt16(b:UInt16):Bool;
	@:op(A >= B) static function greaterOrEqualFirstInt(a:Int16, b:Int):Bool;
	@:op(A >= B) static function greaterOrEqualSecondInt(a:Int, b:Int16):Bool;
	@:op(A >= B) static function greaterOrEqualFirstFloat(a:Int16, b:Float):Bool;
	@:op(A >= B) static function greaterOrEqualSecondFloat(a:Float, b:Int16):Bool;

	@:op(A < B) function less(b:Int16):Bool;
	@:op(A < B) function lessInt8(b:Int8):Bool;
	@:op(A < B) function lessUInt8(b:UInt8):Bool;
	@:op(A < B) function lessUInt16(b:UInt16):Bool;
	@:op(A < B) static function lessFirstInt(a:Int16, b:Int):Bool;
	@:op(A < B) static function lessSecondInt(a:Int, b:Int16):Bool;
	@:op(A < B) static function lessFirstFloat(a:Int16, b:Float):Bool;
	@:op(A < B) static function lessSecondFloat(a:Float, b:Int16):Bool;

	@:op(A <= B) function lessOrEqual(b:Int16):Bool;
	@:op(A <= B) function lessOrEqualInt8(b:Int8):Bool;
	@:op(A <= B) function lessOrEqualUInt8(b:UInt8):Bool;
	@:op(A <= B) function lessOrEqualUInt16(b:UInt16):Bool;
	@:op(A <= B) static function lessOrEqualFirstInt(a:Int16, b:Int):Bool;
	@:op(A <= B) static function lessOrEqualSecondInt(a:Int, b:Int16):Bool;
	@:op(A <= B) static function lessOrEqualFirstFloat(a:Int16, b:Float):Bool;
	@:op(A <= B) static function lessOrEqualSecondFloat(a:Float, b:Int16):Bool;

	@:op(~A) function negate():Int16;

	@:op(A & B) function and(b:Int16):Int16;
	@:op(A & B) inline function andInt8(b:Int8):Int {
		return valueToBits(this) & Int8.valueToBits(b.toInt());
	}
	@:op(A & B) inline function andUInt8(b:UInt8):Int {
		return valueToBits(this) & b.toInt();
	}
	@:op(A & B) inline function andUInt16(b:UInt16):Int {
		return valueToBits(this) & b.toInt();
	}
	@:op(A & B) @:commutative static inline function andInt(a:Int16, b:Int):Int {
		return valueToBits(a.toInt()) & b;
	}

	@:op(A | B) function or(b:Int16):Int16;
	@:op(A | B) inline function orInt8(b:Int8):Int {
		return valueToBits(this) | Int8.valueToBits(b.toInt());
	}
	@:op(A | B) inline function orUInt8(b:UInt8):Int {
		return valueToBits(this) | b.toInt();
	}
	@:op(A | B) inline function orUInt16(b:UInt16):Int {
		return valueToBits(this) | b.toInt();
	}
	@:op(A | B) @:commutative static inline function orInt(a:Int16, b:Int):Int {
		return valueToBits(a.toInt()) | b;
	}

	@:op(A ^ B) function xor(b:Int16):Int16;
	@:op(A ^ B) inline function xorInt8(b:Int8):Int {
		return valueToBits(this) ^ Int8.valueToBits(b.toInt());
	}
	@:op(A ^ B) inline function xorUInt8(b:UInt8):Int {
		return valueToBits(this) ^ b.toInt();
	}
	@:op(A ^ B) inline function xorUInt16(b:UInt16):Int {
		return valueToBits(this) ^ b.toInt();
	}
	@:op(A ^ B) @:commutative static inline function xorInt(a:Int16, b:Int):Int {
		return valueToBits(a.toInt()) ^ b;
	}

	// <<
	@:op(A << B) inline function shiftLeft(b:Int16):Int16 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftInt8(b:Int8):Int16 {
		return shiftLeftFirstInt(Int8.valueToBits(b.toInt()));
	}
	@:op(A << B) inline function shiftLeftUInt8(b:UInt8):Int16 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftUInt16(b:UInt16):Int16 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftFirstInt(b:Int):Int16 {
		var bits = (this << (b & 0xF)) & 0xFFFF;
		return new Int16(bitsToValue(bits));
	}
	@:op(A << B) static function shiftLeftSecondInt(a:Int, b:Int16):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:Int16):Int16 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightInt8(b:Int8):Int16 {
		return shiftRightFirstInt(valueToBits(b.toInt()));
	}
	@:op(A >> B) inline function shiftRightUInt8(b:UInt8):Int16 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightUInt16(b:UInt16):Int16 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightFirstInt(b:Int):Int16 {
		var result = this >> (b & 0xF);
		return new Int16(result);
	}
	@:op(A >> B) static function shiftRightSecondInt(a:Int, b:Int16):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:Int16):Int16 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightInt8(b:Int8):Int16 {
		return unsignedShiftRightFirstInt(valueToBits(b.toInt()));
	}
	@:op(A >>> B) inline function unsignedShiftRightUInt8(b:UInt8):Int16 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightUInt16(b:UInt16):Int16 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightFirstInt(b:Int):Int16 {
		var result = valueToBits(this) >> (b & 0xF);
		return new Int16(result);
	}
	@:op(A >>> B) static function unsignedShiftRightSecondInt(a:Int, b:Int16):Int;
}