package haxe.numeric;

import haxe.io.UInt8Array;
import haxe.numeric.exceptions.OverflowException;

abstract Int8(Int) {
	static public inline var MIN:Int8 = cast -0xF;
	static public inline var MAX:Int8 = cast 0xF;

	static public inline var MIN_AS_INT = -0xF;
	static public inline var MAX_AS_INT = 0xF;

	static public inline function create(value:Int):Int8 {
		if(value > MAX_AS_INT || value < MIN_AS_INT) {
			throw new OverflowException('$value overflows Int8');
		}
		return new Int8(value);
	}

	inline function new(value:Int) {
		this = value;
	}

	// TODO: check if all targets can handle `to Int` instead of `@:to Int`
	@:to public inline function toInt():Int {
		return this;
	}

	@:op(-A) function negative():Int8;

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
		return create(this + b.toInt());
	}
	@:op(A + B) @:commutative static function intAddition(a:Int8, b:Int):Int;
	@:op(A + B) @:commutative static function floatAddition(a:Int8, b:Float):Float;

	@:op(A - B) inline function subtraction(b:Int8):Int8 {
		return create(this - b.toInt());
	}
	@:op(A - B) static function intSubtractionFirst(a:Int8, b:Int):Int;
	@:op(A - B) static function intSubtractionSecond(a:Int, b:Int8):Int;
	@:op(A - B) static function floatSubtractionFirst(a:Int8, b:Float):Float;
	@:op(A - B) static function floatSubtractionSecond(a:Float, b:Int8):Float;

	@:op(A * B) inline function multiplication(b:Int8):Int8 {
		return create(this * b.toInt());
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

	// /**
	// 	Returns `true` if `a` is not equal to `b`.
	// **/
	// @:op(A != B) public static inline function neq(a:Int8, b:Int8):Bool
	// 	return a.high != b.high || a.low != b.low;

	// @:op(A != B) @:commutative static inline function neqInt(a:Int8, b:Int):Bool
	// 	return neq(a, b);

	// @:op(A < B) static inline function lt(a:Int8, b:Int8):Bool
	// 	return compare(a, b) < 0;

	// @:op(A < B) static inline function ltInt(a:Int8, b:Int):Bool
	// 	return lt(a, b);

	// @:op(A < B) static inline function intLt(a:Int, b:Int8):Bool
	// 	return lt(a, b);

	// @:op(A <= B) static inline function lte(a:Int8, b:Int8):Bool
	// 	return compare(a, b) <= 0;

	// @:op(A <= B) static inline function lteInt(a:Int8, b:Int):Bool
	// 	return lte(a, b);

	// @:op(A <= B) static inline function intLte(a:Int, b:Int8):Bool
	// 	return lte(a, b);

	// @:op(A > B) static inline function gt(a:Int8, b:Int8):Bool
	// 	return compare(a, b) > 0;

	// @:op(A > B) static inline function gtInt(a:Int8, b:Int):Bool
	// 	return gt(a, b);

	// @:op(A > B) static inline function intGt(a:Int, b:Int8):Bool
	// 	return gt(a, b);

	// @:op(A >= B) static inline function gte(a:Int8, b:Int8):Bool
	// 	return compare(a, b) >= 0;

	// @:op(A >= B) static inline function gteInt(a:Int8, b:Int):Bool
	// 	return gte(a, b);

	// @:op(A >= B) static inline function intGte(a:Int, b:Int8):Bool
	// 	return gte(a, b);

	// /**
	// 	Returns the bitwise NOT of `a`.
	// **/
	// @:op(~A) static inline function complement(a:Int8):Int8
	// 	return make(~a.high, ~a.low);

	// /**
	// 	Returns the bitwise AND of `a` and `b`.
	// **/
	// @:op(A & B) public static inline function and(a:Int8, b:Int8):Int8
	// 	return make(a.high & b.high, a.low & b.low);

	// /**
	// 	Returns the bitwise OR of `a` and `b`.
	// **/
	// @:op(A | B) public static inline function or(a:Int8, b:Int8):Int8
	// 	return make(a.high | b.high, a.low | b.low);

	// /**
	// 	Returns the bitwise XOR of `a` and `b`.
	// **/
	// @:op(A ^ B) public static inline function xor(a:Int8, b:Int8):Int8
	// 	return make(a.high ^ b.high, a.low ^ b.low);

	// /**
	// 	Returns `a` left-shifted by `b` bits.
	// **/
	// @:op(A << B) public static inline function shl(a:Int8, b:Int):Int8 {
	// 	b &= 63;
	// 	return if (b == 0) a.copy() else if (b < 32) make((a.high << b) | (a.low >>> (32 - b)), a.low << b) else make(a.low << (b - 32), 0);
	// }

	// /**
	// 	Returns `a` right-shifted by `b` bits in signed mode.
	// 	`a` is sign-extended.
	// **/
	// @:op(A >> B) public static inline function shr(a:Int8, b:Int):Int8 {
	// 	b &= 63;
	// 	return if (b == 0) a.copy() else if (b < 32) make(a.high >> b, (a.high << (32 - b)) | (a.low >>> b)); else make(a.high >> 31, a.high >> (b - 32));
	// }

	// /**
	// 	Returns `a` right-shifted by `b` bits in unsigned mode.
	// 	`a` is padded with zeroes.
	// **/
	// @:op(A >>> B) public static inline function ushr(a:Int8, b:Int):Int8 {
	// 	b &= 63;
	// 	return if (b == 0) a.copy() else if (b < 32) make(a.high >>> b, (a.high << (32 - b)) | (a.low >>> b)); else make(0, a.high >>> (b - 32));
	// }

	public inline function toString():String {
		return '$this';
	}
}