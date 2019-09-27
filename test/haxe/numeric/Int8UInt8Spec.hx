package haxe.numeric;

class Int8UInt8Spec extends TestBase {
	function specAddition() {
		127 + 255 == Int8.MAX + UInt8.MAX;
		127 + 255 == UInt8.MAX + Int8.MAX;

		(Int8.MAX + UInt8.MAX).isTypeInt();
		(UInt8.MAX + Int8.MAX).isTypeInt();
	}

	function specSubtraction() {
		127 - 255 == Int8.MAX - UInt8.MAX;
		255 - 127 == UInt8.MAX - Int8.MAX;

		(Int8.MAX - UInt8.MAX).isTypeInt();
		(UInt8.MAX - Int8.MAX).isTypeInt();
	}

	function specMultiplication() {
		127 * 255 == Int8.MAX * UInt8.MAX;
		255 * 127 == UInt8.MAX * Int8.MAX;

		(Int8.MAX * UInt8.MAX).isTypeInt();
		(UInt8.MAX * Int8.MAX).isTypeInt();
	}

	function specDivision() {
		127 / 255 == Int8.MAX / UInt8.MAX;
		255 / 127 == UInt8.MAX / Int8.MAX;

		(Int8.MAX / UInt8.MAX).isTypeFloat();
		(UInt8.MAX / Int8.MAX).isTypeFloat();
	}

	function specModulo() {
		(-128) % 255 == Int8.MIN % UInt8.MAX;
		255 % (-128) == UInt8.MAX % Int8.MIN;

		(Int8.MAX % UInt8.MAX).isTypeInt8();
		(UInt8.MAX % Int8.MAX).isTypeUInt8();
	}

	function specOr() {
		Numeric.parseBitsInt('1010 0011', 8) == Int8.parseBits('1000 0001') | UInt8.parseBits('0010 0011');
		Numeric.parseBitsInt('1010 0011', 8) == UInt8.parseBits('0010 0011') | Int8.parseBits('1000 0001');

		(Int8.MAX | UInt8.MAX).isTypeInt();
		(UInt8.MAX | Int8.MAX).isTypeInt();
	}

	function specAnd() {
		Numeric.parseBitsInt('1000 0001', 8) == Int8.parseBits('1000 0001') & UInt8.parseBits('1010 0011');
		Numeric.parseBitsInt('1000 0001', 8) == UInt8.parseBits('1000 0001') & Int8.parseBits('1010 0011');

		(Int8.MAX & UInt8.MAX).isTypeInt();
		(UInt8.MAX & Int8.MAX).isTypeInt();
	}

	function specXor() {
		Numeric.parseBitsInt('0010 0010', 8) == Int8.parseBits('1000 0001') ^ UInt8.parseBits('1010 0011');
		Numeric.parseBitsInt('0010 0010', 8) == UInt8.parseBits('1000 0001') ^ Int8.parseBits('1010 0011');

		(Int8.MAX ^ UInt8.MAX).isTypeInt();
		(UInt8.MAX ^ Int8.MAX).isTypeInt();
	}

	function specShiftLeft() {
		Int8.parseBits('0000 0100') == Int8.parseBits('1000 0001') << UInt8.create(2);
		UInt8.parseBits('0000 0100') == UInt8.parseBits('1000 0001') << Int8.create(2);

		(Int8.MAX << UInt8.MAX).isTypeInt8();
		(UInt8.MAX << Int8.MAX).isTypeUInt8();
	}

	function specShiftRight() {
		Int8.parseBits('1110 0000') == Int8.parseBits('1000 0001') >> UInt8.create(2);
		UInt8.parseBits('0010 0000') == UInt8.parseBits('1000 0001') >> Int8.create(2);

		(Int8.MAX >> UInt8.MAX).isTypeInt8();
		(UInt8.MAX >> Int8.MAX).isTypeUInt8();
	}

	function specUnsignedShiftRight() {
		Int8.parseBits('0010 0000') == Int8.parseBits('1000 0001') >>> UInt8.create(2);
		UInt8.parseBits('0010 0000') == UInt8.parseBits('1000 0001') >>> Int8.create(2);

		(Int8.MAX >>> UInt8.MAX).isTypeInt8();
		(UInt8.MAX >>> Int8.MAX).isTypeUInt8();
	}
}