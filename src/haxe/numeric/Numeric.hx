package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;

using StringTools;

/**
 * This whole module (not only `Numeric` class) is intended for usage in `using` directives.
 */
class Numeric {

	@:inheritDoc(haxe.numeric.Int8.create)
	static public inline function toInt8(n:Int):Int8 {
		return Int8.create(n);
	}

	@:inheritDoc(haxe.numeric.UInt8.create)
	static public inline function toUInt8(n:Int):UInt8 {
		return UInt8.create(n);
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
	/**
	 * Alias for `haxe.numeric.Int8.parseBits`
	 */
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
		return @:privateAccess Int8.valueToBits(i8.toInt());
	}

	/**
	 * Convert `Int8` to `UInt8` by bits.
	 * ```haxe
	 * Int8.create(-1).toUInt8Bits() == 255
	 * ```
	 * because binary representation of `Int8.create(-1)` is `1111 1111`
	 */
	static public inline function toUInt8Bits(i8:Int8):UInt8 {
		return @:privateAccess new UInt8(Int8.valueToBits(i8.toInt()));
	}
}

class UInt8Utils {
	/**
	 * Alias for `haxe.numeric.UInt8.parseBits`
	 */
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
		return @:privateAccess new Int8(Int8.bitsToValue(u8.toInt()));
	}
}