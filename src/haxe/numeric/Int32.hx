package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

/**
 * 32-bit signed integer.
 * `Int32` represents values ranging from `-2 147 483 648` to `2 147 483 647` (including).
 *
 * On platforms which don't have native int32 at runtime `Int32` is represented by `Int` of the same value.
 * That is, `Int32.create(-1)` is `-1` at runtime even if target native `Int` is 64 bits.
 * However for bitwise operations actual 32-bit representation is used:
 * ```haxe
 * Int32.parseBits('0111 1111 1111 1111 1111 1111 1111 1111') == 2147483647;   // true
 * Int32.parseBits('0111 1111 1111 1111 1111 1111 1111 1111') << 1 == -2; // true
 * // But
 * Int32.parseBits('0111 1111 1111 1111 1111 1111 1111 1111').toInt() << 1 == 2147483648; // on 64bit integers platforms
 * Int32.parseBits('0111 1111 1111 1111 1111 1111 1111 1111').toInt() << 1 == -2; // on 32bit integers platforms
 * ```
 * If the right side operand of a bitwise shift is negative or takes more than 5 bits,
 * then only 5 less significant bits of it is used:
 * ```haxe
 * Int32.create(1) << -1
 * //is basically the same as
 * Int32.create(1) << (-1 & 0x1F)
 * ```
 *
 * Types of arithmetic.
 *
 * For binary operations addition, subtraction, multiplication and modulo general rule is
 * if both operands are `Int32` then the result will be `Int32` too.
 * Otherwise the type of result will depend on the types of both arguments.
 * For division the result will always be `Float`.
 * For bitwise shifts if the left side operand is `Int32` the result type is `Int32` too.
 * For exact result types depending on operand types refer to specification tests of `Int32`
 *
 * Overflow.
 *
 * If the value calculated for `Int32` or provided to `Int32.create(value)`
 * does not fit `Int32` bounds then overflow happens.
 * The overflow behavior depends on compilation settings.
 * In `-debug` builds or with `-D OVERFLOW_THROW` an exception of type
 * `haxe.numeric.exceptions.OverflowException` is thrown.
 * In release builds or with `-D OVERFLOW_WRAP` only 32 less significant bits are used.
 *
 * Type conversions.
 *
 * `Int32` can be converted to `Int` by value:
 * ```haxe
 * Int32.MIN.toInt() == -2147483648;
 * ```
 * and by bits:
 * ```haxe
 * using haxe.numeric.Numeric;
 *
 * Int32.MIN.toIntBits() == -2147483648; // with 32bit integers
 * Int32.MIN.toIntBits() == 2147483648; // with 64bit integers
 * ```
 * To convert `Int32` to other integer types refer to `haxe.numeric.Numeric.Int8Utils` methods.
 */
