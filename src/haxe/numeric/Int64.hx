package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;
import haxe.numeric.exceptions.OverflowException;

using StringTools;

abstract TargetImpl(Array<Int>) {
	public var high(get,set):Int;
	inline function get_high() return this[0];
	inline function set_high(v) return this[0] = v;

	public var low(get,set):Int;
	inline function get_low() return this[1];
	inline function set_low(v) return this[1] = v;

	public inline function new() {
		this = [0, 0];
	}
}

private typedef Impl = TargetImpl;

/**
 * 64-bit signed integer.
 * `Int64` represents values ranging from `−9 223 372 036 854 775 808`
 * to `9 223 372 036 854 775 807` (including).
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
abstract Int64(Impl) {
	static inline var BITS_COUNT = 64;

	/** Maximum `Int64` value: `9223372036854775807` */
	static public var MAX(get,never):Int64;
	static var _MAX:Null<Int64>;
	static function get_MAX():Int64 {
		return switch _MAX {
			case null:
				var max = new Impl();
				max.low = Numeric.native32BitsInt;
				max.high = Numeric.native32BitsInt >>> 1;
				_MAX = new Int64(max);
			case max:
				max;
		}
	}
	/** Minimum `Int64` value: `−9223372036854775808` */
	static public var MIN(get,never):Int64;
	static var _MIN:Null<Int64>;
	static function get_MIN():Int64 {
		return switch _MIN {
			case null:
				var min = new Impl();
				min.high = Numeric.shiftLeft(1, 31);
				_MIN = new Int64(min);
			case min:
				min;
		}
	}

	/**
	 * Creates Int64 from `value`.
	 */
	static public function create(value:Int):Int64 {
		var result = new Impl();
		result.low = value & Numeric.native32BitsInt;
		if(Numeric.MIN_INT32 <= value && value < 0) {
			result.high = Numeric.native32BitsInt;
		} else if(value != result.low) {
			result.high = ((value >> 31) >> 1) & Numeric.native32BitsInt;
		}
		return new Int64(result);
	}

	/**
	 * Creates Int64 from binary representation of `value`.
	 * E.g. `Int64.createBits(-1)` produces a value of `4294967295` on 32bit platforms and `-1` on 64bit platforms.
	 */
	static public function createBits(value:Int):Int64 {
		var result = new Impl();
		result.low = value & Numeric.native32BitsInt;
		if(value != result.low) {
			result.high = ((value >> 31) >> 1) & Numeric.native32BitsInt;
		}
		return new Int64(result);
	}

	/**
	 * Create `Int64` by using `highBits` as a binary representation of 32 most significant bits
	 * and `lowBits` as a binary representation of 32 less significant bits.
	 *
	 * `highBits` and `lowBits` are treated as 32 bit signed integers.
	 *
	 * E.g. `Int64.compose(1, 2)` creates an `Int64` value `4294967298`.
	 * Because binary representations of `1` and `2` are
	 * `0000000000000000 0000000000000001` and `0000000000000000 0000000000000010`
	 * and binary representation of `4294967298` is
	 * `0000000000000000 0000000000000001 0000000000000000 0000000000000010`
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW` compilation flag
	 * `haxe.numeric.exceptions.OverflowException` is thrown if:
	 * - if `highBits` or `lowBits` is positive and has ones on 33rd or more significant bits
	 * - or if `highBits` or `lowBits` is negative and has zeros on 33rd or more significant bits.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP` the values of
	 * `highBits` and `lowBits` are truncated to 32 less significant bits.
	 */
	static public function composeBits(highBits:Int, lowBits:Int) {
		var result = new Impl();
		result.low = lowBits & Numeric.native32BitsInt;
		result.high = highBits & Numeric.native32BitsInt;

		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			inline function check(value:Int, argument:String) {
				if(value < -Numeric.MAX_UINT32_AS_FLOAT || value > Numeric.MAX_UINT32_AS_FLOAT) {
					throw new OverflowException('$value ("$argument" argument) overflows 32bit integer');
				}
			}
			check(highBits, 'highBits');
			check(lowBits, 'lowBits');
		#end

		return new Int64(result);
	}

	// /**
	//  * Creates `Int32` using 32 less significant bits of `value`.
	//  *
	//  * In `-debug` builds or with `-D OVERFLOW_THROW`:
	//  * If `value` has non-zeros on 33rd or more significant bits
	//  * then `haxe.numeric.exceptions.OverflowException` is thrown.
	//  *
	//  * In release builds or with `-D OVERFLOW_WRAP`:
	//  * If `value` has non-zeros on 33rd or more significant bits
	//  * then only 32 less significant bits are used.
	//  */
	// static public inline function createBits(value:Int):Int32 {
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 		if(
	// 			#if (js || lua)
	// 				value < MIN_AS_INT || value > MAX_AS_INT * 2 + 1
	// 			#else
	// 				value & ~Numeric.native32BitsInt != 0
	// 			#end
	// 		) {
	// 			throw new OverflowException('$value has non-zeros on 33rd or more significant bits');
	// 		}
	// 	#end
	// 	return new Int32(bitsToValue(value & Numeric.native32BitsInt));
	// }

	/**
	 * Parse string binary representation of a number into `Int64` value.
	 *
	 * E.g. `parseBits("1111111111111111 1111111111111111 1111111111111111 1111111111111111")`
	 * will produce `-1`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string is less or greater than 64
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 */
	@:noUsing
	static public function parseBits(bits:String):Int64 {
		var result = new Impl();
		var bitPos = BITS_COUNT;
		var value = 0;
		for(pos => code in bits) {
			switch(code) {
				case ' '.code | '\t'.code:
				case '0'.code:
					bitPos--;
				case '1'.code:
					bitPos--;
					if(bitPos >= 0) {
						value = value | 1 << bitPos;
					}
				case _:
					throw new InvalidArgumentException('Invalid character "${String.fromCharCode(code)}" at index $pos in string "$bits"');
			}
			if(bitPos == 32) {
				result.high = value;
				value = 0;
			}
		}
		result.low = value;
		if(bitPos != 0) {
			throw new InvalidArgumentException('Bits string should contain exactly $BITS_COUNT bits. Invalid bits string "$bits"');
		}

		return new Int64(result);
	}

	// /**
	//  * `bits` must be greater or equal to `MIN_AS_INT` and lesser or equal to `0xFFFFFFFF`
	//  */
	// static inline function bitsToValue(bits:Int):Int {
	// 	return if(bits > MAX_AS_INT) {
	// 		(bits - MAX_AS_INT - 1) + MIN_AS_INT;
	// 	} else {
	// 		bits;
	// 	}
	// }

	// /**
	//  * `value` must be in bounds of Int32 range
	//  */
	// static inline function valueToBits(value:Int):Int {
	// 	return if(#if (js || lua) false #else value < 0 #end) {
	// 		value - MIN_AS_INT + 1 + MAX_AS_INT;
	// 	} else {
	// 		value;
	// 	}
	// }

	inline function new(value:Impl) {
		this = value;
	}

	// /**
	//  * Convert `Int32` to `Int` by value.
	//  * ```haxe
	//  * Int32.create(-1).toInt() == -1
	//  * ```
	//  *
	//  * For binary conversion see `Int16Utils.toIntBits` method in `haxe.numeric.Numeric` module
	//  */
	// public inline function toInt():Int {
	// 	return this;
	// }

	public function toString():String {
		if(this.high == 0) {
			inline function normalized() {
				#if java
					return (cast (Numeric.MAX_UINT32_AS_FLOAT + this + 1):java.lang.Number).longValue();
				#elseif lua
					return untyped __lua__('4294967295') + this + 1;
				#else
					return Numeric.MAX_UINT32_AS_FLOAT + this.low + 1;
				#end
			}
			return this.low < 0 ? '${normalized()}' : '${this.low}';
		}

		var decimal = [];

		inline function double() {
			var remains = 0;
			for(i in 0...decimal.length) {
				var digit = decimal[i] * 2 + remains;
				if(digit >= 10) {
					decimal[i] = digit - 10;
					remains = 1;
				} else {
					decimal[i] = digit;
					remains = 0;
				}
			}
			if(remains != 0) {
				decimal.push(remains);
			}
		}

		inline function addOne() {
			var remains = 1;
			for(i in 0...decimal.length) {
				var digit = decimal[i] + remains;
				if(digit == 10) {
					decimal[i] = 0;
					remains = 1;
				} else {
					decimal[i] = digit;
					remains = 0;
				}
			}
			if(remains != 0) {
				decimal.push(remains);
			}
		}

		inline function stringifyDecimal() {
			var s = '';
			var started = false;
			for(i in 0...decimal.length) {
				var v = decimal[decimal.length - i - 1];
				if(started || v != 0) {
					started = true;
					s += v;
				}
			}
			return s;
		}

		var negative = 0 != this.high >> 31;
		var high = this.high;
		var low = this.low;
		if(negative) {
			high = ~high;
			low = (~low) & Numeric.native32BitsInt;
			if(low == Numeric.native32BitsInt) {
				low = 0;
				high += 1;
			} else {
				low += 1;
			}
		}

		for(i in 0...32) {
			var pos = 31 - i;
			double();
			if(0 != high & (1 << pos)) {
				addOne();
			}
		}
		for(i in 0...32) {
			var pos = 31 - i;
			double();
			if(0 != low & (1 << pos)) {
				addOne();
			}
		}

		return (negative ? '-' : '') + stringifyDecimal();
	}

	// @:op(-A) inline function negative():Int32 {
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if(this == MIN_AS_INT) {
	// 		throw new OverflowException('2147483648 overflows Int32');
	// 	}
	// 	#end
	// 	return create(-this);
	// }

	// @:op(++A) inline function prefixIncrement():Int32 {
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if(this == MAX_AS_INT) {
	// 		throw new OverflowException('2147483648 overflows Int32');
	// 	}
	// 	#end
	// 	this = create(this + 1).toInt();
	// 	return new Int32(this);
	// }

	// @:op(A++) inline function postfixIncrement():Int32 {
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if(this == MAX_AS_INT) {
	// 		throw new OverflowException('2147483648 overflows Int32');
	// 	}
	// 	#end
	// 	var result = new Int32(this);
	// 	this = create(this + 1).toInt();
	// 	return result;
	// }

	// @:op(--A) inline function prefixDecrement():Int32 {
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if(this == MIN_AS_INT) {
	// 		throw new OverflowException('-2147483649 overflows Int32');
	// 	}
	// 	#end
	// 	this = create(this - 1).toInt();
	// 	return new Int32(this);
	// }

	// @:op(A--) inline function postfixDecrement():Int32 {
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if(this == MIN_AS_INT) {
	// 		throw new OverflowException('-2147483649 overflows Int32');
	// 	}
	// 	#end
	// 	var result = new Int32(this);
	// 	this = create(this - 1).toInt();
	// 	return result;
	// }


	// @:op(A + B) #if !cpp inline #end function addition(b:Int32):Int32 {
	// 	// regarding inline for cpp: https://github.com/HaxeFoundation/haxe/issues/8879
	// 	var result = this + b.toInt();
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if((this < 0 && b.toInt() < 0 && result >= 0) || (this > 0 && b.toInt() > 0 && result <= 0)) {
	// 		throw new OverflowException('($this + ${b.toInt()}) overflows Int32');
	// 	}
	// 	#end
	// 	return create(result);
	// }
	// @:op(A + B) @:commutative static function additionFloat(a:Int32, b:Float):Float;

	// @:op(A - B) inline function subtraction(b:Int32):Int32 {
	// 	var result = this - b.toInt();
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if((this < 0 && b.toInt() > 0 && result >= 0) || (this > 0 && b.toInt() < 0 && result <= 0)) {
	// 		throw new OverflowException('($this + ${b.toInt()}) overflows Int32');
	// 	}
	// 	#end
	// 	return create(result);
	// }
	// @:op(A - B) static function subtractionFirstFloat(a:Int32, b:Float):Float;
	// @:op(A - B) static function subtractionSecondFloat(a:Float, b:Int32):Float;

	// @:op(A * B) inline function multiplication(b:Int32):Int32 {
	// 	var result = this * b.toInt();
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if(
	// 		(this < 0 && b.toInt() < 0 && result <= 0)
	// 		|| (this > 0 && b.toInt() > 0 && result <= 0)
	// 		|| (this < 0 && b.toInt() > 0 && result >= 0)
	// 		|| (this > 0 && b.toInt() < 0 && result >= 0)
	// 	) {
	// 		throw new OverflowException('($this * ${b.toInt()}) overflows Int32');
	// 	}
	// 	#end
	// 	return create(result);
	// }
	// @:op(A * B) @:commutative static function multiplicationFloat(a:Int32, b:Float):Float;

	// @:op(A / B) function division(b:Int32):Float;
	// @:op(A / B) function divisionInt8(b:Int8):Float;
	// @:op(A / B) function divisionUInt8(b:UInt8):Float;
	// @:op(A / B) function divisionUInt16(b:UInt16):Float;
	// @:op(A / B) static function divisionFirstInt(a:Int32, b:Int):Float;
	// @:op(A / B) static function divisionSecondInt(a:Int, b:Int32):Float;
	// @:op(A / B) static function divisionFirstFloat(a:Int32, b:Float):Float;
	// @:op(A / B) static function divisionSecondFloat(a:Float, b:Int32):Float;

	// @:op(A % B) function modulo(b:Int32):Int32;
	// @:op(A % B) function moduloInt8(b:Int8):Int32;
	// @:op(A % B) function moduloUInt8(b:UInt8):Int32;
	// @:op(A % B) function moduloUInt16(b:UInt16):Int32;
	// @:op(A % B) static function moduloFirstInt(a:Int32, b:Int):Int32;
	// @:op(A % B) static function moduloSecondInt(a:Int, b:Int32):Int32;
	// @:op(A % B) static function moduloFirstFloat(a:Int32, b:Float):Float;
	// @:op(A % B) static function moduloSecondFloat(a:Float, b:Int32):Float;

	// @:op(A == B) function equal(b:Int32):Bool;
	// @:op(A == B) function equalInt8(b:Int8):Bool;
	// @:op(A == B) function equalUInt8(b:UInt8):Bool;
	// @:op(A == B) function equalUInt16(b:UInt16):Bool;
	// @:op(A == B) @:commutative static function equalInt(a:Int32, b:Int):Bool;
	// @:op(A == B) @:commutative static function equalFloat(a:Int32, b:Float):Bool;

	// @:op(A != B) function notEqual(b:Int32):Bool;
	// @:op(A != B) function notEqualInt8(b:Int8):Bool;
	// @:op(A != B) function notEqualUInt8(b:UInt8):Bool;
	// @:op(A != B) function notEqualUInt16(b:UInt16):Bool;
	// @:op(A != B) @:commutative static function notEqualInt(a:Int32, b:Int):Bool;
	// @:op(A != B) @:commutative static function notEqualFloat(a:Int32, b:Float):Bool;

	// @:op(A > B) function greater(b:Int32):Bool;
	// @:op(A > B) function greaterInt8(b:Int8):Bool;
	// @:op(A > B) function greaterUInt8(b:UInt8):Bool;
	// @:op(A > B) function greaterUInt16(b:UInt16):Bool;
	// @:op(A > B) static function greaterFirstInt(a:Int32, b:Int):Bool;
	// @:op(A > B) static function greaterSecondInt(a:Int, b:Int32):Bool;
	// @:op(A > B) static function greaterFirstFloat(a:Int32, b:Float):Bool;
	// @:op(A > B) static function greaterSecondFloat(a:Float, b:Int32):Bool;

	// @:op(A >= B) function greaterOrEqual(b:Int32):Bool;
	// @:op(A >= B) function greaterOrEqualInt8(b:Int8):Bool;
	// @:op(A >= B) function greaterOrEqualUInt8(b:UInt8):Bool;
	// @:op(A >= B) function greaterOrEqualUInt16(b:UInt16):Bool;
	// @:op(A >= B) static function greaterOrEqualFirstInt(a:Int32, b:Int):Bool;
	// @:op(A >= B) static function greaterOrEqualSecondInt(a:Int, b:Int32):Bool;
	// @:op(A >= B) static function greaterOrEqualFirstFloat(a:Int32, b:Float):Bool;
	// @:op(A >= B) static function greaterOrEqualSecondFloat(a:Float, b:Int32):Bool;

	// @:op(A < B) function less(b:Int32):Bool;
	// @:op(A < B) function lessInt8(b:Int8):Bool;
	// @:op(A < B) function lessUInt8(b:UInt8):Bool;
	// @:op(A < B) function lessUInt16(b:UInt16):Bool;
	// @:op(A < B) static function lessFirstInt(a:Int32, b:Int):Bool;
	// @:op(A < B) static function lessSecondInt(a:Int, b:Int32):Bool;
	// @:op(A < B) static function lessFirstFloat(a:Int32, b:Float):Bool;
	// @:op(A < B) static function lessSecondFloat(a:Float, b:Int32):Bool;

	// @:op(A <= B) function lessOrEqual(b:Int32):Bool;
	// @:op(A <= B) function lessOrEqualInt8(b:Int8):Bool;
	// @:op(A <= B) function lessOrEqualUInt8(b:UInt8):Bool;
	// @:op(A <= B) function lessOrEqualUInt16(b:UInt16):Bool;
	// @:op(A <= B) static function lessOrEqualFirstInt(a:Int32, b:Int):Bool;
	// @:op(A <= B) static function lessOrEqualSecondInt(a:Int, b:Int32):Bool;
	// @:op(A <= B) static function lessOrEqualFirstFloat(a:Int32, b:Float):Bool;
	// @:op(A <= B) static function lessOrEqualSecondFloat(a:Float, b:Int32):Bool;

	// @:op(~A) function negate():Int32;

	// @:op(A & B) function and(b:Int32):Int32;
	// @:op(A & B) inline function andInt8(b:Int8):Int {
	// 	return valueToBits(this) & Int8.valueToBits(b.toInt());
	// }
	// @:op(A & B) inline function andUInt8(b:UInt8):Int {
	// 	return valueToBits(this) & b.toInt();
	// }
	// @:op(A & B) inline function andUInt16(b:UInt16):Int {
	// 	return valueToBits(this) & b.toInt();
	// }
	// @:op(A & B) @:commutative static inline function andInt(a:Int32, b:Int):Int {
	// 	return valueToBits(a.toInt()) & b;
	// }

	// @:op(A | B) function or(b:Int32):Int32;
	// @:op(A | B) inline function orInt8(b:Int8):Int {
	// 	return valueToBits(this) | Int8.valueToBits(b.toInt());
	// }
	// @:op(A | B) inline function orUInt8(b:UInt8):Int {
	// 	return valueToBits(this) | b.toInt();
	// }
	// @:op(A | B) inline function orUInt16(b:UInt16):Int {
	// 	return valueToBits(this) | b.toInt();
	// }
	// @:op(A | B) @:commutative static inline function orInt(a:Int32, b:Int):Int {
	// 	return valueToBits(a.toInt()) | b;
	// }

	// @:op(A ^ B) function xor(b:Int32):Int32;
	// @:op(A ^ B) inline function xorInt8(b:Int8):Int {
	// 	return valueToBits(this) ^ Int8.valueToBits(b.toInt());
	// }
	// @:op(A ^ B) inline function xorUInt8(b:UInt8):Int {
	// 	return valueToBits(this) ^ b.toInt();
	// }
	// @:op(A ^ B) inline function xorUInt16(b:UInt16):Int {
	// 	return valueToBits(this) ^ b.toInt();
	// }
	// @:op(A ^ B) @:commutative static inline function xorInt(a:Int32, b:Int):Int {
	// 	return valueToBits(a.toInt()) ^ b;
	// }

	// // <<
	// @:op(A << B) inline function shiftLeft(b:Int32):Int32 {
	// 	return shiftLeftFirstInt(b.toInt());
	// }
	// @:op(A << B) inline function shiftLeftInt8(b:Int8):Int32 {
	// 	return shiftLeftFirstInt(Int8.valueToBits(b.toInt()));
	// }
	// @:op(A << B) inline function shiftLeftUInt8(b:UInt8):Int32 {
	// 	return shiftLeftFirstInt(b.toInt());
	// }
	// @:op(A << B) inline function shiftLeftUInt16(b:UInt16):Int32 {
	// 	return shiftLeftFirstInt(b.toInt());
	// }
	// @:op(A << B) inline function shiftLeftFirstInt(b:Int):Int32 {
	// 	var bits = (this << (b & 0x1F)) & Numeric.native32BitsInt;
	// 	return new Int32(bitsToValue(bits));
	// }
	// @:op(A << B) static function shiftLeftSecondInt(a:Int, b:Int32):Int;

	// // >>
	// @:op(A >> B) inline function shiftRight(b:Int32):Int32 {
	// 	return shiftRightFirstInt(b.toInt());
	// }
	// @:op(A >> B) inline function shiftRightInt8(b:Int8):Int32 {
	// 	return shiftRightFirstInt(valueToBits(b.toInt()));
	// }
	// @:op(A >> B) inline function shiftRightUInt8(b:UInt8):Int32 {
	// 	return shiftRightFirstInt(b.toInt());
	// }
	// @:op(A >> B) inline function shiftRightUInt16(b:UInt16):Int32 {
	// 	return shiftRightFirstInt(b.toInt());
	// }
	// @:op(A >> B) inline function shiftRightFirstInt(b:Int):Int32 {
	// 	var result = this >> (b & 0x1F);
	// 	return new Int32(result);
	// }
	// @:op(A >> B) static function shiftRightSecondInt(a:Int, b:Int32):Int;

	// // >>>
	// @:op(A >>> B) inline function unsignedShiftRight(b:Int32):Int32 {
	// 	return unsignedShiftRightFirstInt(b.toInt());
	// }
	// @:op(A >>> B) inline function unsignedShiftRightInt8(b:Int8):Int32 {
	// 	return unsignedShiftRightFirstInt(valueToBits(b.toInt()));
	// }
	// @:op(A >>> B) inline function unsignedShiftRightUInt8(b:UInt8):Int32 {
	// 	return unsignedShiftRightFirstInt(b.toInt());
	// }
	// @:op(A >>> B) inline function unsignedShiftRightUInt16(b:UInt16):Int32 {
	// 	return unsignedShiftRightFirstInt(b.toInt());
	// }
	// @:op(A >>> B) inline function unsignedShiftRightFirstInt(b:Int):Int32 {
	// 	var result = valueToBits(this) >>> (b & 0x1F);
	// 	return new Int32(result);
	// }
	// @:op(A >>> B) static function unsignedShiftRightSecondInt(a:Int, b:Int32):Int;
}