package haxe.numeric;

class Int16UInt8Spec extends TestBase {
	function specAddition() {
		32767 + 255 == Int16.MAX + UInt8.MAX;
		32767 + 255 == UInt8.MAX + Int16.MAX;

		(Int16.MAX + UInt8.MAX).isTypeInt();
		(UInt8.MAX + Int16.MAX).isTypeInt();
	}

	function specSubtraction() {
		32767 - 255 == Int16.MAX - UInt8.MAX;
		255 - 32767 == UInt8.MAX - Int16.MAX;

		(Int16.MAX - UInt8.MAX).isTypeInt();
		(UInt8.MAX - Int16.MAX).isTypeInt();
	}

	function specMultiplication() {
		32767 * 255 == Int16.MAX * UInt8.MAX;
		255 * 32767 == UInt8.MAX * Int16.MAX;

		(Int16.MAX * UInt8.MAX).isTypeInt();
		(UInt8.MAX * Int16.MAX).isTypeInt();
	}

	function specDivision() {
		32767 / 255 == Int16.MAX / UInt8.MAX;
		255 / 32767 == UInt8.MAX / Int16.MAX;

		(Int16.MAX / UInt8.MAX).isTypeFloat();
		(UInt8.MAX / Int16.MAX).isTypeFloat();
	}

	function specModulo() {
		(-32768) % 255 == Int16.MIN % UInt8.MAX;
		255 % (-32768) == UInt8.MAX % Int16.MIN;

		(Int16.MAX % UInt8.MAX).isTypeInt16();
		(UInt8.MAX % Int16.MAX).isTypeUInt8();
	}

	function specOr() {
		Numeric.parseBitsInt('1000 0011 1110 0011', 16) == Int16.parseBits('1000 0011 1100 0001') | UInt8.parseBits('0010 0011');
		Numeric.parseBitsInt('1000 0011 1110 0011', 16) == UInt8.parseBits('0010 0011') | Int16.parseBits('1000 0011 1100 0001');

		(Int16.MAX | UInt8.MAX).isTypeInt();
		(UInt8.MAX | Int16.MAX).isTypeInt();
	}

	function specAnd() {
		Numeric.parseBitsInt('0000 0000 1000 0001', 16) == Int16.parseBits('1000 0011 1100 0001') & UInt8.parseBits('1010 0011');
		Numeric.parseBitsInt('0000 0000 1000 0001', 16) == UInt8.parseBits('1000 0001') & Int16.parseBits('1010 0011 1100 0011');

		(Int16.MAX & UInt8.MAX).isTypeInt();
		(UInt8.MAX & Int16.MAX).isTypeInt();
	}

	function specXor() {
		Numeric.parseBitsInt('1000 0011 0110 0010', 16) == Int16.parseBits('1000 0011 1100 0001') ^ UInt8.parseBits('1010 0011');
		Numeric.parseBitsInt('1010 0011 0100 0010', 16) == UInt8.parseBits('1000 0001') ^ Int16.parseBits('1010 0011 1100 0011');

		(Int16.MAX ^ UInt8.MAX).isTypeInt();
		(UInt8.MAX ^ Int16.MAX).isTypeInt();
	}

	function specShiftLeft() {
		Int16.parseBits('0000 1111 0000 0100') == Int16.parseBits('1000 0011 1100 0001') << UInt8.create(2);
		UInt8.parseBits('0000 0100') == UInt8.parseBits('1000 0001') << Int16.create(2);

		(Int16.MAX << UInt8.MAX).isTypeInt16();
		(UInt8.MAX << Int16.MAX).isTypeUInt8();
	}

	function specShiftRight() {
		Int16.parseBits('1110 0000 1111 0000') == Int16.parseBits('1000 0011 1100 0001') >> UInt8.create(2);
		UInt8.parseBits('0010 0000') == UInt8.parseBits('1000 0001') >> Int16.create(2);

		(Int16.MAX >> UInt8.MAX).isTypeInt16();
		(UInt8.MAX >> Int16.MAX).isTypeUInt8();
	}

	function specUnsignedShiftRight() {
		Int16.parseBits('0010 0000 1111 0000') == Int16.parseBits('1000 0011 1100 0001') >>> UInt8.create(2);
		UInt8.parseBits('0010 0000') == UInt8.parseBits('1000 0001') >>> Int16.create(2);

		(Int16.MAX >>> UInt8.MAX).isTypeInt16();
		(UInt8.MAX >>> Int16.MAX).isTypeUInt8();
	}
}