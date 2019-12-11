package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

using haxe.numeric.Numeric;

/**
 * 32-bit unsigned integer.
 * `UInt32` represents values ranging from 0 to 4294967295 (including).
 *
 * On platforms which don't have native uint32 at runtime `UInt32` is represented by `Int`
 * in range from `-2147483648` to `2147483647`.
 *
 * The distribution of `UInt32` values on that range can be represented as follows:
 * | 0 --------------------------------------- 4294967295 |
 * | 0 --------- 2147483647, -2147483648 ------------- -1 |
 *
 * If the right side operand of a bitwise shift is negative or takes more than 5 bits,
 * then only 5 less significant bits of it is used:
 * ```haxe
 * UInt32.create(1) << -1
 * //is basically the same as
 * UInt32.create(1) << (-1 & 0x1F)
 * ```
 *
 * Types of arithmetic.
 *
 * For binary operations addition, subtraction, multiplication and modulo general rule is
 * if both operands are `UInt32` then the result will be `UInt32` too.
 * Otherwise the type of result will depend on the types of both arguments.
 * For division the result will always be `Float`.
 * For bitwise shifts if the left side operand is `UInt32` the result type is `UInt32` too.
 * For exact result types depending on operand types refer to specification tests of `UInt32`
 *
 * Overflow.
 *
 * If the value calculated for `UInt32` or provided to `UInt32.create(value)`
 * does not fit `UInt32` bounds (from 0 to 4294967295, including) then overflow happens.
 * The overflow behavior depends on compilation settings.
 * In `-debug` builds or with `-D OVERFLOW_THROW` an exception of type
 * `haxe.numeric.exceptions.OverflowException` is thrown.
 * In release builds or with `-D OVERFLOW_WRAP` only 32 less significant bits are used.
 *
 * Type conversions.
 *
 * `UInt32` can be converted to `Int`:
 * ```haxe
 * UInt32.MAX.toInt() == -1; //on 32bit platforms
 * UInt32.MAX.toInt() == 4294967295; //on 64bit platforms
 * ```
 * To convert `UInt32` to other integer types refer to `haxe.numeric.Numeric.UInt16Utils` methods.
 */
