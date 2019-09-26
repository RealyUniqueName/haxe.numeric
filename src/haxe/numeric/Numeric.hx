package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;

using StringTools;

class Numeric {

	/**
	 * Alias for `haxe.numeric.Int8.create`
	 */
	static public inline function toInt8(n:Int):Int8 {
		return Int8.create(n);
	}

	/**
	 * Alias for `haxe.numeric.UInt8.create`
	 */
	static public inline function toUInt8(n:Int):UInt8 {
		return UInt8.create(n);
	}

	/**
	 * Parse string binary representation of a number into an integer.
	 * E.g. `parseBits("1000 0010")` will produce `130`.
	 *
	 * @param bits - a binary string. Any spaces are ignored.
	 * @param bitsCount - exact amount of bits allowed in `bits` string.
	 *
	 * @throws InvalidArgumentException - if amount of bits in `bits` string does not match `bitsCount`
	 * or if `bits` contains any characters other than `"0"`, `"1"` or space.
	 *
	 * @return Int
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

	/**
	 * Alias for `haxe.numeric.Numeric.parseBitsInt8`
	 */
	static public inline function parseBitsInt8(bits:String):Int8 {
		return Int8.parseBits(bits);
	}

	/**
	 * Alias for `haxe.numeric.Numeric.parseBitsUInt8`
	 */
	static public inline function parseBitsUInt8(bits:String):UInt8 {
		return UInt8.parseBits(bits);
	}
}