package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;

using StringTools;

@:access(haxe.numeric)
class Numeric {
	/**
	 * Parse string binary representation of a number into an integer.
	 * E.g. `parseBits("1000 0010")` will produce `130`.
	 *
	 * @param bits	a binary string. Any spaces are ignored.
	 * @param bitsCount	exact amount of bits to be parsed.
	 *
	 * @throws InvalidArgumentException	if amount of bits in `bits` string does not match `bitsCount`
	 * 						or if `bits` contains any characters other than `"0"`, `"1"` or space.
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
	 * Same as `Numeric.parseBitsInt()` but returns `Int8`
	 */
	static public function parseBitsInt8(bits:String):Int8 {
		return new Int8(Int8.bitsToValue(inline parseBitsInt(bits, Int8.BITS_COUNT)));
	}
}