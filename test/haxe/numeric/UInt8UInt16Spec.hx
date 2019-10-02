package haxe.numeric;

class UInt8UInt16Spec extends TestBase {
	function specAddition() {
		255 + 65535 == UInt8.MAX + UInt16.MAX;
		255 + 65535 == UInt16.MAX + UInt8.MAX;

		(UInt8.MAX + UInt16.MAX).isTypeInt();
		(UInt16.MAX + UInt8.MAX).isTypeInt();
	}

	function specSubtraction() {
		255 - 65535 == UInt8.MAX - UInt16.MAX;
		65535 - 255 == UInt16.MAX - UInt8.MAX;

		(UInt8.MAX - UInt16.MAX).isTypeInt();
		(UInt16.MAX - UInt8.MAX).isTypeInt();
	}

	function specMultiplication() {
		255 * 65535 == UInt8.MAX * UInt16.MAX;
		65535 * 255 == UInt16.MAX * UInt8.MAX;

		(UInt8.MAX * UInt16.MAX).isTypeInt();
		(UInt16.MAX * UInt8.MAX).isTypeInt();
	}

	function specDivision() {
		255 / 65535 == UInt8.MAX / UInt16.MAX;
		65535 / 255 == UInt16.MAX / UInt8.MAX;

		(UInt8.MAX / UInt16.MAX).isTypeFloat();
		(UInt16.MAX / UInt8.MAX).isTypeFloat();
	}

	function specModulo() {
		255 % 65535 == UInt8.MAX % UInt16.MAX;
		65535 % 255 == UInt16.MAX % UInt8.MAX;

		(UInt8.MAX % UInt16.MAX).isTypeUInt8();
		(UInt16.MAX % UInt8.MAX).isTypeUInt16();
	}

	function specOr() {
		Numeric.parseBitsInt('0010 0011 1100 0011', 16) == UInt8.parseBits('1000 0001') | UInt16.parseBits('0010 0011 1100 0011');
		Numeric.parseBitsInt('1010 0011 1100 0011', 16) == UInt16.parseBits('1010 0011 1100 0011') | UInt8.parseBits('1000 0001');

		(UInt8.MAX | UInt16.MAX).isTypeInt();
		(UInt16.MAX | UInt8.MAX).isTypeInt();
	}

	function specAnd() {
		Numeric.parseBitsInt('0000 0000 1000 0001', 16) == UInt8.parseBits('1000 0001') & UInt16.parseBits('1010 0011 1100 0011');
		Numeric.parseBitsInt('0000 0000 1000 0001', 16) == UInt16.parseBits('1000 0011 1100 0001') & UInt8.parseBits('1010 0011');

		(UInt8.MAX & UInt16.MAX).isTypeInt();
		(UInt16.MAX & UInt8.MAX).isTypeInt();
	}

	function specXor() {
		Numeric.parseBitsInt('1010 0011 0100 0010', 16) == UInt8.parseBits('1000 0001') ^ UInt16.parseBits('1010 0011 1100 0011');
		Numeric.parseBitsInt('1000 0011 0110 0010', 16) == UInt16.parseBits('1000 0011 1100 0001') ^ UInt8.parseBits('1010 0011');

		(UInt8.MAX ^ UInt16.MAX).isTypeInt();
		(UInt16.MAX ^ UInt8.MAX).isTypeInt();
	}

	function specShiftLeft() {
		UInt8.parseBits('0000 0100') == UInt8.parseBits('1000 0001') << UInt16.create(2);
		UInt16.parseBits('0000 1111 0000 0100') == UInt16.parseBits('1000 0011 1100 0001') << UInt8.create(2);

		(UInt8.MAX << UInt16.MAX).isTypeUInt8();
		(UInt16.MAX << UInt8.MAX).isTypeUInt16();
	}

	function specShiftRight() {
		UInt8.parseBits('0010 0000') == UInt8.parseBits('1000 0001') >> UInt16.create(2);
		UInt16.parseBits('0010 0000 1111 0000') == UInt16.parseBits('1000 0011 1100 0001') >> UInt8.create(2);

		(UInt8.MAX >> UInt16.MAX).isTypeUInt8();
		(UInt16.MAX >> UInt8.MAX).isTypeUInt16();
	}

	function specUnsignedShiftRight() {
		UInt8.parseBits('0010 0000') == UInt8.parseBits('1000 0001') >>> UInt16.create(2);
		UInt16.parseBits('0010 0000 1111 0000') == UInt16.parseBits('1000 0011 1100 0001') >>> UInt8.create(2);

		(UInt8.MAX >>> UInt16.MAX).isTypeUInt8();
		(UInt16.MAX >>> UInt8.MAX).isTypeUInt16();
	}
}