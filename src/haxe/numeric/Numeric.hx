package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;

using StringTools;

/**
 * This whole module (not only `Numeric` class) is intended for usage in `using` directives.
 */
class Numeric {
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

	/**
	 * Parse string binary representation of a number into `Int` value.
	 * E.g. `parseBitsInt("1000 0010", 8)` will produce `130`.
	 *
	 * It is not recommended to use this function for negative values or values higher than `2^31 - 1`.
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
	 * Int8.create(-1).toUInt8Bits() == Int16.create(255);
	 * ```
	 * because binary representation of `Int8.create(-1)` is `1111 1111`
	 */
	static public inline function toInt16Bits(i8:Int8):Int16 {
		return new Int16(Int8.valueToBits(i8.toInt()));
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
}