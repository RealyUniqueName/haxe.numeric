package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;
import haxe.numeric.exceptions.OverflowException;

class Int16Spec extends TestBase {
	public function specMinMax() {
		32767 == Int16.MAX;
		-32768 == Int16.MIN;

		Int16.MAX.isTypeInt16();
		Int16.MIN.isTypeInt16();
	}

	public function specParseBits() {
		Int16.parseBits('0000 0000 0000 0000').isTypeInt16();

		Int16.create(0) == Int16.parseBits('0000 0000 0000 0000');
		Int16.create(3) == Int16.parseBits('0000 0000 0000 0011');
		Int16.MAX == Int16.parseBits('0111 1111 1111 1111');
		Int16.MIN == Int16.parseBits('1000 0000 0000 0000');
		Int16.create(-3) == Int16.parseBits('1111 1111 1111 1101');
		Int16.create(-1) == Int16.parseBits('1111 1111 1111 1111');

		Assert.raises(() -> Int16.parseBits('1234 5678 9012 3456'), InvalidArgumentException);
		Assert.raises(() -> Int16.parseBits('1111 1111 1111 111'), InvalidArgumentException);
	}

	public function specCreate() {
		Int16.create(-0x8000).isTypeInt16();

		Int16.create(-0x8000) == Int16.MIN;
		Int16.create(0x7FFF) == Int16.MAX;

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int16.create(0x7FFF + 1), OverflowException);
				Assert.raises(() -> Int16.create(-0x8000 - 1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int16.MIN == Int16.create(0x7FFF + 1);
				Int16.MAX == Int16.create(-0x8000 - 1);
			}
		);
	}

	public function specCreateBits() {
		Int16.createBits(0xFFFF).isTypeInt16();

		Int16.createBits(0x7FFF) == Int16.MAX;
		Int16.createBits(0xFFFF) == Int16.create(-1);
		Int16.createBits(0x8000) == Int16.MIN;

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int16.createBits(0x10000), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int8.create(-1) == Int8.createBits(0x1FFFF);
			}
		);
	}

	public function specToString() {
		'12345' == Int16.create(12345).toString();
		'32767' == Int16.MAX.toString();
		'-32768' == Int16.MIN.toString();
		'-1' == Int16.create(-1).toString();
		'null' == '' + (null:Null<Int16>);
	}

	public function specToInt() {
		32767 == Int16.MAX.toInt();
		-32768 == Int16.MIN.toInt();
		-1 == Int16.parseBits('1111 1111 1111 1111').toInt();
	}

	public function specNegative() {
		(-Int16.create(10)).isTypeInt16();

		-Int16.create(10) == Int16.create(-10);

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> -Int16.MIN, OverflowException);
			},
			function OVERFLOW_WRAP() {
				-Int16.MIN == Int16.MIN;
			}
		);
	}

	public function specPrefixIncrement() {
		var i16 = Int16.create(0);
		++i16 == Int16.create(1);
		i16 == Int16.create(1);

		(++i16).isTypeInt16();

		overflow(
			function OVERFLOW_THROW() {
				var i16 = Int16.MAX;
				try {
					++i16;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int16.MAX, i16);
				}
			},
			function OVERFLOW_WRAP() {
				var i16 = Int16.MAX;
				++i16;
				i16 == Int16.MIN;
			}
		);
	}

	public function specPostfixIncrement() {
		var i16 = Int16.create(0);
		i16++ == Int16.create(0);
		i16 == Int16.create(1);

		(i16++).isTypeInt16();

		overflow(
			function OVERFLOW_THROW() {
				var i16 = Int16.MAX;
				try {
					i16++;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int16.MAX, i16);
				}
			},
			function OVERFLOW_WRAP() {
				var i16 = Int16.MAX;
				i16++;
				i16 == Int16.MIN;
			}
		);
	}

	public function specPrefixDecrement() {
		var i16 = Int16.create(0);
		--i16 == Int16.create(-1);
		i16 == Int16.create(-1);

		(--i16).isTypeInt16();

		overflow(
			function OVERFLOW_THROW() {
				var i16 = Int16.MIN;
				try {
					--i16;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int16.MIN, i16);
				}
			},
			function OVERFLOW_WRAP() {
				var i16 = Int16.MIN;
				--i16;
				i16 == Int16.MAX;
			}
		);
	}

	public function specPostfixDecrement() {
		var i16 = Int16.create(0);
		i16-- == Int16.create(0);
		i16 == Int16.create(-1);

		(i16--).isTypeInt16();

		overflow(
			function OVERFLOW_THROW() {
				var i16 = Int16.MIN;
				try {
					i16--;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int16.MIN, i16);
				}
			},
			function OVERFLOW_WRAP() {
				var i16 = Int16.MIN;
				i16--;
				i16 == Int16.MAX;
			}
		);
	}

	public function specAddition() {
		Int16.create(-1) == Int16.MAX + Int16.MIN;

		32768 == Int16.MAX + 1;
		-32769 == -1 + Int16.MIN;
		32768.0 == Int16.MAX + 1.0;
		-32769.0 == -1.0 + Int16.MIN;

		(Int16.create(0) + Int16.create(0)).isTypeInt16();
		(Int16.create(0) + 1).isTypeInt();
		(1 + Int16.create(0)).isTypeInt();
		(Int16.create(0) + 1.0).isTypeFloat();
		(1.0 + Int16.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int16.MAX + Int16.create(1), OverflowException);
				Assert.raises(() -> Int16.MIN + Int16.create(-1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int16.MAX + Int16.create(1) == Int16.MIN;
				Int16.MIN + Int16.create(-1) == Int16.MAX;
			}
		);
	}

	public function specSubtraction() {
		Int16.create(0) == Int16.MAX - Int16.MAX;
		Int16.create(0) == Int16.MIN - Int16.MIN;

		32768 == Int16.MAX - (-1);
		32769 == 1 - Int16.MIN;
		32768.0 == Int16.MAX - (-1.0);
		32769.0 == 1.0 - Int16.MIN;

		(Int16.create(0) - Int16.create(0)).isTypeInt16();
		(Int16.create(0) - 1).isTypeInt();
		(1 - Int16.create(0)).isTypeInt();
		(Int16.create(0) - 1.0).isTypeFloat();
		(1.0 - Int16.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int16.MAX - Int16.create(-1), OverflowException);
				Assert.raises(() -> Int16.MIN - Int16.create(1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int16.MAX - Int16.create(-1) == Int16.MIN;
				Int16.MIN - Int16.create(1) == Int16.MAX;
			}
		);
	}

	public function specMultiplication() {
		Int16.create(50) == Int16.create(5) * Int16.create(10);
		Int16.create(-50) == Int16.create(5) * Int16.create(-10);

		65534 == Int16.MAX * 2;
		-65536 == 2 * Int16.MIN;
		65534 == Int16.MAX * 2.0;
		-65536.0 == 2.0 * Int16.MIN;

		(Int16.create(0) * Int16.create(0)).isTypeInt16();
		(Int16.create(0) * 1).isTypeInt();
		(1 * Int16.create(0)).isTypeInt();
		(Int16.create(0) * 1.0).isTypeFloat();
		(1.0 * Int16.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int16.MAX * Int16.create(2), OverflowException);
				Assert.raises(() -> Int16.MIN * Int16.create(2), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int16.parseBits('0111 1111 1111 1111') * Int16.create(2) == Int16.parseBits('1111 1111 1111 1110');
				Int16.parseBits('1000 0000 0000 0000') * Int16.create(2) == Int16.parseBits('0000 0000 0000 0000');
			}
		);
	}

	public function specDivision() {
		7 == Int16.create(14) / 2;
		7 == 14 / Int16.create(2);
		7 == Int16.create(14) / 2.0;
		7 == 14.0 / Int16.create(2);

		(Int16.create(0) / Int16.create(1)).isTypeFloat();
		(Int16.create(0) / 1).isTypeFloat();
		(1 / Int16.create(1)).isTypeFloat();
		(Int16.create(0) / 1.0).isTypeFloat();
		(1.0 / Int16.create(1)).isTypeFloat();
	}

	public function specModulo() {
		Int16.create(7) == Int16.MAX % Int16.create(8);
		Int16.create(-8) == Int16.MIN % Int16.create(63);
		Int16.create(7) == Int16.MAX % Int16.create(-8);

		Int16.create(7) == Int16.MAX % 8;
		Int16.create(-1) == Int16.MIN % 7;
		Int16.create(7) == Int16.MAX % -8;
		Int16.create(1) == 100 % Int16.create(9);
		Int16.create(1) == 100 % Int16.create(-9);
		Int16.create(-1) == -100 % Int16.create(-9);

		54.25 == Int16.MAX % 117.25;
		-55.25 == Int16.MIN % 117.25;
		-55.25 == Int16.MIN % (-117.25);
		0.5 == 6.5 % Int16.create(3);
		-0.5 == -6.5 % Int16.create(3);
		-0.5 == -6.5 % Int16.create(-3);

		(Int16.create(0) % Int16.create(0)).isTypeInt16();
		(Int16.create(0) % 1).isTypeInt16();
		(1 % Int16.create(0)).isTypeInt16();
		(Int16.create(0) % 1.0).isTypeFloat();
		(1.0 % Int16.create(0)).isTypeFloat();
	}

	public function specEqual() {
		Int16.create(10) == Int16.create(10);
		10 == Int16.create(10);
		Int16.create(10) == 10;
		10.0 == Int16.create(10);
		Int16.create(10) == 10.0;
	}

	public function specNotEqual() {
		Int16.create(10) != Int16.create(9);
		11 != Int16.create(10);
		Int16.create(10) != 11;
		10.5 != Int16.create(10);
		Int16.create(10) != 10.5;
	}

	public function specGreater() {
		Int16.create(10) > Int16.create(9);
		11 > Int16.create(10);
		Int16.create(11) > 10;
		10.5 > Int16.create(10);
		Int16.create(10) > 9.5;
	}

	public function specGreaterOrEqual() {
		Int16.create(10) >= Int16.create(9);
		11 >= Int16.create(10);
		Int16.create(11) >= 10;
		10.5 >= Int16.create(10);
		Int16.create(10) >= 9.5;
	}

	public function specLess() {
		Int16.create(9) < Int16.create(10);
		10 < Int16.create(11);
		Int16.create(10) < 11;
		9.5 < Int16.create(10);
		Int16.create(10) < 10.5;
	}

	public function specLessOrEqual() {
		Int16.create(9) <= Int16.create(10);
		10 <= Int16.create(11);
		Int16.create(10) <= 11;
		9.5 <= Int16.create(10);
		Int16.create(10) <= 10.5;
	}

	public function specNegate() {
		~Int16.parseBits('0000 0000 0000 0000') == Int16.parseBits('1111 1111 1111 1111');
		~Int16.parseBits('0000 0000 0000 0010') == Int16.parseBits('1111 1111 1111 1101');
		~Int16.parseBits('1100 0000 0000 0100') == Int16.parseBits('0011 1111 1111 1011');

		(~Int16.MAX).isTypeInt16();
	}

	public function specAnd() {
		Int16.parseBits('0000 0000 0000 0000') & Int16.parseBits('1111 1111 1111 1111') == Int16.parseBits('0000 0000 0000 0000');
		Int16.parseBits('1110 0000 1111 0111') & Int16.parseBits('0101 0011 1100 1010') == Int16.parseBits('0100 0000 1100 0010');
		Int16.parseBits('1110 0000 1111 0111') & Int16.parseBits('1101 0011 1100 1010') == Int16.parseBits('1100 0000 1100 0010');

		-1 & Int16.create(-1) == Numeric.parseBitsInt('1111 1111 1111 1111', 16);
		Int16.create(-1) & 0 == 0;
		Int16.parseBits('1111 1111 1111 1111') & -1 == Numeric.parseBitsInt('1111 1111 1111 1111', 16);

		(Int16.MAX & Int16.MAX).isTypeInt16();
		(Int16.MAX & 1).isTypeInt();
		(1 & Int16.MAX).isTypeInt();
	}

	public function specOr() {
		Int16.parseBits('0000 0000 0000 0000') | Int16.parseBits('1111 1111 1111 1111') == Int16.parseBits('1111 1111 1111 1111');
		Int16.parseBits('1010 1111 0000 0101') | Int16.parseBits('0100 0011 1100 0010') == Int16.parseBits('1110 1111 1100 0111');

		-1 | Int16.create(0) == -1;
		Int16.create(0) | -1 == -1;
		0 | Int16.parseBits('1000 0000 0000 0000') == 1 << 15;
		Int16.parseBits('1000 0000 0000 0000') | 0 == 1 << 15;

		(Int16.MAX | Int16.MAX).isTypeInt16();
		(Int16.MAX | 1).isTypeInt();
		(1 | Int16.MAX).isTypeInt();
	}

	public function specXor() {
		Int16.parseBits('0000 0000 0000 0000') ^ Int16.parseBits('1111 1111 1111 1111') == Int16.parseBits('1111 1111 1111 1111');
		Int16.parseBits('1010 1111 0000 0101') ^ Int16.parseBits('1100 0011 1100 0011') == Int16.parseBits('0110 1100 1100 0110');

		-1 ^ Int16.parseBits('1111 1111 1111 1111') == -1 ^ Numeric.parseBitsInt('1111 1111 1111 1111', 16);
		Int16.parseBits('1111 1111 1111 1111') ^ -1 == -1 ^ Numeric.parseBitsInt('1111 1111 1111 1111', 16);
		0 ^ Int16.parseBits('1111 1111 1111 1111') == Numeric.parseBitsInt('1111 1111 1111 1111', 16);
		Int16.parseBits('1111 1111 1111 1111') ^ 0 == Numeric.parseBitsInt('1111 1111 1111 1111', 16);

		(Int16.MAX ^ Int16.MAX).isTypeInt16();
		(Int16.MAX ^ 1).isTypeInt();
		(1 ^ Int16.MAX).isTypeInt();
	}

	public function specShiftLeft() {
		Int16.parseBits('0000 1111 0000 0001') << 2 == Int16.parseBits('0011 1100 0000 0100');
		Int16.parseBits('0100 1111 0000 0001') << 1 == Int16.parseBits('1001 1110 0000 0010');
		Int16.parseBits('1000 1111 0000 0001') << 1 == Int16.parseBits('0001 1110 0000 0010');

		Int16.parseBits('0000 1111 0000 0001') << Int16.create(2) == Int16.parseBits('0011 1100 0000 0100');
		Int16.parseBits('1100 1111 0000 0001') << Int16.create(-1) == Int16.parseBits('1000 0000 0000 0000');
		Int16.parseBits('1100 1111 0000 0001') << Int16.parseBits('1000 0000 0000 0001') == Int16.parseBits('1001 1110 0000 0010');

		Int16.parseBits('1100 1111 0000 0001') << -1 == Int16.parseBits('1000 0000 0000 0000');
		Int16.parseBits('1100 1111 0000 0010') << -1 == Int16.parseBits('0000 0000 0000 0000');
		Int16.parseBits('1100 1111 0000 0001') << Int16.create(-1) == Int16.parseBits('1000 0000 0000 0000');
		Int16.parseBits('1100 1111 0000 0010') << Int16.create(-1) == Int16.parseBits('0000 0000 0000 0000');

		1 << Int16.create(2) == 1 << 2;
		4 << Int16.create(1) == 4 << 1;

		(Int16.MAX << Int16.MAX).isTypeInt16();
		(Int16.MAX << 1).isTypeInt16();
		(1 << Int16.MAX).isTypeInt();
	}

	public function specShiftRight() {
		Int16.parseBits('1000 1111 0000 0010') >> 1 == Int16.parseBits('1100 0111 1000 0001');
		Int16.parseBits('1000 1111 0000 0010') >> 2 == Int16.parseBits('1110 0011 1100 0000');
		Int16.parseBits('0100 1111 0000 0010') >> 2 == Int16.parseBits('0001 0011 1100 0000');

		Int16.parseBits('1000 1111 0000 0010') >> Int16.create(1) == Int16.parseBits('1100 0111 1000 0001');
		Int16.parseBits('1000 1111 0000 0010') >> Int16.create(2) == Int16.parseBits('1110 0011 1100 0000');
		Int16.parseBits('0100 1111 0000 0010') >> Int16.create(2) == Int16.parseBits('0001 0011 1100 0000');

		Int16.parseBits('1101 1111 0000 0101') >> -1 == Int16.parseBits('1111 1111 1111 1111');
		Int16.parseBits('0101 1111 0000 0101') >> -1 == Int16.parseBits('0000 0000 0000 0000');

		-2 >> Int16.create(10) == -2 >> 10;
		35001 >> Int16.create(10) == 35001 >> 10;

		(Int16.MAX >> Int16.MAX).isTypeInt16();
		(Int16.MAX >> 1).isTypeInt16();
		(1 >> Int16.MAX).isTypeInt();
	}

	public function specUnsignedShiftRight() {
		Int16.parseBits('1000 1111 0000 0010') >>> 1 == Int16.parseBits('0100 0111 1000 0001');
		Int16.parseBits('1000 1111 0000 0010') >>> 2 == Int16.parseBits('0010 0011 1100 0000');
		Int16.parseBits('0100 1111 0000 0010') >>> 2 == Int16.parseBits('0001 0011 1100 0000');

		Int16.parseBits('1000 1111 0000 0010') >>> Int16.create(1) == Int16.parseBits('0100 0111 1000 0001');
		Int16.parseBits('1000 1111 0000 0010') >>> Int16.create(2) == Int16.parseBits('0010 0011 1100 0000');
		Int16.parseBits('0100 1111 0000 0010') >>> Int16.create(2) == Int16.parseBits('0001 0011 1100 0000');

		Int16.parseBits('1101 1111 0000 0101') >>> -1 == Int16.parseBits('0000 0000 0000 0001');
		Int16.parseBits('0101 1111 0000 0101') >>> -1 == Int16.parseBits('0000 0000 0000 0000');

		-2 >>> Int16.create(10) == -2 >>> 10;
		32001 >>> Int16.create(10) == 32001 >>> 10;

		(Int16.MAX >>> Int16.MAX).isTypeInt16();
		(Int16.MAX >>> 1).isTypeInt16();
		(1 >>> Int16.MAX).isTypeInt();
	}

}