@:allow(haxe.numeric)
@:using(haxe.numeric.Numeric)
abstract Int32(Int) {
	static inline var MAX_AS_INT = 2147483647;
	static inline var MIN_AS_INT = -2147483648;
	static inline var BITS_COUNT = 32;

	/** Maximum `Int32` value: `2147483647` */
	static public inline var MAX:Int32 = new Int32(MAX_AS_INT);
	/** Minimum `Int32` value: `-2147483648` */
	static public inline var MIN:Int32 = new Int32(MIN_AS_INT);


	/**
	 * Creates Int32 from `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` is outside of `Int32` bounds then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` is outside of `Int32` bounds then only 32 less significant bits are used.
	 */
	static public inline function create(value:Int):Int32 {
		if(value > MAX_AS_INT || value < MIN_AS_INT) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			throw new OverflowException('$value overflows Int32');
			#else
			return new Int32(bitsToValue(value & Numeric.native32Bits));
			#end
		} else {
			return new Int32(value);
		}
	}

	/**
	 * Creates `Int32` using 32 less significant bits of `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` has non-zeros on 33rd or more significant bits
	 * then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` has non-zeros on 33rd or more significant bits
	 * then only 32 less significant bits are used.
	 */
	static public inline function createBits(value:Int):Int32 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		var excessive:Int =
			#if php php.Syntax.code('4294967296')
			#elseif python python.Syntax.code('4294967296')
			#elseif js js.Syntax.code('4294967296')
			#elseif lua untyped __lua__('4294967296')
			#end;
		if(value >= excessive || value <= -excessive) {
			throw new OverflowException('$value has non-zeros on 33rd or more significant bits');
		}
		#end
		return new Int32(bitsToValue(value & Numeric.native32Bits));
	}

	/**
	 * Parse string binary representation of a number into `Int32` value.
	 * E.g. `parseBits("1111 1111 1111 1111 1111 1111 1111 1111")` will produce `-1`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string is less or greater than 32
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 */
	@:noUsing
	static public function parseBits(bits:String):Int32 {
		return new Int32(bitsToValue(inline Numeric.parseBitsInt(bits, BITS_COUNT)));
	}

	/**
	 * `bits` must be greater or equal to `MIN_AS_INT` and lesser or equal to `0xFFFFFFFF`
	 */
	static inline function bitsToValue(bits:Int):Int {
		return if(bits > MAX_AS_INT) {
			(bits - MAX_AS_INT - 1) + MIN_AS_INT;
		} else {
			bits;
		}
	}

	/**
	 * `value` must be in bounds of Int32 range
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
	 * Convert `Int32` to `Int` by value.
	 * ```haxe
	 * Int32.create(-1).toInt() == -1
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

	@:op(-A) inline function negative():Int32 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if(this == MIN_AS_INT) {
			throw new OverflowException('2147483648 overflows Int32');
		}
		#end
		return create(-this);
	}

	@:op(++A) inline function prefixIncrement():Int32 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if(this == MAX_AS_INT) {
			throw new OverflowException('2147483648 overflows Int32');
		}
		#end
		this = create(this + 1).toInt();
		return new Int32(this);
	}

	@:op(A++) inline function postfixIncrement():Int32 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if(this == MAX_AS_INT) {
			throw new OverflowException('2147483648 overflows Int32');
		}
		#end
		var result = new Int32(this);
		this = create(this + 1).toInt();
		return result;
	}

	@:op(--A) inline function prefixDecrement():Int32 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if(this == MIN_AS_INT) {
			throw new OverflowException('-2147483649 overflows Int32');
		}
		#end
		this = create(this - 1).toInt();
		return new Int32(this);
	}

	@:op(A--) inline function postfixDecrement():Int32 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if(this == MIN_AS_INT) {
			throw new OverflowException('-2147483649 overflows Int32');
		}
		#end
		var result = new Int32(this);
		this = create(this - 1).toInt();
		return result;
	}

	@:op(A + B) inline function addition(b:Int32):Int32 {
		var result = this + b.toInt();
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if((this < 0 && b.toInt() < 0 && result >= 0) || (this > 0 && b.toInt() > 0 && result <= 0)) {
			throw new OverflowException('($this + ${b.toInt()}) overflows Int32');
		}
		#end
		return create(result);
	}
	@:op(A + B) @:commutative static function additionFloat(a:Int32, b:Float):Float;

	@:op(A - B) inline function subtraction(b:Int32):Int32 {
		var result = this - b.toInt();
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if((this < 0 && b.toInt() > 0 && result >= 0) || (this > 0 && b.toInt() < 0 && result <= 0)) {
			throw new OverflowException('($this + ${b.toInt()}) overflows Int32');
		}
		#end
		return create(result);
	}
	@:op(A - B) static function subtractionFirstFloat(a:Int32, b:Float):Float;
	@:op(A - B) static function subtractionSecondFloat(a:Float, b:Int32):Float;

	@:op(A * B) inline function multiplication(b:Int32):Int32 {
		var result = this * b.toInt();
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
		if(
			(this < 0 && b.toInt() < 0 && result <= 0)
			|| (this > 0 && b.toInt() > 0 && result <= 0)
			|| (this < 0 && b.toInt() > 0 && result >= 0)
			|| (this > 0 && b.toInt() < 0 && result >= 0)
		) {
			throw new OverflowException('($this * ${b.toInt()}) overflows Int32');
		}
		#end
		return create(result);
	}
	@:op(A * B) @:commutative static function multiplicationFloat(a:Int32, b:Float):Float;

	@:op(A / B) function division(b:Int32):Float;
	@:op(A / B) function divisionInt8(b:Int8):Float;
	@:op(A / B) function divisionUInt8(b:UInt8):Float;
	@:op(A / B) function divisionUInt16(b:UInt16):Float;
	@:op(A / B) static function divisionFirstInt(a:Int32, b:Int):Float;
	@:op(A / B) static function divisionSecondInt(a:Int, b:Int32):Float;
	@:op(A / B) static function divisionFirstFloat(a:Int32, b:Float):Float;
	@:op(A / B) static function divisionSecondFloat(a:Float, b:Int32):Float;

	@:op(A % B) function modulo(b:Int32):Int32;
	@:op(A % B) function moduloInt8(b:Int8):Int32;
	@:op(A % B) function moduloUInt8(b:UInt8):Int32;
	@:op(A % B) function moduloUInt16(b:UInt16):Int32;
	@:op(A % B) static function moduloFirstInt(a:Int32, b:Int):Int32;
	@:op(A % B) static function moduloSecondInt(a:Int, b:Int32):Int32;
	@:op(A % B) static function moduloFirstFloat(a:Int32, b:Float):Float;
	@:op(A % B) static function moduloSecondFloat(a:Float, b:Int32):Float;

	@:op(A == B) function equal(b:Int32):Bool;
	@:op(A == B) function equalInt8(b:Int8):Bool;
	@:op(A == B) function equalUInt8(b:UInt8):Bool;
	@:op(A == B) function equalUInt16(b:UInt16):Bool;
	@:op(A == B) @:commutative static function equalInt(a:Int32, b:Int):Bool;
	@:op(A == B) @:commutative static function equalFloat(a:Int32, b:Float):Bool;

	@:op(A != B) function notEqual(b:Int32):Bool;
	@:op(A != B) function notEqualInt8(b:Int8):Bool;
	@:op(A != B) function notEqualUInt8(b:UInt8):Bool;
	@:op(A != B) function notEqualUInt16(b:UInt16):Bool;
	@:op(A != B) @:commutative static function notEqualInt(a:Int32, b:Int):Bool;
	@:op(A != B) @:commutative static function notEqualFloat(a:Int32, b:Float):Bool;

	@:op(A > B) function greater(b:Int32):Bool;
	@:op(A > B) function greaterInt8(b:Int8):Bool;
	@:op(A > B) function greaterUInt8(b:UInt8):Bool;
	@:op(A > B) function greaterUInt16(b:UInt16):Bool;
	@:op(A > B) static function greaterFirstInt(a:Int32, b:Int):Bool;
	@:op(A > B) static function greaterSecondInt(a:Int, b:Int32):Bool;
	@:op(A > B) static function greaterFirstFloat(a:Int32, b:Float):Bool;
	@:op(A > B) static function greaterSecondFloat(a:Float, b:Int32):Bool;

	@:op(A >= B) function greaterOrEqual(b:Int32):Bool;
	@:op(A >= B) function greaterOrEqualInt8(b:Int8):Bool;
	@:op(A >= B) function greaterOrEqualUInt8(b:UInt8):Bool;
	@:op(A >= B) function greaterOrEqualUInt16(b:UInt16):Bool;
	@:op(A >= B) static function greaterOrEqualFirstInt(a:Int32, b:Int):Bool;
	@:op(A >= B) static function greaterOrEqualSecondInt(a:Int, b:Int32):Bool;
	@:op(A >= B) static function greaterOrEqualFirstFloat(a:Int32, b:Float):Bool;
	@:op(A >= B) static function greaterOrEqualSecondFloat(a:Float, b:Int32):Bool;

	@:op(A < B) function less(b:Int32):Bool;
	@:op(A < B) function lessInt8(b:Int8):Bool;
	@:op(A < B) function lessUInt8(b:UInt8):Bool;
	@:op(A < B) function lessUInt16(b:UInt16):Bool;
	@:op(A < B) static function lessFirstInt(a:Int32, b:Int):Bool;
	@:op(A < B) static function lessSecondInt(a:Int, b:Int32):Bool;
	@:op(A < B) static function lessFirstFloat(a:Int32, b:Float):Bool;
	@:op(A < B) static function lessSecondFloat(a:Float, b:Int32):Bool;

	@:op(A <= B) function lessOrEqual(b:Int32):Bool;
	@:op(A <= B) function lessOrEqualInt8(b:Int8):Bool;
	@:op(A <= B) function lessOrEqualUInt8(b:UInt8):Bool;
	@:op(A <= B) function lessOrEqualUInt16(b:UInt16):Bool;
	@:op(A <= B) static function lessOrEqualFirstInt(a:Int32, b:Int):Bool;
	@:op(A <= B) static function lessOrEqualSecondInt(a:Int, b:Int32):Bool;
	@:op(A <= B) static function lessOrEqualFirstFloat(a:Int32, b:Float):Bool;
	@:op(A <= B) static function lessOrEqualSecondFloat(a:Float, b:Int32):Bool;

	@:op(~A) function negate():Int32;

	@:op(A & B) function and(b:Int32):Int32;
	@:op(A & B) inline function andInt8(b:Int8):Int {
		return valueToBits(this) & Int8.valueToBits(b.toInt());
	}
	@:op(A & B) inline function andUInt8(b:UInt8):Int {
		return valueToBits(this) & b.toInt();
	}
	@:op(A & B) inline function andUInt16(b:UInt16):Int {
		return valueToBits(this) & b.toInt();
	}
	@:op(A & B) @:commutative static inline function andInt(a:Int32, b:Int):Int {
		return valueToBits(a.toInt()) & b;
	}

	@:op(A | B) function or(b:Int32):Int32;
	@:op(A | B) inline function orInt8(b:Int8):Int {
		return valueToBits(this) | Int8.valueToBits(b.toInt());
	}
	@:op(A | B) inline function orUInt8(b:UInt8):Int {
		return valueToBits(this) | b.toInt();
	}
	@:op(A | B) inline function orUInt16(b:UInt16):Int {
		return valueToBits(this) | b.toInt();
	}
	@:op(A | B) @:commutative static inline function orInt(a:Int32, b:Int):Int {
		return valueToBits(a.toInt()) | b;
	}

	@:op(A ^ B) function xor(b:Int32):Int32;
	@:op(A ^ B) inline function xorInt8(b:Int8):Int {
		return valueToBits(this) ^ Int8.valueToBits(b.toInt());
	}
	@:op(A ^ B) inline function xorUInt8(b:UInt8):Int {
		return valueToBits(this) ^ b.toInt();
	}
	@:op(A ^ B) inline function xorUInt16(b:UInt16):Int {
		return valueToBits(this) ^ b.toInt();
	}
	@:op(A ^ B) @:commutative static inline function xorInt(a:Int32, b:Int):Int {
		return valueToBits(a.toInt()) ^ b;
	}

	// <<
	@:op(A << B) inline function shiftLeft(b:Int32):Int32 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftInt8(b:Int8):Int32 {
		return shiftLeftFirstInt(Int8.valueToBits(b.toInt()));
	}
	@:op(A << B) inline function shiftLeftUInt8(b:UInt8):Int32 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftUInt16(b:UInt16):Int32 {
		return shiftLeftFirstInt(b.toInt());
	}
	@:op(A << B) inline function shiftLeftFirstInt(b:Int):Int32 {
		var bits = (this << (b & 0x1F)) & Numeric.native32Bits;
		return new Int32(bitsToValue(bits));
	}
	@:op(A << B) static function shiftLeftSecondInt(a:Int, b:Int32):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:Int32):Int32 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightInt8(b:Int8):Int32 {
		return shiftRightFirstInt(valueToBits(b.toInt()));
	}
	@:op(A >> B) inline function shiftRightUInt8(b:UInt8):Int32 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightUInt16(b:UInt16):Int32 {
		return shiftRightFirstInt(b.toInt());
	}
	@:op(A >> B) inline function shiftRightFirstInt(b:Int):Int32 {
		var result = this >> (b & 0x1F);
		return new Int32(result);
	}
	@:op(A >> B) static function shiftRightSecondInt(a:Int, b:Int32):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:Int32):Int32 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightInt8(b:Int8):Int32 {
		return unsignedShiftRightFirstInt(valueToBits(b.toInt()));
	}
	@:op(A >>> B) inline function unsignedShiftRightUInt8(b:UInt8):Int32 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightUInt16(b:UInt16):Int32 {
		return unsignedShiftRightFirstInt(b.toInt());
	}
	@:op(A >>> B) inline function unsignedShiftRightFirstInt(b:Int):Int32 {
		var result = valueToBits(this) >>> (b & 0x1F);
		return new Int32(result);
	}
	@:op(A >>> B) static function unsignedShiftRightSecondInt(a:Int, b:Int32):Int;
}