package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;
import haxe.numeric.exceptions.OverflowException;

class Int8Test extends utest.Test {
	public function specMinMax() {
		127 == Int8.MAX;
		-128 == Int8.MIN;

		Int8.MAX.isTypeInt8();
		Int8.MIN.isTypeInt8();
	}

	public function specParseBits() {
		Int8.parseBits('0000 0000').isTypeInt8();

		Int8.create(0) == Int8.parseBits('0000 0000');
		Int8.create(3) == Int8.parseBits('0000 0011');
		Int8.MAX == Int8.parseBits('0111 1111');
		Int8.MIN == Int8.parseBits('1000 0000');
		Int8.create(-3) == Int8.parseBits('1111 1101');
		Int8.create(-1) == Int8.parseBits('1111 1111');

		Assert.raises(() -> Int8.parseBits('1234 5678'), InvalidArgumentException);
		Assert.raises(() -> Int8.parseBits('1111 11111'), InvalidArgumentException);
	}

	public function specCreate() {
		Int8.create(-0x80).isTypeInt8();

		Int8.create(-0x80) == Int8.MIN;
		Int8.create(0x7F) == Int8.MAX;
		Assert.raises(() -> Int8.create(0x7F + 1), OverflowException);
		Assert.raises(() -> Int8.create(-0x80 - 1), OverflowException);
	}

	public function specToString() {
		'123' == Int8.create(123).toString();
		'127' == Int8.MAX.toString();
		'-128' == Int8.MIN.toString();
		'-1' == Int8.create(-1).toString();
		'null' == (null:Null<Int8>).toString();
	}

	public function specToInt() {
		127 == (Int8.MAX:Int);
		-128 == (Int8.MIN:Int);
		-1 == (Int8.parseBits('1111 1111'):Int);
	}

	public function specNegative() {
		(-Int8.create(10)).isTypeInt8();

		-Int8.create(10) == Int8.create(-10);
	}

	public function specPrefixIncrement() {
		var i8 = Int8.create(0);
		++i8 == Int8.create(1);
		i8 == Int8.create(1);

		(++i8).isTypeInt8();

		var i8 = Int8.create(0);
		var result = ++i8;
		i8 == Int8.create(1);
		result == Int8.create(1);

		var i8 = Int8.MAX;
		try {
			++i8;
			Assert.fail();
		} catch(e:OverflowException) {
			Assert.equals(Int8.MAX, i8);
		}
	}

	public function specPostfixIncrement() {
		var i8 = Int8.create(0);
		i8++ == Int8.create(0);
		i8 == Int8.create(1);

		(i8++).isTypeInt8();

		var i8 = Int8.create(0);
		var result:Int8 = i8++;
		i8 == Int8.create(1);
		result == Int8.create(0);

		var i8 = Int8.MAX;
		try {
			i8++;
			Assert.fail();
		} catch(e:OverflowException) {
			Assert.equals(Int8.MAX, i8);
		}
	}

	public function specPrefixDecrement() {
		var i8 = Int8.create(0);
		--i8 == Int8.create(-1);
		i8 == Int8.create(-1);

		(--i8).isTypeInt8();

		var i8 = Int8.create(0);
		var result:Int8 = --i8;
		i8 == Int8.create(-1);
		result == Int8.create(-1);

		var i8 = Int8.MIN;
		try {
			--i8;
			Assert.fail();
		} catch(e:OverflowException) {
			Assert.equals(Int8.MIN, i8);
		}
	}

	public function specPostfixDecrement() {
		var i8 = Int8.create(0);
		i8-- == Int8.create(0);
		i8 == Int8.create(-1);

		(i8--).isTypeInt8();

		var i8 = Int8.create(0);
		var result:Int8 = i8--;
		i8 == Int8.create(-1);
		result == Int8.create(0);

		var i8 = Int8.MIN;
		try {
			i8--;
			Assert.fail();
		} catch(e:OverflowException) {
			Assert.equals(Int8.MIN, i8);
		}
	}

	public function specAddition() {
		Int8.create(-1) == Int8.MAX + Int8.MIN;
		Assert.raises(() -> Int8.MAX + Int8.create(1), OverflowException);
		Assert.raises(() -> Int8.MIN + Int8.create(-1), OverflowException);

		128 == Int8.MAX + 1;
		-129 == -1 + Int8.MIN;
		128.0 == Int8.MAX + 1.0;
		-129.0 == -1.0 + Int8.MIN;

		(Int8.create(0) + Int8.create(0)).isTypeInt8();
		(Int8.create(0) + 1).isTypeInt();
		(1 + Int8.create(0)).isTypeInt();
		(Int8.create(0) + 1.0).isTypeFloat();
		(1.0 + Int8.create(0)).isTypeFloat();
	}

