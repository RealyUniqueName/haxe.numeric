package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;

using StringTools;

/**
 * This whole module (not only `Numeric` class) is intended for usage in `using` directives.
 */
class Numeric {
	/**
	 * An integer with exactly 32 bits set to `1` at runtime.
	 * The value is either `-1` or `4294967295` depending on a target platform (32bit or 64bit)
	 *
	 * NOTICE for javascript target:
	 * Be aware that Javascript runtimes can correctly store up to `2^53 - 1` integer values,
	 * but they convert numbers to 32 bit integers for bitwise operations.
	 * That's why `Numeric.native32BitsInt` is `-1` for JS.
	 */
	static public var native32BitsInt(get,never):Int;
	static var __native32BitsInt:Int = 0;
	static inline function get_native32BitsInt():Int {
		//Haxe transforms `0xFFFFFFFF` literal to -1 on compilation, which is not 32bits in some runtimes.
		#if php
			return php.Syntax.code('0xFFFFFFFF');
		#elseif python
			return python.Syntax.code('0xFFFFFFFF');
		#elseif js //while JS can store integers up to (2^51-1) all JS runtimes clamp integers to 32bits on bit ops
			return -1;
		#elseif lua
			return untyped __lua__('4294967295');
		#elseif (eval || flash)
			return 0xFFFFFFFF;
		// #elseif cpp
		// 	???
		// #elseif hl
		// 	???
		// #elseif cs
		// 	???
		// #elseif java
		// 	???
		#else
			return __native32BitsInt == 0 ? calc32BitsInt() : __native32BitsInt;
		#end
	}
	static function calc32BitsInt():Int {
		__native32BitsInt = 0;
		for(i in 0...32) {
			__native32BitsInt = __native32BitsInt | 1 << i;
		}
		return __native32BitsInt;
	}

	/**
	 * Detects if `Int` is represented by 32 bit integers in current runtime.
	 *
	 * NOTICE for javascript target:
	 * Be aware that Javascript runtimes can correctly store up to `2^53 - 1` integer values,
	 * but they convert numbers to 32 bit integers for bitwise operations.
	 * That's why `is32BitsIntegers` is `false` for JS.
	 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
	 */
	static public var is32BitsIntegers(get,never):Bool;
	static inline function get_is32BitsIntegers():Bool {
		return Numeric.native32BitsInt < 0;
	}

	@:inheritDoc(haxe.numeric.Int8.create)
	static public inline function toInt8(value:Int):Int8 {
		return Int8.create(value);
	}

	@:inheritDoc(haxe.numeric.Int8.createBits)
	static public inline function toInt8Bits(value:Int):Int8 {
		return Int8.createBits(value);
	}

	@:inheritDoc(haxe.numeric.UInt8.create)
	static public inline function toUInt8(value:Int):UInt8 {
		return UInt8.create(value);
	}

	@:inheritDoc(haxe.numeric.Int16.create)
	static public inline function toInt16(value:Int):Int16 {
		return Int16.create(value);
	}

	@:inheritDoc(haxe.numeric.Int16.createBits)
	static public inline function toInt16Bits(value:Int):Int16 {
		return Int16.createBits(value);
	}

	@:inheritDoc(haxe.numeric.UInt16.createBits)
	static public inline function toUInt16(value:Int):UInt16 {
		return UInt16.create(value);
	}

	@:inheritDoc(haxe.numeric.Int32.create)
	static public inline function toInt32(value:Int):Int32 {
		return Int32.create(value);
	}

	@:inheritDoc(haxe.numeric.Int32.createBits)
	static public inline function toInt32Bits(value:Int):Int32 {
		return Int32.createBits(value);
	}

	@:inheritDoc(haxe.numeric.UInt32.create)
	static public inline function toUInt32(value:Int):UInt32 {
		return UInt32.create(value);
	}

	@:inheritDoc(haxe.numeric.UInt32.createBits)
	static public inline function toUInt32Bits(value:Int):UInt32 {
		return UInt32.createBits(value);
	}

	/**
	 * Parse string binary representation of a number into `Int` value.
	 * E.g. `parseBitsInt("1000 0010", 8)` will produce `130`.
	 *
	 * It is _not_ recommended to use this function for negative values or values higher than `2^31 - 1`.
	 * Otherwise The result is platform dependent.
	 * That is, result may vary depending on runtime integer representation (32 bits or 64 bits)
	 * and target platform behavior on bitwise operations (e.g. javascript runtime always converts
	 * numbers to 32 bit signed integers for bitwise operations).
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 * @param bitsCount - exact amount of bits allowed in `bits` string.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string does not match `bitsCount`
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 */
	static public function parseBitsInt(bits:String, bitsCount:Int):Int {
		var result = 0;
		var bitPos = bitsCount;

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
			throw new InvalidArgumentException('Bits string should contain exactly $bitsCount bits. Invalid bits string "$bits"');
		}

		return result;
	}
}

class Int8Utils {
	@:inheritDoc(haxe.numeric.Int8.parseBits)
	static public inline function parseBitsInt8(bits:String):Int8 {
		return Int8.parseBits(bits);
	}

	/**
	 * Convert `Int8` to `Int` by bits.
	 * ```haxe
	 * Int8.create(-1).toIntBits() == 255
	 * ```
	 * because binary representation of `Int8.create(-1)` is `1111 1111`
	 */
	static public inline function toIntBits(i8:Int8):Int {
		return Int8.valueToBits(i8.toInt());
	}

