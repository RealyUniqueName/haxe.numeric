package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;
using haxe.numeric.Numeric;

class NumericSpec extends TestBase {
	function specParseIntBits() {
		'0'.parseBitsInt(1) == 0;
		'100'.parseBitsInt(3) == 4;
		'1111 1111 1111 1111'.parseBitsInt(16) == 0xFFFF;
		' 1 	  1 	0 '.parseBitsInt(3) == 6;

		'0000'.parseBitsInt(4).isTypeInt();

		Assert.raises(() -> '10'.parseBitsInt(1), InvalidArgumentException);
		Assert.raises(() -> '10'.parseBitsInt(3), InvalidArgumentException);
		Assert.raises(() -> '23'.parseBitsInt(2), InvalidArgumentException);
	}

	function specInt8_toIntBits() {
		Int8.MAX.toIntBits() == 127;
		Int8.create(-1).toUInt8Bits() == 255;
		Int8.MIN.toIntBits() == 128;
	}

	function specInt8_toUInt8Bits() {
		Int8.MAX.toUInt8Bits() == UInt8.create(127);
		Int8.create(-1).toUInt8Bits() == UInt8.MAX;
		Int8.MIN.toUInt8Bits() == UInt8.create(128);
	}

	function specUInt8_toInt8Bits() {
		UInt8.MAX.toInt8Bits() == Int8.create(-1);
		UInt8.create(128).toInt8Bits() == Int8.MIN;
		UInt8.create(127).toInt8Bits() == Int8.MAX;
	}
}