@:allow(haxe.numeric)
abstract UInt32(Int) {
	static inline var MAX_AS_FLOAT = 4294967295.0;
	static inline var MIN_AS_INT = 0;
	static inline var MAX_INT32 = 2147483647;
	static inline var MIN_INT32 = -2147483648;

	static public var MAX(get,never):UInt32;
	static public inline var MIN:UInt32 = new UInt32(MIN_AS_INT);
	static inline function get_MAX() return new UInt32(Numeric.native32BitsInt);

	static inline var BITS_COUNT = 32;

	/**
	 * Creates UInt32 with `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` is outside of `UInt32` bounds [0; 4294967295] then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` is outside of `UInt32` bounds then only 32 less significant bits are used.
	 */
	static public inline function create(value:Int):UInt32 {
		if(value > MAX_AS_FLOAT || value < MIN_AS_INT) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			throw new OverflowException('$value overflows UInt32');
			#else
			return new UInt32(value & Numeric.native32BitsInt);
			#end
		} else {
			return new UInt32(value);
		}
	}

	/**
	 * Creates `UInt32` using 32 less significant bits of `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` has non-zeros on 33rd or more significant bits
	 * then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` has non-zeros on 33rd or more significant bits
	 * then only 32 less significant bits are used.
	 */
	static public function createBits(value:Int):UInt32 {
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			if(!Numeric.is32BitsIntegers && (value < 0 || value > MAX_AS_FLOAT)) {
				throw new OverflowException('$value has non-zeros on 33rd or more significant bits');
			}
		#elseif js
			if(value < 0 || value > MAX_AS_FLOAT) {
				value = Numeric.native32BitsInt + (value & Numeric.native32BitsInt) + 1;
			}
		#else
			value = value & Numeric.native32BitsInt;
		#end
		return new UInt32(value);
	}

	/**
	 * Parse string binary representation of a number into `UInt32` value.
	 * E.g. `parseBits("1100 0000 0000 0000 0000 0000 0000 1100")` will produce `3221225484`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string is less or greater than 32
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 */
	@:noUsing
	static public function parseBits(bits:String):UInt32 {
		return new UInt32(inline Numeric.parseBitsInt(bits, UInt32.BITS_COUNT));
	}

	inline function new(value:Int) {
		this = value;
	}

	public inline function toString():String {
		return this < 0 ? '${MAX_AS_FLOAT + this + 1}' : '$this';
	}

	/**
	 * Convert `UInt32` to `Int` by value.
	 *
	 * That is, on 32bit platforms `UInt32.MAX.toInt() == -1` because at runtime `UInt32` (ranges from 0 to 4294967295)
	 * is represented by `Int` (ranges from -2147483648 to 2147483647).
	 * So on 32bit platforms `UInt32` values from 0 to 2147483647 are represented by exactly same values of `Int`,
	 * while `UInt32` values from 2147483648 to 4294967295 are represented by `Int` values from -2147483648 to -1.
	 */
	inline function toInt():Int {
		return this;
	}

	inline function toFloat():Float {
		return this < 0 ? MAX_AS_FLOAT + this + 1 : this;
	}

	//should this produce an Int or Float or throw an exception or not allowed at all?
	// @:op(-A) inline function negative():Float {
	// 	return -(this < 0 ? 4294967296.0 + this : this);
	// }

	@:op(++A) inline function prefixIncrement():UInt32 {
		if(this == Numeric.native32BitsInt) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
				throw new OverflowException('4294967296 overflows UInt32');
			#else
				this = 0;
			#end
		} else {
			this = this + 1;
		}
		return new UInt32(this);
	}

	@:op(A++) inline function postfixIncrement():UInt32 {
		var result = new UInt32(this);
		if(this == Numeric.native32BitsInt) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
				throw new OverflowException('4294967296 overflows UInt32');
			#else
				this = 0;
			#end
		} else {
			this = this + 1;
		}
		return result;
	}

	@:op(--A) inline function prefixDecrement():UInt32 {
		if(this == 0) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
				throw new OverflowException('-1 overflows UInt32');
			#else
				this = Numeric.native32BitsInt;
			#end
		} else {
			this = this - 1;
		}
		return new UInt32(this);
	}

	@:op(A--) inline function postfixDecrement():UInt32 {
		var result = new UInt32(this);
		if(this == 0) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
				throw new OverflowException('-1 overflows UInt32');
			#else
				this = Numeric.native32BitsInt;
			#end
		} else {
			this = this - 1;
		}
		return result;
	}

	@:op(A + B) function add(b:UInt32):UInt32 {
		var bInt = b.toInt();
		var result = this + bInt;
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			if(Numeric.is32BitsIntegers) {
				if((this < 0 && bInt < 0) || ((this < 0 || bInt < 0) && result >= 0)) {
					throw new OverflowException('(${toString()} + ${b.toString()}) overflows UInt32');
				}
			} else {
				if(result < 0 || result > MAX_AS_FLOAT) {
					throw new OverflowException('(${toString()} + ${b.toString()}) overflows UInt32');
				}
			}
		#elseif js
			if(result < 0 || result > MAX_AS_FLOAT) {
				value = Numeric.native32BitsInt + (value & Numeric.native32BitsInt) + 1;
			}
		#else
			result = result & Numeric.native32BitsInt;
		#end
		return new UInt32(result);
	}

	// @:op(A + B) function addition(b:UInt32):UInt32 {
	// 	var bInt = b.toInt();
	// 	var overflow = false;
	// 	var result = if(this >= 0) {
	// 		// this >= 0 && bInt >= 0
	// 		if(bInt >= 0) {
	// 			if(MAX_INT - this >= bInt) {
	// 				this + bInt;
	// 			} else {
	// 				MIN_INT + (bInt - (MAX_INT - this));
	// 			}
	// 		// this >= 0 && bInt < 0
	// 		} else {
	// 			var r = this + bInt;
	// 			overflow = r >= 0;
	// 			r;
	// 		}
	// 	} else {
	// 		// this < 0 && bInt >= 0
	// 		if(bInt >= 0) {
	// 			var r = this + bInt;
	// 			overflow = r >= 0;
	// 			r;
	// 		// this < 0 && bInt < 0
	// 		} else {
	// 			// UInt range structure:
	// 			// | 0 --------- 2147483647, -2147483648 ------------- -1 |
	// 			// var remains = -(MIN_INT - negativeValue) + 1;
	// 			// this == MAX_INT + thisRemains;
	// 			// b == MAX_INT + bRemains;
	// 			// var result = (MAX_INT + MAX_INT) + thisRemains + bRemains;
	// 			// var result = (    4294967294   ) + thisRemains + bRemains;
	// 			// 1 <= thisRemains <= MAX_INT //always
	// 			// 1 <= bRemains <= MAX_INT //always
	// 			// var result = (    4294967294   ) + 1 + (thisRemains - 1) + 1 + (bRemains - 1);
	// 			// var result = (    4294967295   )     + thisRemains1      + 1 + bRemains1;
	// 			// 0 <= thisRemains1 < MAX_INT // always
	// 			// 0 <= bRemains1 < MAX_INT // always
	// 			// (    4294967295   ) + 1 = overflow = 0
	// 			// var result = thisRemains1 + bRemains1;
	// 			overflow = true;
	// 			var thisRemains1 = this == MIN_INT ? 0 : -(MIN_INT - this);
	// 			var bRemains1 = bInt == MIN_INT ? 0 : -(MIN_INT - bInt);
	// 			if(MAX_INT - thisRemains1 >= bRemains1) {
	// 				thisRemains1 + bRemains1;
	// 			} else {
	// 				MIN_INT + (bRemains1 - (MAX_INT - thisRemains1));
	// 			}
	// 		}
	// 	}
	// 	#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
	// 	if(overflow) {
	// 		throw new OverflowException('(${toString()} + ${b.toString()}) overflows UInt32');
	// 	}
	// 	#end
	// 	return new UInt32(result);
	// }

	@:op(A - B) function sub(b:UInt32):UInt32 {
		var bInt = b.toInt();
		var result = this - bInt;
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			if(Numeric.is32BitsIntegers) {
				if((this < 0 && bInt > 0) || ((this < 0 || bInt > 0) && result >= 0)) {
					throw new OverflowException('(${toString()} - ${b.toString()}) overflows UInt32');
				}
			} else {
				if(result < 0 || result > MAX_AS_FLOAT) {
					throw new OverflowException('(${toString()} - ${b.toString()}) overflows UInt32');
				}
			}
		#elseif js
			if(result < 0 || result > MAX_AS_FLOAT) {
				result = Numeric.native32BitsInt + (result & Numeric.native32BitsInt) + 1;
			}
		#else
			result = result & Numeric.native32BitsInt;
		#end
		return new UInt32(result);
	}

	@:op(A * B) function mul(b:UInt32):UInt32 {

		var resultFloat = toFloat() * b.toFloat();
		var overflow = resultFloat < 0 || resultFloat > MAX_AS_FLOAT;
		if(!overflow) {
			return new UInt32(this * b.toInt());
		}
		#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			throw new OverflowException('(${toString()} * ${b.toString()}) overflows UInt32');
		#elseif js
			#error "UInt32.mul() overflow is not implemented for JS"
		#else
			if(Numeric.is32BitsIntegers) {
				return new UInt32(this * b.toInt());
			} else {
				var aInt = this;
				var bInt = b.toInt();
				if(bInt > aInt) {
					var tmp = bInt;
					bInt = aInt;
					aInt = tmp;
				}

				var top = Numeric.native32BitsInt;
				var bFit = 0;
				var result = 0;
				while(bInt > 0) {
					bFit = Std.int(top / aInt);
					result += aInt * bFit;
					bInt -= bFit;
					if(bInt == 0) {
						break;
					}
					var remains = top - result;
					result = aInt - remains;
					bInt--;
					top = Numeric.native32BitsInt - result;
				}
				return new UInt32(result);
			}
		#end
	}

	@:op(A / B) function division(b:UInt32):Float;
	@:op(A / B) function int8DivisionFirst(b:Int8):Float;
	@:op(A / B) function uint8DivisionFirst(b:UInt8):Float;
	@:op(A / B) function int16DivisionFirst(b:Int16):Float;
	@:op(A / B) static function intDivisionFirst(a:UInt32, b:Int):Float;
	@:op(A / B) static function intDivisionSecond(a:Int, b:UInt32):Float;
	@:op(A / B) static function floatDivisionFirst(a:UInt32, b:Float):Float;
	@:op(A / B) static function floatDivisionSecond(a:Float, b:UInt32):Float;

	@:op(A % B) function modulo(b:UInt32):UInt32;
	@:op(A % B) function int8Modulo(b:Int8):UInt32;
	@:op(A % B) function uint8Modulo(b:UInt8):UInt32;
	@:op(A % B) function int16Modulo(b:Int16):UInt32;
	@:op(A % B) static function intModuloFirst(a:UInt32, b:Int):UInt32;
	@:op(A % B) static function intModuloSecond(a:Int, b:UInt32):UInt32;
	@:op(A % B) static function floatModuloFirst(a:UInt32, b:Float):Float;
	@:op(A % B) static function floatModuloSecond(a:Float, b:UInt32):Float;

	@:op(A == B) function equal(b:UInt32):Bool;
	@:op(A == B) inline function int8Equal(b:Int8):Bool {
		return this >= 0 && this == b.toInt();
	}
	@:op(A == B) function uint8Equal(b:UInt8):Bool;
	@:op(A == B) inline function int16Equal(b:Int16):Bool {
		return this >= 0 && this == b.toInt();
	}
	@:op(A == B) @:commutative static inline function intEqual(a:UInt32, b:Int):Bool {
		return a.toInt() >= 0 && a.toInt() == b;
	}
	@:op(A == B) @:commutative static inline function floatEqual(a:UInt32, b:Float):Bool {
		return a.toInt() >= 0 ? a.toInt() == b : MAX_AS_FLOAT + 1 + a.toInt() == b;
	}

	@:op(A != B) function notEqual(b:UInt32):Bool;
	@:op(A != B) inline function int8NotEqual(b:Int8):Bool {
		return !int8Equal(b);
	}
	@:op(A != B) function uint8NotEqual(b:UInt8):Bool;
	@:op(A != B) inline function int16NotEqual(b:Int16):Bool {
		return !int16Equal(b);
	}
	@:op(A != B) @:commutative static function intNotEqual(a:UInt32, b:Int):Bool {
		return !intEqual(a, b);
	}
	@:op(A != B) @:commutative static function floatNotEqual(a:UInt32, b:Float):Bool {
		return !floatEqual(a, b);
	}

	@:op(A > B) function greater(b:UInt32):Bool;
	@:op(A > B) function int8Greater(b:Int8):Bool;
	@:op(A > B) function uint8Greater(b:UInt8):Bool;
	@:op(A > B) function int16Greater(b:Int16):Bool;
	@:op(A > B) static function intGreaterFirst(a:UInt32, b:Int):Bool;
	@:op(A > B) static function intGreaterSecond(a:Int, b:UInt32):Bool;
	@:op(A > B) static function floatGreaterFirst(a:UInt32, b:Float):Bool;
	@:op(A > B) static function floatGreaterSecond(a:Float, b:UInt32):Bool;

	@:op(A >= B) function greaterOrEqual(b:UInt32):Bool;
	@:op(A >= B) function int8GreaterOrEqual(b:Int8):Bool;
	@:op(A >= B) function uint8GreaterOrEqual(b:UInt8):Bool;
	@:op(A >= B) function int16GreaterOrEqual(b:Int16):Bool;
	@:op(A >= B) static function intGreaterOrEqualFirst(a:UInt32, b:Int):Bool;
	@:op(A >= B) static function intGreaterOrEqualSecond(a:Int, b:UInt32):Bool;
	@:op(A >= B) static function floatGreaterOrEqualFirst(a:UInt32, b:Float):Bool;
	@:op(A >= B) static function floatGreaterOrEqualSecond(a:Float, b:UInt32):Bool;

	@:op(A < B) function less(b:UInt32):Bool;
	@:op(A < B) function int8Less(b:Int8):Bool;
	@:op(A < B) function uint8Less(b:UInt8):Bool;
	@:op(A < B) function int16Less(b:Int16):Bool;
	@:op(A < B) static function intLessFirst(a:UInt32, b:Int):Bool;
	@:op(A < B) static function intLessSecond(a:Int, b:UInt32):Bool;
	@:op(A < B) static function floatLessFirst(a:UInt32, b:Float):Bool;
	@:op(A < B) static function floatLessSecond(a:Float, b:UInt32):Bool;

	@:op(A <= B) function lessOrEqual(b:UInt32):Bool;
	@:op(A <= B) function int8LessOrEqual(b:Int8):Bool;
	@:op(A <= B) function uint8LessOrEqual(b:UInt8):Bool;
	@:op(A <= B) function int16LessOrEqual(b:Int16):Bool;
	@:op(A <= B) static function intLessOrEqualFirst(a:UInt32, b:Int):Bool;
	@:op(A <= B) static function intLessOrEqualSecond(a:Int, b:UInt32):Bool;
	@:op(A <= B) static function floatLessOrEqualFirst(a:UInt32, b:Float):Bool;
	@:op(A <= B) static function floatLessOrEqualSecond(a:Float, b:UInt32):Bool;

	@:op(~A) inline function negate():UInt32 {
		var value = ~this;
		return new UInt32(value < 0 ? value + 1 + MAX_INT32 : value);
	}

	// &
	@:op(A & B) function and(b:UInt32):UInt32;
	@:op(A & B) inline function andInt8(b:Int8):Int {
		return this & b.toIntBits();
	}
	@:op(A & B) function andUInt8(b:UInt8):Int;
	@:op(A & B) inline function andInt16(b:Int16):Int {
		return this & b.toIntBits();
	}
	@:op(A & B) @:commutative static function andInt(a:UInt32, b:Int):Int;

	// |
	@:op(A | B) function or(b:UInt32):UInt32;
	@:op(A | B) inline function orInt8(b:Int8):Int {
		return this | b.toIntBits();
	}
	@:op(A | B) function orUInt8(b:UInt8):Int;
	@:op(A | B) inline function orInt16(b:Int16):Int {
		return this | b.toIntBits();
	}
	@:op(A | B) @:commutative static function orInt(a:UInt32, b:Int):Int;

	// ^
	@:op(A ^ B) function xor(b:UInt32):UInt32;
	@:op(A ^ B) inline function xorInt8(b:Int8):Int {
		return this ^ b.toIntBits();
	}
	@:op(A ^ B) function xorUInt8(b:UInt8):Int;
	@:op(A ^ B) inline function xorInt16(b:Int16):Int {
		return this ^ b.toIntBits();
	}
	@:op(A ^ B) @:commutative static function xorInt(a:UInt32, b:Int):Int;

	// <<
	@:op(A << B) inline function shiftLeft(b:UInt32):UInt32 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function int8ShiftLeft(b:Int8):UInt32 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function uint8ShiftLeft(b:UInt8):UInt32 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function int16ShiftLeft(b:Int16):UInt32 {
		return intShiftLeftFirst(b.toInt());
	}
	@:op(A << B) inline function intShiftLeftFirst(b:Int):UInt32 {
		var bits = (this << (b & 0xF)) & 0xFFFF;
		return new UInt32(bits);
	}
	@:op(A << B) static function intShiftLeftSecond(a:Int, b:UInt32):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:UInt32):UInt32 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function int8ShiftRight(b:Int8):UInt32 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function uint8ShiftRight(b:UInt8):UInt32 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function int16ShiftRight(b:Int16):UInt32 {
		return intShiftRightFirst(b.toInt());
	}
	@:op(A >> B) inline function intShiftRightFirst(b:Int):UInt32 {
		var result = this >> (b & 0xF);
		return new UInt32(result);
	}
	@:op(A >> B) static function intShiftRightSecond(a:Int, b:UInt32):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:UInt32):UInt32 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function int8UnsignedShiftRight(b:Int8):UInt32 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function uint8UnsignedShiftRight(b:UInt8):UInt32 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function int16UnsignedShiftRight(b:Int16):UInt32 {
		return intUnsignedShiftRightFirst(b.toInt());
	}
	@:op(A >>> B) inline function intUnsignedShiftRightFirst(b:Int):UInt32 {
		var result = this >> (b & 0xF);
		return new UInt32(result);
	}
	@:op(A >>> B) static function intUnsignedShiftRightSecond(a:Int, b:UInt32):Int;
}