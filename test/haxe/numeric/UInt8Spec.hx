package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;
import haxe.numeric.exceptions.OverflowException;

class UInt8Spec extends TestBase {
	public function specMinMax() {
		255 == UInt8.MAX;
		0 == UInt8.MIN;

		UInt8.MAX.isTypeUInt8();
		UInt8.MIN.isTypeUInt8();
	}

	public function specParseBits() {
		UInt8.parseBits('0000 0000').isTypeUInt8();

		UInt8.MAX == UInt8.parseBits('1111 1111');
		UInt8.MIN == UInt8.parseBits('0000 0000');
		UInt8.create(0) == UInt8.parseBits('0000 0000');
		UInt8.create(3) == UInt8.parseBits('0000 0011');
		UInt8.create(253) == UInt8.parseBits('1111 1101');

		Assert.raises(() -> UInt8.parseBits('1234 5678'), InvalidArgumentException);
		Assert.raises(() -> UInt8.parseBits('1111 11111'), InvalidArgumentException);
	}

	public function specCreate() {
		UInt8.create(0x80).isTypeUInt8();

		UInt8.create(0) == UInt8.MIN;
		UInt8.create(0xFF) == UInt8.MAX;

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt8.create(256), OverflowException);
				Assert.raises(() -> UInt8.create(-1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt8.MIN == UInt8.create(256);
				UInt8.MAX == UInt8.create(-1);
			}
		);
	}

	public function specToString() {
		'210' == UInt8.create(210).toString();
		'255' == UInt8.MAX.toString();
		'0' == UInt8.MIN.toString();
	}

	public function specToInt() {
		255 == UInt8.MAX.toInt();
		0 == UInt8.MIN.toInt();
	}

	public function specNegative() {
		(-UInt8.create(10)).isTypeInt();

		-UInt8.create(10) == -10;
	}

	public function specPrefixIncrement() {
		var i8 = UInt8.create(0);
		++i8 == UInt8.create(1);
		i8 == UInt8.create(1);

		(++i8).isTypeUInt8();

		overflow(
			function OVERFLOW_THROW() {
				var i8 = UInt8.MAX;
				try {
					++i8;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt8.MAX, i8);
				}
			},
			function OVERFLOW_WRAP() {
				var i8 = UInt8.MAX;
				++i8;
				i8 == UInt8.MIN;
			}
		);
	}

	public function specPostfixIncrement() {
		var i8 = UInt8.create(0);
		i8++ == UInt8.create(0);
		i8 == UInt8.create(1);

		(i8++).isTypeUInt8();

		overflow(
			function OVERFLOW_THROW() {
				var i8 = UInt8.MAX;
				try {
					i8++;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt8.MAX, i8);
				}
			},
			function OVERFLOW_WRAP() {
				var i8 = UInt8.MAX;
				i8++;
				i8 == UInt8.MIN;
			}
		);
	}

	public function specPrefixDecrement() {
		var i8 = UInt8.create(10);
		--i8 == UInt8.create(9);
		i8 == UInt8.create(9);

		(--i8).isTypeUInt8();

		overflow(
			function OVERFLOW_THROW() {
				var i8 = UInt8.MIN;
				try {
					--i8;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt8.MIN, i8);
				}
			},
			function OVERFLOW_WRAP() {
				var i8 = UInt8.MIN;
				--i8;
				i8 == UInt8.MAX;
			}
		);
	}

	public function specPostfixDecrement() {
		var i8 = UInt8.create(10);
		i8-- == UInt8.create(10);
		i8 == UInt8.create(9);

		(i8--).isTypeUInt8();

		overflow(
			function OVERFLOW_THROW() {
				var i8 = UInt8.MIN;
				try {
					i8--;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt8.MIN, i8);
				}
			},
			function OVERFLOW_WRAP() {
				var i8 = UInt8.MIN;
				i8--;
				i8 == UInt8.MAX;
			}
		);
	}

	public function specAddition() {
		256 == UInt8.MAX + 1;
		-1 == -1 + UInt8.MIN;
		256.0 == UInt8.MAX + 1.0;
		-1.0 == -1.0 + UInt8.MIN;
		UInt8.create(251) == UInt8.create(250) + UInt8.create(1);

		(UInt8.create(0) + UInt8.create(0)).isTypeUInt8();
		(UInt8.create(0) + 1).isTypeInt();
		(1 + UInt8.create(0)).isTypeInt();
		(UInt8.create(0) + 1.0).isTypeFloat();
		(1.0 + UInt8.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt8.MAX + UInt8.create(1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt8.MAX + UInt8.create(1) == UInt8.MIN;
			}
		);
	}

	public function specSubtraction() {
		UInt8.create(0) == UInt8.MAX - UInt8.MAX;
		UInt8.create(0) == UInt8.MIN - UInt8.MIN;

		256 == UInt8.MAX - (-1);
		-1 == -1 - UInt8.MIN;
		256.0 == UInt8.MAX - (-1.0);
		-1.0 == -1.0 - UInt8.MIN;

		(UInt8.create(0) - UInt8.create(0)).isTypeUInt8();
		(UInt8.create(0) - 1).isTypeInt();
		(1 - UInt8.create(0)).isTypeInt();
		(UInt8.create(0) - 1.0).isTypeFloat();
		(1.0 - UInt8.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt8.MAX - UInt8.create(-1), OverflowException);
				Assert.raises(() -> UInt8.MIN - UInt8.create(1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt8.MAX - UInt8.create(-1) == UInt8.MIN;
				UInt8.MIN - UInt8.create(1) == UInt8.MAX;
			}
		);
	}

	public function specMultiplication() {
		UInt8.create(50) == UInt8.create(5) * UInt8.create(10);

		510 == UInt8.MAX * 2;
		510.0 == UInt8.MAX * 2.0;

		(UInt8.create(0) * UInt8.create(0)).isTypeUInt8();
		(UInt8.create(0) * 1).isTypeInt();
		(1 * UInt8.create(0)).isTypeInt();
		(UInt8.create(0) * 1.0).isTypeFloat();
		(1.0 * UInt8.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt8.MAX * UInt8.create(2), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt8.parseBits('0111 1111') * UInt8.create(2) == UInt8.parseBits('1111 1110');
				UInt8.parseBits('1000 0000') * UInt8.create(2) == UInt8.parseBits('0000 0000');
			}
		);
	}

	public function specDivision() {
		7 == UInt8.create(14) / 2;
		7 == 14 / UInt8.create(2);
		7 == UInt8.create(14) / 2.0;
		7 == 14.0 / UInt8.create(2);

		(UInt8.create(0) / UInt8.create(1)).isTypeFloat();
		(UInt8.create(0) / 1).isTypeFloat();
		(1 / UInt8.create(1)).isTypeFloat();
		(UInt8.create(0) / 1.0).isTypeFloat();
		(1.0 / UInt8.create(1)).isTypeFloat();
	}

	public function specModulo() {
		UInt8.create(7) == UInt8.MAX % UInt8.create(8);

		UInt8.create(7) == UInt8.MAX % 8;
		UInt8.create(7) == UInt8.MAX % -8;
		1 == 100 % UInt8.create(9);

		20.5 == UInt8.MAX % 117.25;
		0.5 == 6.5 % UInt8.create(3);
		-0.5 == -6.5 % UInt8.create(3);

		(UInt8.create(0) % UInt8.create(0)).isTypeUInt8();
		(UInt8.create(0) % 1).isTypeUInt8();
		(1 % UInt8.create(0)).isTypeUInt8();
		(UInt8.create(0) % 1.0).isTypeFloat();
		(1.0 % UInt8.create(0)).isTypeFloat();
	}

	public function specEqual() {
		UInt8.create(10) == UInt8.create(10);
		10 == UInt8.create(10);
		UInt8.create(10) == 10;
		10.0 == UInt8.create(10);
		UInt8.create(10) == 10.0;
	}

	public function specNotEqual() {
		UInt8.create(10) != UInt8.create(9);
		11 != UInt8.create(10);
		UInt8.create(10) != 11;
		10.5 != UInt8.create(10);
		UInt8.create(10) != 10.5;
	}

	public function specGreater() {
		UInt8.create(10) > UInt8.create(9);
		11 > UInt8.create(10);
		UInt8.create(11) > 10;
		10.5 > UInt8.create(10);
		UInt8.create(10) > 9.5;
	}

	public function specGreaterOrEqual() {
		UInt8.create(10) >= UInt8.create(9);
		11 >= UInt8.create(10);
		UInt8.create(11) >= 10;
		10.5 >= UInt8.create(10);
		UInt8.create(10) >= 9.5;
	}

	public function specLess() {
		UInt8.create(9) < UInt8.create(10);
		10 < UInt8.create(11);
		UInt8.create(10) < 11;
		9.5 < UInt8.create(10);
		UInt8.create(10) < 10.5;
	}

	public function specLessOrEqual() {
		UInt8.create(9) <= UInt8.create(10);
		10 <= UInt8.create(11);
		UInt8.create(10) <= 11;
		9.5 <= UInt8.create(10);
		UInt8.create(10) <= 10.5;
	}

	public function specNegate() {
		~UInt8.parseBits('0000 0000') == UInt8.parseBits('1111 1111');
		~UInt8.parseBits('1111 1111') == UInt8.parseBits('0000 0000');
		~UInt8.parseBits('0000 0010') == UInt8.parseBits('1111 1101');
		~UInt8.parseBits('1100 0100') == UInt8.parseBits('0011 1011');

		(~UInt8.MAX).isTypeUInt8();
	}

	public function specAnd() {
		UInt8.parseBits('0000 0000') & UInt8.parseBits('1111 1111') == UInt8.parseBits('0000 0000');
		UInt8.parseBits('1110 0111') & UInt8.parseBits('0101 1010') == UInt8.parseBits('0100 0010');
		UInt8.parseBits('1110 0111') & UInt8.parseBits('1101 1010') == UInt8.parseBits('1100 0010');

		-1 & UInt8.MAX == 255;
		UInt8.MAX & 0 == 0;
		UInt8.parseBits('1111 1111') & -1 == Numeric.parseBitsInt('1111 1111', 8);

		(UInt8.MAX & UInt8.MAX).isTypeUInt8();
		(UInt8.MAX & 1).isTypeInt();
		(1 & UInt8.MAX).isTypeInt();
	}

	public function specOr() {
		UInt8.parseBits('0000 0000') | UInt8.parseBits('1111 1111') == UInt8.parseBits('1111 1111');
		UInt8.parseBits('1010 0101') | UInt8.parseBits('0100 0010') == UInt8.parseBits('1110 0111');

		-1 | UInt8.create(0) == -1;
		UInt8.create(0) | -1 == -1;
		0 | UInt8.parseBits('1000 0000') == 1 << 7;
		UInt8.parseBits('1000 0000') | 0 == 1 << 7;

		(UInt8.MAX | UInt8.MAX).isTypeUInt8();
		(UInt8.MAX | 1).isTypeInt();
		(1 | UInt8.MAX).isTypeInt();
	}

	public function specXor() {
		UInt8.parseBits('0000 0000') ^ UInt8.parseBits('1111 1111') == UInt8.parseBits('1111 1111');
		UInt8.parseBits('1010 0101') ^ UInt8.parseBits('1100 0011') == UInt8.parseBits('0110 0110');

		-1 ^ UInt8.MIN == -1;
		UInt8.MAX ^ 255 == 0;
		0 ^ UInt8.parseBits('1111 1111') == Numeric.parseBitsInt('1111 1111', 8);
		UInt8.parseBits('1111 1111') ^ 0 == Numeric.parseBitsInt('1111 1111', 8);

		(UInt8.MAX ^ UInt8.MAX).isTypeUInt8();
		(UInt8.MAX ^ 1).isTypeInt();
		(1 ^ UInt8.MAX).isTypeInt();
	}

	public function specShiftLeft() {
		UInt8.parseBits('0000 0001') << 2 == UInt8.parseBits('0000 0100');
		UInt8.parseBits('0100 0001') << 1 == UInt8.parseBits('1000 0010');
		UInt8.parseBits('1000 0001') << 1 == UInt8.parseBits('0000 0010');

		UInt8.parseBits('0000 0001') << UInt8.create(2) == UInt8.parseBits('0000 0100');

		UInt8.parseBits('1100 0001') << -1 == UInt8.parseBits('1000 0000');
		UInt8.parseBits('1100 0010') << -1 == UInt8.parseBits('0000 0000');

		1 << UInt8.create(2) == 1 << 2;
		4 << UInt8.create(1) == 4 << 1;

		(UInt8.MAX << UInt8.MAX).isTypeUInt8();
		(UInt8.MAX << 1).isTypeUInt8();
		(1 << UInt8.MAX).isTypeInt();
	}

	public function specShiftRight() {
		UInt8.parseBits('1000 0010') >> 1 == UInt8.parseBits('0100 0001');
		UInt8.parseBits('1000 0010') >> 2 == UInt8.parseBits('0010 0000');
		UInt8.parseBits('0100 0010') >> 2 == UInt8.parseBits('0001 0000');

		UInt8.parseBits('1000 0010') >> UInt8.create(1) == UInt8.parseBits('0100 0001');
		UInt8.parseBits('1000 0010') >> UInt8.create(2) == UInt8.parseBits('0010 0000');
		UInt8.parseBits('0100 0010') >> UInt8.create(2) == UInt8.parseBits('0001 0000');

		UInt8.parseBits('1101 0101') >> -1 == UInt8.parseBits('0000 0001');
		UInt8.parseBits('0101 0101') >> -1 == UInt8.parseBits('0000 0000');

		-2 >> UInt8.create(10) == -2 >> 10;
		32001 >> UInt8.create(10) == 32001 >> 10;

		(UInt8.MAX >> UInt8.MAX).isTypeUInt8();
		(UInt8.MAX >> 1).isTypeUInt8();
		(1 >> UInt8.MAX).isTypeInt();
	}

	public function specUnsignedShiftRight() {
		UInt8.parseBits('1000 0010') >>> 1 == UInt8.parseBits('0100 0001');
		UInt8.parseBits('1000 0010') >>> 2 == UInt8.parseBits('0010 0000');
		UInt8.parseBits('0100 0010') >>> 2 == UInt8.parseBits('0001 0000');

		UInt8.parseBits('1000 0010') >>> UInt8.create(1) == UInt8.parseBits('0100 0001');
		UInt8.parseBits('1000 0010') >>> UInt8.create(2) == UInt8.parseBits('0010 0000');
		UInt8.parseBits('0100 0010') >>> UInt8.create(2) == UInt8.parseBits('0001 0000');

		UInt8.parseBits('1101 0101') >>> -1 == UInt8.parseBits('0000 0001');
		UInt8.parseBits('0101 0101') >>> -1 == UInt8.parseBits('0000 0000');

		-2 >>> UInt8.create(10) == -2 >>> 10;
		32001 >>> UInt8.create(10) == 32001 >>> 10;

		(UInt8.MAX >>> UInt8.MAX).isTypeUInt8();
		(UInt8.MAX >>> 1).isTypeUInt8();
		(1 >>> UInt8.MAX).isTypeInt();
	}

}