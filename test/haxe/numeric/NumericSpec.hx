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
		Int8.create(-1).toIntBits() == 255;
		Int8.MIN.toIntBits() == 128;

		Int8.MIN.toIntBits().isTypeInt();
	}

	function specInt8_toUInt8Bits() {
		Int8.MAX.toUInt8Bits() == UInt8.create(127);
		Int8.create(-1).toUInt8Bits() == UInt8.MAX;
		Int8.MIN.toUInt8Bits() == UInt8.create(128);

		Int8.MIN.toUInt8Bits().isTypeUInt8();
	}

	function specInt8_toInt16() {
		Int8.MAX.toInt16() == Int16.create(127);
		Int8.create(-1).toInt16() == Int16.create(-1);
		Int8.MIN.toInt16() == Int16.create(-128);

		Int8.MIN.toInt16().isTypeInt16();
	}

	function specInt8_toInt16Bits() {
		Int8.MAX.toInt16Bits() == Int16.create(127);
		Int8.create(-1).toInt16Bits() == Int16.create(255);
		Int8.MIN.toInt16Bits() == Int16.create(128);

		Int8.MIN.toInt16Bits().isTypeInt16();
	}

	function specInt8_toUInt16Bits() {
		Int8.MAX.toUInt16Bits() == UInt16.create(127);
		Int8.create(-1).toUInt16Bits() == UInt16.create(255);
		Int8.MIN.toUInt16Bits() == UInt16.create(128);

		Int8.MIN.toUInt16Bits().isTypeUInt16();
	}

	function specUInt8_toInt8Bits() {
		UInt8.MAX.toInt8Bits() == Int8.create(-1);
		UInt8.create(128).toInt8Bits() == Int8.MIN;
		UInt8.create(127).toInt8Bits() == Int8.MAX;

		UInt8.create(127).toInt8Bits().isTypeInt8();
	}

	function specUInt8_toInt16() {
		UInt8.MAX.toInt16() == Int16.create(255);
		UInt8.MIN.toInt16() == Int16.create(0);

		UInt8.create(127).toInt16().isTypeInt16();
	}

	function specUInt8_toUInt16() {
		UInt8.MAX.toUInt16() == UInt16.create(255);
		UInt8.MIN.toUInt16() == UInt16.create(0);

		UInt8.create(127).toUInt16().isTypeUInt16();
	}

	function specInt16_toIntBits() {
		Int16.MAX.toIntBits() == 0x7FFF;
		Int16.create(-1).toIntBits() == 0xFFFF;
		Int16.MIN.toIntBits() == 0x8000;

		Int16.MIN.toIntBits().isTypeInt();
	}

	function specInt16_toUInt16Bits() {
		Int16.MAX.toUInt16Bits() == UInt16.create(0x7FFF);
		Int16.create(-1).toUInt16Bits() == UInt16.create(0xFFFF);
		Int16.MIN.toUInt16Bits() == UInt16.create(0x8000);

		Int16.MIN.toUInt16Bits().isTypeUInt16();
	}

	function specUInt16_toInt16Bits() {
		UInt16.MAX.toInt16Bits() == Int16.create(-1);
		UInt16.create(32768).toInt16Bits() == Int16.MIN;
		UInt16.create(32767).toInt16Bits() == Int16.MAX;

		UInt16.create(32767).toInt16Bits().isTypeInt16();
	}

	function specInt32_toIntBits() {
		Int32.MAX.toIntBits() == 2147483647;
		Int32.create(-1).toIntBits() == Numeric.native32BitsInt;
		Int32.MIN.toIntBits() == #if (php || python || js || lua) 2147483648 #else -2147483648 #end;

		Int32.MIN.toIntBits().isTypeInt();
	}
}