	public function specSubtraction() {
		Int8.create(0) == Int8.MAX - Int8.MAX;
		Int8.create(0) == Int8.MIN - Int8.MIN;
		Assert.raises(() -> Int8.MAX - Int8.create(-1), OverflowException);
		Assert.raises(() -> Int8.MIN - Int8.create(1), OverflowException);

		128 == Int8.MAX - (-1);
		129 == 1 - Int8.MIN;
		128.0 == Int8.MAX - (-1.0);
		129.0 == 1.0 - Int8.MIN;

		(Int8.create(0) - Int8.create(0)).isTypeInt8();
		(Int8.create(0) - 1).isTypeInt();
		(1 - Int8.create(0)).isTypeInt();
		(Int8.create(0) - 1.0).isTypeFloat();
		(1.0 - Int8.create(0)).isTypeFloat();
	}

	public function specMultiplication() {
		Int8.create(50) == Int8.create(5) * Int8.create(10);
		Int8.create(-50) == Int8.create(5) * Int8.create(-10);
		Assert.raises(() -> Int8.MAX * Int8.create(2), OverflowException);
		Assert.raises(() -> Int8.MIN * Int8.create(2), OverflowException);

		254 == Int8.MAX * 2;
		-256 == 2 * Int8.MIN;
		254.0 == Int8.MAX * 2.0;
		-256.0 == 2.0 * Int8.MIN;

		(Int8.create(0) * Int8.create(0)).isTypeInt8();
		(Int8.create(0) * 1).isTypeInt();
		(1 * Int8.create(0)).isTypeInt();
		(Int8.create(0) * 1.0).isTypeFloat();
		(1.0 * Int8.create(0)).isTypeFloat();
	}

	public function specDivision() {
		7 == Int8.create(14) / 2;
		7 == 14 / Int8.create(2);
		7 == Int8.create(14) / 2.0;
		7 == 14.0 / Int8.create(2);

		(Int8.create(0) / Int8.create(1)).isTypeFloat();
		(Int8.create(0) / 1).isTypeFloat();
		(1 / Int8.create(1)).isTypeFloat();
		(Int8.create(0) / 1.0).isTypeFloat();
		(1.0 / Int8.create(1)).isTypeFloat();
	}

	public function specModulo() {
		Int8.create(7) == Int8.MAX % Int8.create(8);
		Int8.create(-2) == Int8.MIN % Int8.create(63);
		Int8.create(7) == Int8.MAX % Int8.create(-8);

		Int8.create(7) == Int8.MAX % 8;
		Int8.create(-2) == Int8.MIN % 7;
		Int8.create(7) == Int8.MAX % -8;
		Int8.create(1) == 100 % Int8.create(9);
		Int8.create(1) == 100 % Int8.create(-9);
		Int8.create(-1) == -100 % Int8.create(-9);

		9.75 == Int8.MAX % 117.25;
		-10.75 == Int8.MIN % 117.25;
		-10.75 == Int8.MIN % (-117.25);
		0.5 == 6.5 % Int8.create(3);
		-0.5 == -6.5 % Int8.create(3);
		-0.5 == -6.5 % Int8.create(-3);

		(Int8.create(0) % Int8.create(0)).isTypeInt8();
		(Int8.create(0) % 1).isTypeInt8();
		(1 % Int8.create(0)).isTypeInt8();
		(Int8.create(0) % 1.0).isTypeFloat();
		(1.0 % Int8.create(0)).isTypeFloat();
	}

	public function specEqual() {
		Int8.create(10) == Int8.create(10);
		10 == Int8.create(10);
		Int8.create(10) == 10;
		10.0 == Int8.create(10);
		Int8.create(10) == 10.0;
	}

	public function specNotEqual() {
		Int8.create(10) != Int8.create(9);
		11 != Int8.create(10);
		Int8.create(10) != 11;
		10.5 != Int8.create(10);
		Int8.create(10) != 10.5;
	}

	public function specGreater() {
		Int8.create(10) > Int8.create(9);
		11 > Int8.create(10);
		Int8.create(11) > 10;
		10.5 > Int8.create(10);
		Int8.create(10) > 9.5;
	}

	public function specGreaterOrEqual() {
		Int8.create(10) >= Int8.create(9);
		11 >= Int8.create(10);
		Int8.create(11) >= 10;
		10.5 >= Int8.create(10);
		Int8.create(10) >= 9.5;
	}

	public function specLess() {
		Int8.create(9) < Int8.create(10);
		10 < Int8.create(11);
		Int8.create(10) < 11;
		9.5 < Int8.create(10);
		Int8.create(10) < 10.5;
	}

	public function specLessOrEqual() {
		Int8.create(9) <= Int8.create(10);
		10 <= Int8.create(11);
		Int8.create(10) <= 11;
		9.5 <= Int8.create(10);
		Int8.create(10) <= 10.5;
	}

	public function specNegate() {
		~Int8.parseBits('0000 0000') == Int8.parseBits('1111 1111');
		~Int8.parseBits('0000 0010') == Int8.parseBits('1111 1101');
		~Int8.parseBits('1100 0100') == Int8.parseBits('0011 1011');

		(~Int8.MAX).isTypeInt8();
	}

