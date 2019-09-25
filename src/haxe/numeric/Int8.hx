package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;
import haxe.numeric.exceptions.InvalidArgumentException;

using StringTools;

abstract Int8(Int) {
	static inline var MAX_AS_INT = 0x7F;
	static inline var MIN_AS_INT = -0x80;

	static public inline var MAX:Int8 = cast MAX_AS_INT;
	static public inline var MIN:Int8 = cast MIN_AS_INT;

	static inline var BITS_COUNT = 8;

	/**
	 * Creates Int8 with `value`.
	 *
	 * In `-debug` builds or with `-D OVERFLOW_THROW`:
	 * If `value` is outside of `Int8` bounds then `haxe.numeric.exceptions.OverflowException` is thrown.
	 *
	 * In release builds or with `-D OVERFLOW_WRAP`:
	 * If `value` is outside of `Int8` bounds then only 8 less significant bits are used.
	 * That is `new Int8(514)` is equal to `new Int8(2)` because `514 & 0xFF == 2`
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

	static public function parseBits(bits:String):Int8 {
		var result = 0;
		var bitPos = BITS_COUNT;

		for(pos => code in bits) {
			switch(code) {
				case ' '.code | '\t'.code:
				case '0'.code:
					bitPos--;
				case '1'.code:
					bitPos--;
					if(bitPos >= 0) {
						result = result | 1 << bitPos;
					}
				case _:
					throw new InvalidArgumentException('Invalid character "${String.fromCharCode(code)}" at index $pos in string "$bits"');
			}
		}
		if(bitPos != 0) {
			throw new InvalidArgumentException('Bits string should contain exactly $BITS_COUNT bits. Invalid bits string "$bits"');
		}

		return new Int8(bitsToValue(result));
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

	public inline function toString():String {
		return '$this';
	}

	/**
	 * Returns current value as `Int`.
	 *
	 * It does not interpret bits. That is `-1` of `Int8` becomes `-1` of `Int`, not `255`.
	 */
	@:to inline function int():Int {
		// TODO: check if all targets can handle `to Int` instead of `@:to Int`
		return this;
	}

	@:op(-A) inline function negative():Int8 {
		return create(-this);
	}

	@:op(++A) inline function prefixIncrement():Int8 {
		this = create(this + 1);
		return new Int8(this);
	}

	@:op(A++) inline function postfixIncrement():Int8 {
		var result = new Int8(this);
		this = create(this + 1);
		return result;
	}

	@:op(--A) inline function prefixDecrement():Int8 {
		this = create(this - 1);
		return new Int8(this);
	}

	@:op(A--) inline function postfixDecrement():Int8 {
		var result = new Int8(this);
		this = create(this - 1);
		return result;
	}

	@:op(A + B) inline function addition(b:Int8):Int8 {
		return create(this + (b:Int));
	}
	@:op(A + B) @:commutative static function intAddition(a:Int8, b:Int):Int;
	@:op(A + B) @:commutative static function floatAddition(a:Int8, b:Float):Float;

	@:op(A - B) inline function subtraction(b:Int8):Int8 {
		return create(this - (b:Int));
	}
	@:op(A - B) static function intSubtractionFirst(a:Int8, b:Int):Int;
	@:op(A - B) static function intSubtractionSecond(a:Int, b:Int8):Int;
	@:op(A - B) static function floatSubtractionFirst(a:Int8, b:Float):Float;
	@:op(A - B) static function floatSubtractionSecond(a:Float, b:Int8):Float;

	@:op(A * B) inline function multiplication(b:Int8):Int8 {
		return create(this * (b:Int));
	}
	@:op(A * B) @:commutative static function intMultiplication(a:Int8, b:Int):Int;
	@:op(A * B) @:commutative static function floatMultiplication(a:Int8, b:Float):Float;

	@:op(A / B) function division(b:Int8):Float;
	@:op(A / B) static function intDivisionFirst(a:Int8, b:Int):Float;
	@:op(A / B) static function intDivisionSecond(a:Int, b:Int8):Float;
	@:op(A / B) static function floatDivisionFirst(a:Int8, b:Float):Float;
	@:op(A / B) static function floatDivisionSecond(a:Float, b:Int8):Float;

	@:op(A % B) function modulo(b:Int8):Int8;
	@:op(A % B) static function intModuloFirst(a:Int8, b:Int):Int8;
	@:op(A % B) static function intModuloSecond(a:Int, b:Int8):Int8;
	@:op(A % B) static function floatModuloFirst(a:Int8, b:Float):Float;
	@:op(A % B) static function floatModuloSecond(a:Float, b:Int8):Float;

	@:op(A == B) function equal(b:Int8):Bool;
	@:op(A == B) @:commutative static function intEqual(a:Int8, b:Int):Bool;
	@:op(A == B) @:commutative static function floatEqual(a:Int8, b:Float):Bool;

	@:op(A != B) function notEqual(b:Int8):Bool;
	@:op(A != B) @:commutative static function intNotEqual(a:Int8, b:Int):Bool;
	@:op(A != B) @:commutative static function floatNotEqual(a:Int8, b:Float):Bool;

	@:op(A > B) function greater(b:Int8):Bool;
	@:op(A > B) static function intGreaterFirst(a:Int8, b:Int):Bool;
	@:op(A > B) static function intGreaterSecond(a:Int, b:Int8):Bool;
	@:op(A > B) static function floatGreaterFirst(a:Int8, b:Float):Bool;
	@:op(A > B) static function floatGreaterSecond(a:Float, b:Int8):Bool;

	@:op(A >= B) function greaterOrEqual(b:Int8):Bool;
	@:op(A >= B) static function intGreaterOrEqualFirst(a:Int8, b:Int):Bool;
	@:op(A >= B) static function intGreaterOrEqualSecond(a:Int, b:Int8):Bool;
	@:op(A >= B) static function floatGreaterOrEqualFirst(a:Int8, b:Float):Bool;
	@:op(A >= B) static function floatGreaterOrEqualSecond(a:Float, b:Int8):Bool;

	@:op(A < B) function less(b:Int8):Bool;
	@:op(A < B) static function intLessFirst(a:Int8, b:Int):Bool;
	@:op(A < B) static function intLessSecond(a:Int, b:Int8):Bool;
	@:op(A < B) static function floatLessFirst(a:Int8, b:Float):Bool;
	@:op(A < B) static function floatLessSecond(a:Float, b:Int8):Bool;

	@:op(A <= B) function lessOrEqual(b:Int8):Bool;
	@:op(A <= B) static function intLessOrEqualFirst(a:Int8, b:Int):Bool;
	@:op(A <= B) static function intLessOrEqualSecond(a:Int, b:Int8):Bool;
	@:op(A <= B) static function floatLessOrEqualFirst(a:Int8, b:Float):Bool;
	@:op(A <= B) static function floatLessOrEqualSecond(a:Float, b:Int8):Bool;

	@:op(~A) function negate():Int8;

	@:op(A & B) function and(b:Int8):Int8;
	@:op(A & B) @:commutative static function and(a:Int8, b:Int):Int;

	@:op(A | B) function or(b:Int8):Int8;
	@:op(A | B) @:commutative static function and(a:Int8, b:Int):Int;

	@:op(A ^ B) function xor(b:Int8):Int8;
	@:op(A ^ B) @:commutative static function and(a:Int8, b:Int):Int;

	// <<
	@:op(A << B) inline function shiftLeft(b:Int8):Int8 {
		return intShiftLeftFirst((b:Int));
	}
	@:op(A << B) inline function intShiftLeftFirst(b:Int):Int8 {
		var bits = (this << (b & 0x7)) & 0xFF;
		return new Int8(bitsToValue(bits));
	}
	@:op(A << B) static function intShiftLeftSecond(a:Int, b:Int8):Int;

	// >>
	@:op(A >> B) inline function shiftRight(b:Int8):Int8 {
		return intShiftRightFirst((b:Int));
	}
	@:op(A >> B) inline function intShiftRightFirst(b:Int):Int8 {
		var result = this >> (b & 0x7);
		return new Int8(result);
	}
	@:op(A >> B) static function intShiftRightSecond(a:Int, b:Int8):Int;

	// >>>
	@:op(A >>> B) inline function unsignedShiftRight(b:Int8):Int8 {
		return intUnsignedShiftRightFirst((b:Int));
	}
	@:op(A >>> B) inline function intUnsignedShiftRightFirst(b:Int):Int8 {
		var result = valueToBits(this) >> (b & 0x7);
		return new Int8(result);
	}
	@:op(A >>> B) static function intUnsignedShiftRightSecond(a:Int, b:Int8):Int;
}