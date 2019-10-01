package haxe.numeric;

class Int8Int16Spec extends TestBase {
	function specAddition() {
		127 + 32767 == Int8.MAX + Int16.MAX;
		127 + 32767 == Int16.MAX + Int8.MAX;

		(Int8.MAX + Int16.MAX).isTypeInt();
		(Int16.MAX + Int8.MAX).isTypeInt();
	}

	function specSubtraction() {
		127 - 32767 == Int8.MAX - Int16.MAX;
		32767 - 127 == Int16.MAX - Int8.MAX;

		(Int8.MAX - Int16.MAX).isTypeInt();
		(Int16.MAX - Int8.MAX).isTypeInt();
	}

	function specMultiplication() {
		127 * 32767 == Int8.MAX * Int16.MAX;
		32767 * 127 == Int16.MAX * Int8.MAX;

		(Int8.MAX * Int16.MAX).isTypeInt();
		(Int16.MAX * Int8.MAX).isTypeInt();
	}

	function specDivision() {
		127 / 32767 == Int8.MAX / Int16.MAX;
		32767 / 127 == Int16.MAX / Int8.MAX;

		(Int8.MAX / Int16.MAX).isTypeFloat();
		(Int16.MAX / Int8.MAX).isTypeFloat();
	}

	function specModulo() {
		(-128) % 32767 == Int8.MIN % Int16.MAX;
		32767 % (-128) == Int16.MAX % Int8.MIN;

		(Int8.MAX % Int16.MAX).isTypeInt8();
		(Int16.MAX % Int8.MAX).isTypeInt16();
	}

	function specOr() {
		Numeric.parseBitsInt('0010 0011 1100 0011', 16) == Int8.parseBits('1000 0001') | Int16.parseBits('0010 0011 1100 0011');
		Numeric.parseBitsInt('1010 0011 1100 0011', 16) == Int16.parseBits('1010 0011 1100 0011') | Int8.parseBits('1000 0001');

		(Int8.MAX | Int16.MAX).isTypeInt();
		(Int16.MAX | Int8.MAX).isTypeInt();
	}

	function specAnd() {
		Numeric.parseBitsInt('0000 0000 1000 0001', 16) == Int8.parseBits('1000 0001') & Int16.parseBits('1010 0011 1100 0011');
		Numeric.parseBitsInt('0000 0000 1000 0001', 16) == Int16.parseBits('1010 0011 1100 0011') & Int8.parseBits('1000 0001');

		(Int8.MAX & Int16.MAX).isTypeInt();
		(Int16.MAX & Int8.MAX).isTypeInt();
	}

	function specXor() {
		Numeric.parseBitsInt('1010 0011 0100 0010', 16) == Int8.parseBits('1000 0001') ^ Int16.parseBits('1010 0011 1100 0011');
		Numeric.parseBitsInt('1010 0011 0100 0010', 16) == Int16.parseBits('1010 0011 1100 0011') ^ Int8.parseBits('1000 0001');

		(Int8.MAX ^ Int16.MAX).isTypeInt();
		(Int16.MAX ^ Int8.MAX).isTypeInt();
	}

	function specShiftLeft() {
		Int8.parseBits('0000 0100') == Int8.parseBits('1000 0001') << Int16.create(2);
		Int16.parseBits('0000 1111 0000 0100') == Int16.parseBits('1000 0011 1100 0001') << Int8.create(2);

		(Int8.MAX << Int16.MAX).isTypeInt8();
		(Int16.MAX << Int8.MAX).isTypeInt16();
	}

	function specShiftRight() {
		Int8.parseBits('1110 0000') == Int8.parseBits('1000 0001') >> Int16.create(2);
		Int16.parseBits('1110 0000 1111 0000') == Int16.parseBits('1000 0011 1100 0001') >> Int8.create(2);

		(Int8.MAX >> Int16.MAX).isTypeInt8();
		(Int16.MAX >> Int8.MAX).isTypeInt16();
	}

	function specUnsignedShiftRight() {
		Int8.parseBits('0010 0000') == Int8.parseBits('1000 0001') >>> Int16.create(2);
		Int16.parseBits('0010 0000 1111 0000') == Int16.parseBits('1000 0011 1100 0001') >>> Int8.create(2);

		(Int8.MAX >>> Int16.MAX).isTypeInt8();
		(Int16.MAX >>> Int8.MAX).isTypeInt16();
	}
}