	public function specAnd() {
		Int8.parseBits('0000 0000') & Int8.parseBits('1111 1111') == Int8.parseBits('0000 0000');
		Int8.parseBits('1110 0111') & Int8.parseBits('0101 1010') == Int8.parseBits('0100 0010');
		Int8.parseBits('1110 0111') & Int8.parseBits('1101 1010') == Int8.parseBits('1100 0010');

		-1 & Int8.create(-1) == -1;
		Int8.create(-1) & 0 == 0;

		(Int8.MAX & Int8.MAX).isTypeInt8();
		(Int8.MAX & 1).isTypeInt();
		(1 & Int8.MAX).isTypeInt();
	}

	public function specOr() {
		Int8.parseBits('0000 0000') | Int8.parseBits('1111 1111') == Int8.parseBits('1111 1111');
		Int8.parseBits('1010 0101') | Int8.parseBits('0100 0010') == Int8.parseBits('1110 0111');

		-1 | Int8.create(0) == -1;
		Int8.create(0) | -1 == -1;

		(Int8.MAX | Int8.MAX).isTypeInt8();
		(Int8.MAX | 1).isTypeInt();
		(1 | Int8.MAX).isTypeInt();
	}

	public function specXor() {
		Int8.parseBits('0000 0000') ^ Int8.parseBits('1111 1111') == Int8.parseBits('1111 1111');
		Int8.parseBits('1010 0101') ^ Int8.parseBits('1100 0011') == Int8.parseBits('0110 0110');

		-1 ^ Int8.create(-1) == 0;
		Int8.create(-1) ^ -1 == 0;

		(Int8.MAX ^ Int8.MAX).isTypeInt8();
		(Int8.MAX ^ 1).isTypeInt();
		(1 ^ Int8.MAX).isTypeInt();
	}

	public function specShiftLeft() {
		Int8.parseBits('0000 0001') << 2 == Int8.parseBits('0000 0100');
		Int8.parseBits('0100 0001') << 1 == Int8.parseBits('1000 0010');
		Int8.parseBits('1000 0001') << 1 == Int8.parseBits('0000 0010');

		Int8.parseBits('0000 0001') << Int8.create(2) == Int8.parseBits('0000 0100');

		Int8.parseBits('1100 0001') << -1 == Int8.parseBits('1000 0000');
		Int8.parseBits('1100 0010') << -1 == Int8.parseBits('0000 0000');
		Int8.parseBits('1100 0001') << Int8.create(-1) == Int8.parseBits('1000 0000');
		Int8.parseBits('1100 0010') << Int8.create(-1) == Int8.parseBits('0000 0000');

		1 << Int8.create(2) == 1 << 2;
		4 << Int8.create(1) == 4 << 1;

		(Int8.MAX << Int8.MAX).isTypeInt8();
		(Int8.MAX << 1).isTypeInt8();
		(1 << Int8.MAX).isTypeInt();
	}

	public function specShiftRight() {
		Int8.parseBits('1000 0010') >> 1 == Int8.parseBits('1100 0001');
		Int8.parseBits('1000 0010') >> 2 == Int8.parseBits('1110 0000');
		Int8.parseBits('0100 0010') >> 2 == Int8.parseBits('0001 0000');

		Int8.parseBits('1000 0010') >> Int8.create(1) == Int8.parseBits('1100 0001');
		Int8.parseBits('1000 0010') >> Int8.create(2) == Int8.parseBits('1110 0000');
		Int8.parseBits('0100 0010') >> Int8.create(2) == Int8.parseBits('0001 0000');

		Int8.parseBits('1101 0101') >> -1 == Int8.parseBits('1111 1111');
		Int8.parseBits('0101 0101') >> -1 == Int8.parseBits('0000 0000');

		-2 >> Int8.create(10) == -2 >> 10;
		32001 >> Int8.create(10) == 32001 >> 10;

		(Int8.MAX >> Int8.MAX).isTypeInt8();
		(Int8.MAX >> 1).isTypeInt8();
		(1 >> Int8.MAX).isTypeInt();
	}

	public function specUnsignedShiftRight() {
		Int8.parseBits('1000 0010') >>> 1 == Int8.parseBits('0100 0001');
		Int8.parseBits('1000 0010') >>> 2 == Int8.parseBits('0010 0000');
		Int8.parseBits('0100 0010') >>> 2 == Int8.parseBits('0001 0000');

		Int8.parseBits('1000 0010') >>> Int8.create(1) == Int8.parseBits('0100 0001');
		Int8.parseBits('1000 0010') >>> Int8.create(2) == Int8.parseBits('0010 0000');
		Int8.parseBits('0100 0010') >>> Int8.create(2) == Int8.parseBits('0001 0000');

		Int8.parseBits('1101 0101') >>> -1 == Int8.parseBits('0000 0001');
		Int8.parseBits('0101 0101') >>> -1 == Int8.parseBits('0000 0000');

		-2 >>> Int8.create(10) == -2 >>> 10;
		32001 >>> Int8.create(10) == 32001 >>> 10;

		(Int8.MAX >>> Int8.MAX).isTypeInt8();
		(Int8.MAX >>> 1).isTypeInt8();
		(1 >>> Int8.MAX).isTypeInt();
	}

}