	/**
	 * Convert `Int8` to `UInt8` by bits.
	 * ```haxe
	 * Int8.create(-1).toUInt8Bits() == 255
	 * ```
	 * because binary representation of `Int8.create(-1)` is `1111 1111`
	 */
	static public inline function toUInt8Bits(i8:Int8):UInt8 {
		return new UInt8(Int8.valueToBits(i8.toInt()));
	}

	/**
	 * Convert `Int8` to `Int16` by value.
	 * ```haxe
	 * Int8.create(-1).toInt16() == Int16.create(-1);
	 * ```
	 */
	static public inline function toInt16(i8:Int8):Int16 {
		return new Int16(i8.toInt());
	}

	/**
	 * Convert `Int8` to `Int16` by bits.
	 * ```haxe
	 * Int8.create(-1).toInt16Bits() == Int16.create(255);
	 * ```
	 * because binary representation of `Int8.create(-1)` is `1111 1111`
	 */
	static public inline function toInt16Bits(i8:Int8):Int16 {
		return new Int16(Int8.valueToBits(i8.toInt()));
	}

	/**
	 * Convert `Int8` to `UInt16` by bits.
	 * ```haxe
	 * Int8.create(-1).toUInt16Bits() == UInt16.create(255);
	 * ```
	 * because binary representation of `Int8.create(-1)` is `1111 1111`
	 */
	static public inline function toUInt16Bits(i8:Int8):UInt16 {
		return new UInt16(Int8.valueToBits(i8.toInt()));
	}
}

class UInt8Utils {
	@:inheritDoc(haxe.numeric.UInt8.parseBits)
	static public inline function parseBitsUInt8(bits:String):UInt8 {
		return UInt8.parseBits(bits);
	}

	/**
	 * Convert `UInt8` to `Int8` by bits.
	 * ```haxe
	 * UInt8.create(255).toInt8Bits() == -1
	 * ```
	 * because binary representation of `UInt8.create(255)` is `1111 1111`
	 */
	static public inline function toInt8Bits(u8:UInt8):Int8 {
		return new Int8(Int8.bitsToValue(u8.toInt()));
	}

	/**
	 * Convert `UInt8` to `Int16`.
	 */
	static public inline function toInt16(u8:UInt8):Int16 {
		return new Int16(u8.toInt());
	}

	/**
	 * Convert `UInt8` to `UInt16`.
	 */
	static public inline function toUInt16(u8:UInt8):UInt16 {
		return new UInt16(u8.toInt());
	}
}

class Int16Utils {
	@:inheritDoc(haxe.numeric.Int16.parseBits)
	static public inline function parseBitsInt16(bits:String):Int16 {
		return Int16.parseBits(bits);
	}

	/**
	 * Convert `Int16` to `Int` by bits.
	 * ```haxe
	 * Int16.create(-1).toIntBits() == 65535
	 * ```
	 * because binary representation of `Int16.create(-1)` is `1111 1111 1111 1111`
	 */
	static public inline function toIntBits(i16:Int16):Int {
		return Int16.valueToBits(i16.toInt());
	}

	/**
	 * Convert `Int16` to `UInt16` by bits.
	 * ```haxe
	 * Int16.create(-1).toUInt16Bits() == 65535
	 * ```
	 * because binary representation of `Int16.create(-1)` is `1111 1111 1111 1111`
	 */
	static public inline function toUInt16Bits(i16:Int16):UInt16 {
		return new UInt16(Int16.valueToBits(i16.toInt()));
	}
}

class UInt16Utils {
	@:inheritDoc(haxe.numeric.UInt16.parseBits)
	static public inline function parseBitsUInt16(bits:String):UInt16 {
		return UInt16.parseBits(bits);
	}

	/**
	 * Convert `UInt16` to `Int16` by bits.
	 * ```haxe
	 * UInt16.create(65535).toInt16Bits() == -1
	 * ```
	 * because binary representation of `UInt16.create(65535)` is `1111 1111 1111 1111`
	 */
	static public inline function toInt16Bits(u16:UInt16):Int16 {
		return new Int16(Int16.bitsToValue(u16.toInt()));
	}
}

class Int32Utils {
	@:inheritDoc(haxe.numeric.Int32.parseBits)
	static public inline function parseBitsInt32(bits:String):Int32 {
		return Int32.parseBits(bits);
	}

	/**
	 * Convert `Int32` to `Int` by bits.
	 * ```haxe
	 * Int32.create(-1).toIntBits() == -1; // on 32bit platforms
	 * Int32.create(-1).toIntBits() == 4294967295; // on 64bit platforms
	 * ```
	 */
	static public inline function toIntBits(i32:Int32):Int {
		return Int32.valueToBits(i32.toInt());
	}
}

class UInt32Utils {
	@:inheritDoc(haxe.numeric.UInt32.parseBits)
	static public inline function parseBitsUInt32(bits:String):UInt32 {
		return UInt32.parseBits(bits);
	}

	/**
	 * Convert `UInt32` to `Int` by bits.
	 * ```haxe
	 * UInt32.MAX.toIntBits() == -1; // on 32bit platforms
	 * UInt32.MAX.toIntBits() == 4294967295; // on 64bit platforms
	 * ```
	 */
	static public inline function toIntBits(u32:UInt32):Int {
		return u32.toInt();
	}
}