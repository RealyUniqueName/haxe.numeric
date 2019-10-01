package haxe.numeric;

class Int16UInt16Spec extends TestBase {
	function specAddition() {
		32767 + 65535 == Int16.MAX + UInt16.MAX;
		32767 + 65535 == UInt16.MAX + Int16.MAX;

		(Int16.MAX + UInt16.MAX).isTypeInt();
		(UInt16.MAX + Int16.MAX).isTypeInt();
	}

	function specSubtraction() {
		32767 - 65535 == Int16.MAX - UInt16.MAX;
		65535 - 32767 == UInt16.MAX - Int16.MAX;

		(Int16.MAX - UInt16.MAX).isTypeInt();
		(UInt16.MAX - Int16.MAX).isTypeInt();
	}

	function specMultiplication() {
		32767 * 65535 == Int16.MAX * UInt16.MAX;
		65535 * 32767 == UInt16.MAX * Int16.MAX;

		(Int16.MAX * UInt16.MAX).isTypeInt();
		(UInt16.MAX * Int16.MAX).isTypeInt();
	}

	function specDivision() {
		32767 / 65535 == Int16.MAX / UInt16.MAX;
		65535 / 32767 == UInt16.MAX / Int16.MAX;

		(Int16.MAX / UInt16.MAX).isTypeFloat();
		(UInt16.MAX / Int16.MAX).isTypeFloat();
	}

	function specModulo() {
		(-32768) % 65535 == Int16.MIN % UInt16.MAX;
		65535 % (-32768) == UInt16.MAX % Int16.MIN;

		(Int16.MAX % UInt16.MAX).isTypeInt16();
		(UInt16.MAX % Int16.MAX).isTypeUInt16();
	}

	function specOr() {
		Numeric.parseBitsInt('1010 1011 1101 0011', 16) == Int16.parseBits('1000 0011 1100 0001') | UInt16.parseBits('0010 1010 0101 0011');
		Numeric.parseBitsInt('1010 1011 1101 0011', 16) == UInt16.parseBits('0010 1010 0101 0011') | Int16.parseBits('1000 0011 1100 0001');

		(Int16.MAX | UInt16.MAX).isTypeInt();
		(UInt16.MAX | Int16.MAX).isTypeInt();
	}

	function specAnd() {
		Numeric.parseBitsInt('1000 0010 0100 0001', 16) == Int16.parseBits('1000 0011 1100 0001') & UInt16.parseBits('1010 1010 0101 0011');
		Numeric.parseBitsInt('1000 0010 0100 0001', 16) == UInt16.parseBits('1000 1010 0101 0001') & Int16.parseBits('1010 0011 1100 0011');

		(Int16.MAX & UInt16.MAX).isTypeInt();
		(UInt16.MAX & Int16.MAX).isTypeInt();
	}

	function specXor() {
		Numeric.parseBitsInt('0010 1001 1001 0010', 16) == Int16.parseBits('1000 0011 1100 0001') ^ UInt16.parseBits('1010 1010 0101 0011');
		Numeric.parseBitsInt('0010 1001 1001 0010', 16) == UInt16.parseBits('1000 1010 0101 0001') ^ Int16.parseBits('1010 0011 1100 0011');

		(Int16.MAX ^ UInt16.MAX).isTypeInt();
		(UInt16.MAX ^ Int16.MAX).isTypeInt();
	}

	function specShiftLeft() {
		Int16.parseBits('0000 1111 0000 0100') == Int16.parseBits('1000 0011 1100 0001') << UInt16.create(2);
		UInt16.parseBits('0010 1001 0100 0100') == UInt16.parseBits('1000 1010 0101 0001') << Int16.create(2);

		(Int16.MAX << UInt16.MAX).isTypeInt16();
		(UInt16.MAX << Int16.MAX).isTypeUInt16();
	}

	function specShiftRight() {
		Int16.parseBits('1110 0000 1111 0000') == Int16.parseBits('1000 0011 1100 0001') >> UInt16.create(2);
		UInt16.parseBits('0010 0010 1001 0100') == UInt16.parseBits('1000 1010 0101 0001') >> Int16.create(2);

		(Int16.MAX >> UInt16.MAX).isTypeInt16();
		(UInt16.MAX >> Int16.MAX).isTypeUInt16();
	}

	function specUnsignedShiftRight() {
		Int16.parseBits('0010 0000 1111 0000') == Int16.parseBits('1000 0011 1100 0001') >>> UInt16.create(2);
		UInt16.parseBits('0010 0010 1001 0100') == UInt16.parseBits('1000 1010 0101 0001') >>> Int16.create(2);

		(Int16.MAX >>> UInt16.MAX).isTypeInt16();
		(UInt16.MAX >>> Int16.MAX).isTypeUInt16();
	}
}