package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

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
	 * That is `new UInt8(514)` is equal to `new UInt8(2)` because `514 & 0xFF == 2`
	 */
	static public inline function create(value:Int):UInt8 {
		if(value > MAX_AS_INT || value < MIN_AS_INT) {
			#if ((debug && !OVERFLOW_WRAP) || OVERFLOW_THROW)
			throw new OverflowException('$value overflows UInt8');
			#else
			return new UInt8(bitsToValue(value & 0xFF));
			#end
		} else {
			return new UInt8(value);
		}
	}

	/**
	 * Same as `Numeric.parseBitsInt()` but returns `UInt8`
	 */
	@:noUsing
	static public function parseBits(bits:String):UInt8 {
		return new UInt8(UInt8.bitsToValue(inline Numeric.parseBitsInt(bits, UInt8.BITS_COUNT)));
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
	 * `value` must be in bounds of UInt8 range
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

	public inline function toString():String {
		return '$this';
	}

	/**
	 * Returns current value as `Int`.
	 *
	 * It does not interpret bits. That is `-1` of `UInt8` becomes `-1` of `Int`, not `255`.
	 */
	@:to inline function int():Int {
		// TODO: check if all targets can handle `to Int` instead of `@:to Int`
		return this;
	}

	@:op(-A) inline function negative():Int {
		return -this;
	}

	@:op(++A) inline function prefixIncrement():UInt8 {
		this = create(this + 1);
		return new UInt8(this);
	}

	@:op(A++) inline function postfixIncrement():UInt8 {
		var result = new UInt8(this);
		this = create(this + 1);
		return result;
	}

	@:op(--A) inline function prefixDecrement():UInt8 {
		this = create(this - 1);
		return new UInt8(this);
	}

	@:op(A--) inline function postfixDecrement():UInt8 {
		var result = new UInt8(this);
		this = create(this - 1);
		return result;
	}

	@:op(A + B) inline function addition(b:UInt8):UInt8 {
		return create(this + (b:Int));
	}
	@:op(A + B) @:commutative static function intAddition(a:UInt8, b:Int):Int;
	@:op(A + B) @:commutative static function floatAddition(a:UInt8, b:Float):Float;

	@:op(A - B) inline function subtraction(b:UInt8):UInt8 {
		return create(this - (b:Int));
	}
	@:op(A - B) static function intSubtractionFirst(a:UInt8, b:Int):Int;
	@:op(A - B) static function intSubtractionSecond(a:Int, b:UInt8):Int;
	@:op(A - B) static function floatSubtractionFirst(a:UInt8, b:Float):Float;
	@:op(A - B) static function floatSubtractionSecond(a:Float, b:UInt8):Float;

	@:op(A * B) inline function multiplication(b:UInt8):UInt8 {
		return create(this * (b:Int));
	}
	@:op(A * B) @:commutative static function intMultiplication(a:UInt8, b:Int):Int;
	@:op(A * B) @:commutative static function floatMultiplication(a:UInt8, b:Float):Float;

	@:op(A / B) function division(b:UInt8):Float;
	@:op(A / B) static function intDivisionFirst(a:UInt8, b:Int):Float;
	@:op(A / B) static function intDivisionSecond(a:Int, b:UInt8):Float;
	@:op(A / B) static function floatDivisionFirst(a:UInt8, b:Float):Float;
	@:op(A / B) static function floatDivisionSecond(a:Float, b:UInt8):Float;

	@:op(A % B) function modulo(b:UInt8):UInt8;
	@:op(A % B) static function intModuloFirst(a:UInt8, b:Int):UInt8;
	@:op(A % B) static function intModuloSecond(a:Int, b:UInt8):UInt8;
	@:op(A % B) static function floatModuloFirst(a:UInt8, b:Float):Float;
	@:op(A % B) static function floatModuloSecond(a:Float, b:UInt8):Float;

	@:op(A == B) function equal(b:UInt8):Bool;
	@:op(A == B) @:commutative static function intEqual(a:UInt8, b:Int):Bool;
	@:op(A == B) @:commutative static function floatEqual(a:UInt8, b:Float):Bool;

	@:op(A != B) function notEqual(b:UInt8):Bool;
	@:op(A != B) @:commutative static function intNotEqual(a:UInt8, b:Int):Bool;
	@:op(A != B) @:commutative static function floatNotEqual(a:UInt8, b:Float):Bool;

	@:op(A > B) function greater(b:UInt8):Bool;
	@:op(A > B) static function intGreaterFirst(a:UInt8, b:Int):Bool;
	@:op(A > B) static function intGreaterSecond(a:Int, b:UInt8):Bool;
	@:op(A > B) static function floatGreaterFirst(a:UInt8, b:Float):Bool;
	@:op(A > B) static function floatGreaterSecond(a:Float, b:UInt8):Bool;

	@:op(A >= B) function greaterOrEqual(b:UInt8):Bool;
	@:op(A >= B) static function intGreaterOrEqualFirst(a:UInt8, b:Int):Bool;
	@:op(A >= B) static function intGreaterOrEqualSecond(a:Int, b:UInt8):Bool;
	@:op(A >= B) static function floatGreaterOrEqualFirst(a:UInt8, b:Float):Bool;
	@:op(A >= B) static function floatGreaterOrEqualSecond(a:Float, b:UInt8):Bool;

	@:op(A < B) function less(b:UInt8):Bool;
	@:op(A < B) static function intLessFirst(a:UInt8, b:Int):Bool;
	@:op(A < B) static function intLessSecond(a:Int, b:UInt8):Bool;
	@:op(A < B) static function floatLessFirst(a:UInt8, b:Float):Bool;
	@:op(A < B) static function floatLessSecond(a:Float, b:UInt8):Bool;

	@:op(A <= B) function lessOrEqual(b:UInt8):Bool;
	@:op(A <= B) static function intLessOrEqualFirst(a:UInt8, b:Int):Bool;
	@:op(A <= B) static function intLessOrEqualSecond(a:Int, b:UInt8):Bool;
	@:op(A <= B) static function floatLessOrEqualFirst(a:UInt8, b:Float):Bool;
	@:op(A <= B) static function floatLessOrEqualSecond(a:Float, b:UInt8):Bool;

	@:op(~A) inline function negate():UInt8 {
		return new UInt8(valueToBits(~this));
	}

	@:op(A & B) function and(b:UInt8):UInt8;
	@:op(A & B) @:commutative static function andInt(a:UInt8, b:Int):Int;

	@:op(A | B) function or(b:UInt8):UInt8;
	@:op(A | B) @:commutative static inline function orInt8(a:UInt8, b:Int8):Int {
		return a.int() | @:privateAccess Int8.valueToBits(b);
	}
	@:op(A | B) @:commutative static function orInt(a:UInt8, b:Int):Int;

	@:op(A ^ B) function xor(b:UInt8):UInt8;
	@:op(A ^ B) @:commutative static inline function xorInt8(a:UInt8, b:Int8):Int {
		return a.int() ^ @:privateAccess Int8.valueToBits(b.int());
	}
	@:op(A ^ B) @:commutative static function xorInt(a:UInt8, b:Int):Int;

	// <<
	@:op(A << B) inline function shiftLeft(b:UInt8):UInt8 {
		return intShiftLeftFirst((b:Int));
	}
	@:op(A << B) inline function intShiftLeftFirst(b:Int):UInt8 {
		var bits = (this << (b & 0x7)) & 0xFF;
		return new UInt8(bitsToValue(bits));
	}
	@:op(A << B) static function intShiftLeftSecond(a:Int, b:UInt8):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:UInt8):UInt8 {
		return intShiftRightFirst((b:Int));
	}
	@:op(A >> B) inline function intShiftRightFirst(b:Int):UInt8 {
		var result = this >> (b & 0x7);
		return new UInt8(result);
	}
	@:op(A >> B) static function intShiftRightSecond(a:Int, b:UInt8):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:UInt8):UInt8 {
		return intUnsignedShiftRightFirst((b:Int));
	}
	@:op(A >>> B) inline function intUnsignedShiftRightFirst(b:Int):UInt8 {
		var result = valueToBits(this) >> (b & 0x7);
		return new UInt8(result);
	}
	@:op(A >>> B) static function intUnsignedShiftRightSecond(a:Int, b:UInt8):Int;
}