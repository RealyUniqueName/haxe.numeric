package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;
import haxe.numeric.exceptions.OverflowException;

class UInt16Spec extends TestBase {
	public function specMinMax() {
		65535 == UInt16.MAX;
		0 == UInt16.MIN;

		UInt16.MAX.isTypeUInt16();
		UInt16.MIN.isTypeUInt16();
	}

	public function specParseBits() {
		UInt16.parseBits('0000 0000 0000 0000').isTypeUInt16();

		UInt16.MAX == UInt16.parseBits('1111 1111 1111 1111');
		UInt16.MIN == UInt16.parseBits('0000 0000 0000 0000');
		UInt16.create(0) == UInt16.parseBits('0000 0000 0000 0000');
		UInt16.create(3) == UInt16.parseBits('0000 0000 0000 0011');
		UInt16.create(65533) == UInt16.parseBits('1111 1111 1111 1101');

		Assert.raises(() -> UInt16.parseBits('1234 5678 9012 3456'), InvalidArgumentException);
		Assert.raises(() -> UInt16.parseBits('1111 1111 1111 111'), InvalidArgumentException);
	}

	public function specCreate() {
		UInt16.create(0x8000).isTypeUInt16();

		UInt16.create(0) == UInt16.MIN;
		UInt16.create(0xFFFF) == UInt16.MAX;

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt16.create(0xFFFF + 1), OverflowException);
				Assert.raises(() -> UInt16.create(-1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt16.MIN == UInt16.create(0xFFFF + 1);
				UInt16.MAX == UInt16.create(-1);
			}
		);
	}

	public function specToString() {
		'43210' == UInt16.create(43210).toString();
		'65535' == UInt16.MAX.toString();
		'0' == UInt16.MIN.toString();
		'null' == '' + (null:Null<UInt16>);
	}

	public function specToInt() {
		65535 == UInt16.MAX.toInt();
		0 == UInt16.MIN.toInt();
	}

	public function specNegative() {
		(-UInt16.create(10)).isTypeInt();

		-UInt16.create(10) == -10;
	}

	public function specPrefixIncrement() {
		var u16 = UInt16.create(0);
		++u16 == UInt16.create(1);
		u16 == UInt16.create(1);

		(++u16).isTypeUInt16();

		overflow(
			function OVERFLOW_THROW() {
				var u16 = UInt16.MAX;
				try {
					++u16;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt16.MAX, u16);
				}
			},
			function OVERFLOW_WRAP() {
				var u16 = UInt16.MAX;
				++u16;
				u16 == UInt16.MIN;
			}
		);
	}

	public function specPostfixIncrement() {
		var u16 = UInt16.create(0);
		u16++ == UInt16.create(0);
		u16 == UInt16.create(1);

		(u16++).isTypeUInt16();

		overflow(
			function OVERFLOW_THROW() {
				var u16 = UInt16.MAX;
				try {
					u16++;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt16.MAX, u16);
				}
			},
			function OVERFLOW_WRAP() {
				var u16 = UInt16.MAX;
				u16++;
				u16 == UInt16.MIN;
			}
		);
	}

	public function specPrefixDecrement() {
		var u16 = UInt16.create(10);
		--u16 == UInt16.create(9);
		u16 == UInt16.create(9);

		(--u16).isTypeUInt16();

		overflow(
			function OVERFLOW_THROW() {
				var u16 = UInt16.MIN;
				try {
					--u16;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt16.MIN, u16);
				}
			},
			function OVERFLOW_WRAP() {
				var u16 = UInt16.MIN;
				--u16;
				u16 == UInt16.MAX;
			}
		);
	}

	public function specPostfixDecrement() {
		var u16 = UInt16.create(10);
		u16-- == UInt16.create(10);
		u16 == UInt16.create(9);

		(u16--).isTypeUInt16();

		overflow(
			function OVERFLOW_THROW() {
				var u16 = UInt16.MIN;
				try {
					u16--;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt16.MIN, u16);
				}
			},
			function OVERFLOW_WRAP() {
				var u16 = UInt16.MIN;
				u16--;
				u16 == UInt16.MAX;
			}
		);
	}

	public function specAddition() {
		65536 == UInt16.MAX + 1;
		-1 == -1 + UInt16.MIN;
		65536.0 == UInt16.MAX + 1.0;
		-1.0 == -1.0 + UInt16.MIN;
		UInt16.create(251) == UInt16.create(250) + UInt16.create(1);

		(UInt16.create(0) + UInt16.create(0)).isTypeUInt16();
		(UInt16.create(0) + 1).isTypeInt();
		(1 + UInt16.create(0)).isTypeInt();
		(UInt16.create(0) + 1.0).isTypeFloat();
		(1.0 + UInt16.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt16.MAX + UInt16.create(1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt16.MAX + UInt16.create(1) == UInt16.MIN;
			}
		);
	}

	public function specSubtraction() {
		UInt16.create(0) == UInt16.MAX - UInt16.MAX;
		UInt16.create(0) == UInt16.MIN - UInt16.MIN;

		65536 == UInt16.MAX - (-1);
		-1 == -1 - UInt16.MIN;
		65536.0 == UInt16.MAX - (-1.0);
		-1.0 == -1.0 - UInt16.MIN;

		(UInt16.create(0) - UInt16.create(0)).isTypeUInt16();
		(UInt16.create(0) - 1).isTypeInt();
		(1 - UInt16.create(0)).isTypeInt();
		(UInt16.create(0) - 1.0).isTypeFloat();
		(1.0 - UInt16.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt16.MAX - UInt16.create(-1), OverflowException);
				Assert.raises(() -> UInt16.MIN - UInt16.create(1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt16.MAX - UInt16.create(-1) == UInt16.MIN;
				UInt16.MIN - UInt16.create(1) == UInt16.MAX;
			}
		);
	}

	public function specMultiplication() {
		UInt16.create(50) == UInt16.create(5) * UInt16.create(10);

		131070 == UInt16.MAX * 2;
		131070.0 == UInt16.MAX * 2.0;

		(UInt16.create(0) * UInt16.create(0)).isTypeUInt16();
		(UInt16.create(0) * 1).isTypeInt();
		(1 * UInt16.create(0)).isTypeInt();
		(UInt16.create(0) * 1.0).isTypeFloat();
		(1.0 * UInt16.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt16.MAX * UInt16.create(2), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt16.parseBits('0111 1111 1111 1111') * UInt16.create(2) == UInt16.parseBits('1111 1111 1111 1110');
				UInt16.parseBits('1000 0000 0000 0000') * UInt16.create(2) == UInt16.parseBits('0000 0000 0000 0000');
			}
		);
	}

	public function specDivision() {
		7 == UInt16.create(14) / 2;
		7 == 14 / UInt16.create(2);
		7 == UInt16.create(14) / 2.0;
		7 == 14.0 / UInt16.create(2);

		(UInt16.create(0) / UInt16.create(1)).isTypeFloat();
		(UInt16.create(0) / 1).isTypeFloat();
		(1 / UInt16.create(1)).isTypeFloat();
		(UInt16.create(0) / 1.0).isTypeFloat();
		(1.0 / UInt16.create(1)).isTypeFloat();
	}

	public function specModulo() {
		UInt16.create(2) == UInt16.create(43210) % UInt16.create(8);

		UInt16.create(2) == UInt16.create(43210) % 8;
		UInt16.create(2) == UInt16.create(43210) % -8;
		1 == 100 % UInt16.create(9);

		87.5 == UInt16.create(43210) % 117.5;
		0.5 == 6.5 % UInt16.create(3);
		-0.5 == -6.5 % UInt16.create(3);

		(UInt16.create(0) % UInt16.create(0)).isTypeUInt16();
		(UInt16.create(0) % 1).isTypeUInt16();
		(1 % UInt16.create(0)).isTypeUInt16();
		(UInt16.create(0) % 1.0).isTypeFloat();
		(1.0 % UInt16.create(0)).isTypeFloat();
	}

	public function specEqual() {
		UInt16.create(10) == UInt16.create(10);
		10 == UInt16.create(10);
		UInt16.create(10) == 10;
		10.0 == UInt16.create(10);
		UInt16.create(10) == 10.0;
	}

	public function specNotEqual() {
		UInt16.create(10) != UInt16.create(9);
		11 != UInt16.create(10);
		UInt16.create(10) != 11;
		10.5 != UInt16.create(10);
		UInt16.create(10) != 10.5;
	}

	public function specGreater() {
		UInt16.create(10) > UInt16.create(9);
		11 > UInt16.create(10);
		UInt16.create(11) > 10;
		10.5 > UInt16.create(10);
		UInt16.create(10) > 9.5;
	}

	public function specGreaterOrEqual() {
		UInt16.create(10) >= UInt16.create(9);
		11 >= UInt16.create(10);
		UInt16.create(11) >= 10;
		10.5 >= UInt16.create(10);
		UInt16.create(10) >= 9.5;
	}

	public function specLess() {
		UInt16.create(9) < UInt16.create(10);
		10 < UInt16.create(11);
		UInt16.create(10) < 11;
		9.5 < UInt16.create(10);
		UInt16.create(10) < 10.5;
	}

	public function specLessOrEqual() {
		UInt16.create(9) <= UInt16.create(10);
		10 <= UInt16.create(11);
		UInt16.create(10) <= 11;
		9.5 <= UInt16.create(10);
		UInt16.create(10) <= 10.5;
	}

	public function specNegate() {
		~UInt16.parseBits('0000 0000 0000 0000') == UInt16.parseBits('1111 1111 1111 1111');
		~UInt16.parseBits('1111 1111 1111 1111') == UInt16.parseBits('0000 0000 0000 0000');
		~UInt16.parseBits('0000 0011 1100 0010') == UInt16.parseBits('1111 1100 0011 1101');
		~UInt16.parseBits('1100 0011 1100 0100') == UInt16.parseBits('0011 1100 0011 1011');

		(~UInt16.MAX).isTypeUInt16();
	}

	public function specAnd() {
		UInt16.parseBits('0000 0000 0000 0000') & UInt16.parseBits('1111 0000 0000 1111') == UInt16.parseBits('0000 0000 0000 0000');
		UInt16.parseBits('1110 0000 0000 0111') & UInt16.parseBits('0101 0000 0000 1010') == UInt16.parseBits('0100 0000 0000 0010');
		UInt16.parseBits('1110 0000 0000 0111') & UInt16.parseBits('1101 0000 0000 1010') == UInt16.parseBits('1100 0000 0000 0010');

		-1 & UInt16.MAX == 65535;
		UInt16.MAX & 0 == 0;
		UInt16.parseBits('1111 1111 1111 1111') & -1 == Numeric.parseBitsInt('1111 1111 1111 1111', 16);

		(UInt16.MAX & UInt16.MAX).isTypeUInt16();
		(UInt16.MAX & 1).isTypeInt();
		(1 & UInt16.MAX).isTypeInt();
	}

	public function specOr() {
		UInt16.parseBits('0000 0000 0000 0000') | UInt16.parseBits('1111 1111 1111 1111') == UInt16.parseBits('1111 1111 1111 1111');
		UInt16.parseBits('1010 0011 1100 0101') | UInt16.parseBits('0100 0011 0011 0010') == UInt16.parseBits('1110 0011 1111 0111');

		-1 | UInt16.create(0) == -1;
		UInt16.create(0) | -1 == -1;
		0 | UInt16.parseBits('1000 0000 0000 0000') == 1 << 15;
		UInt16.parseBits('1000 0000 0000 0000') | 0 == 1 << 15;

		(UInt16.MAX | UInt16.MAX).isTypeUInt16();
		(UInt16.MAX | 1).isTypeInt();
		(1 | UInt16.MAX).isTypeInt();
	}

	public function specXor() {
		UInt16.parseBits('0000 0000 0000 0000') ^ UInt16.parseBits('1111 0011 1100 1111') == UInt16.parseBits('1111 0011 1100 1111');
		UInt16.parseBits('1010 0000 0000 0101') ^ UInt16.parseBits('1100 0011 1100 0011') == UInt16.parseBits('0110 0011 1100 0110');

		-1 ^ UInt16.MIN == -1;
		UInt16.MAX ^ 65535 == 0;
		0 ^ UInt16.parseBits('1111 1111 1111 1111') == Numeric.parseBitsInt('1111 1111 1111 1111', 16);
		UInt16.parseBits('1111 1111 1111 1111') ^ 0 == Numeric.parseBitsInt('1111 1111 1111 1111', 16);

		(UInt16.MAX ^ UInt16.MAX).isTypeUInt16();
		(UInt16.MAX ^ 1).isTypeInt();
		(1 ^ UInt16.MAX).isTypeInt();
	}

	public function specShiftLeft() {
		UInt16.parseBits('0000 0000 0000 0001') << 2 == UInt16.parseBits('0000 0000 0000 0100');
		UInt16.parseBits('0100 0000 0000 0001') << 1 == UInt16.parseBits('1000 0000 0000 0010');
		UInt16.parseBits('1000 0000 0000 0001') << 1 == UInt16.parseBits('0000 0000 0000 0010');

		UInt16.parseBits('0000 0000 0000 0001') << UInt16.create(2) == UInt16.parseBits('0000 0000 0000 0100');

		UInt16.parseBits('1100 0000 0000 0001') << -1 == UInt16.parseBits('1000 0000 0000 0000');
		UInt16.parseBits('1100 0000 0000 0010') << -1 == UInt16.parseBits('0000 0000 0000 0000');

		1 << UInt16.create(2) == 1 << 2;
		4 << UInt16.create(1) == 4 << 1;

		(UInt16.MAX << UInt16.MAX).isTypeUInt16();
		(UInt16.MAX << 1).isTypeUInt16();
		(1 << UInt16.MAX).isTypeInt();
	}

	public function specShiftRight() {
		UInt16.parseBits('1000 0000 0000 0010') >> 1 == UInt16.parseBits('0100 0000 0000 0001');
		UInt16.parseBits('1000 0000 0000 0010') >> 2 == UInt16.parseBits('0010 0000 0000 0000');
		UInt16.parseBits('0100 0000 0000 0010') >> 2 == UInt16.parseBits('0001 0000 0000 0000');

		UInt16.parseBits('1000 0000 0000 0010') >> UInt16.create(1) == UInt16.parseBits('0100 0000 0000 0001');
		UInt16.parseBits('1000 0000 0000 0010') >> UInt16.create(2) == UInt16.parseBits('0010 0000 0000 0000');
		UInt16.parseBits('0100 0000 0000 0010') >> UInt16.create(2) == UInt16.parseBits('0001 0000 0000 0000');

		UInt16.parseBits('1101 0000 0000 0101') >> -1 == UInt16.parseBits('0000 0000 0000 0001');
		UInt16.parseBits('0101 0000 0000 0101') >> -1 == UInt16.parseBits('0000 0000 0000 0000');

		-2 >> UInt16.create(10) == -2 >> 10;
		32001 >> UInt16.create(10) == 32001 >> 10;

		(UInt16.MAX >> UInt16.MAX).isTypeUInt16();
		(UInt16.MAX >> 1).isTypeUInt16();
		(1 >> UInt16.MAX).isTypeInt();
	}

	public function specUnsignedShiftRight() {
		UInt16.parseBits('1000 0000 0000 0010') >>> 1 == UInt16.parseBits('0100 0000 0000 0001');
		UInt16.parseBits('1000 0000 0000 0010') >>> 2 == UInt16.parseBits('0010 0000 0000 0000');
		UInt16.parseBits('0100 0000 0000 0010') >>> 2 == UInt16.parseBits('0001 0000 0000 0000');

		UInt16.parseBits('1000 0000 0000 0010') >>> UInt16.create(1) == UInt16.parseBits('0100 0000 0000 0001');
		UInt16.parseBits('1000 0000 0000 0010') >>> UInt16.create(2) == UInt16.parseBits('0010 0000 0000 0000');
		UInt16.parseBits('0100 0000 0000 0010') >>> UInt16.create(2) == UInt16.parseBits('0001 0000 0000 0000');

		UInt16.parseBits('1101 0000 0000 0101') >>> -1 == UInt16.parseBits('0000 0000 0000 0001');
		UInt16.parseBits('0101 0000 0000 0101') >>> -1 == UInt16.parseBits('0000 0000 0000 0000');

		-2 >>> UInt16.create(10) == -2 >>> 10;
		32001 >>> UInt16.create(10) == 32001 >>> 10;

		(UInt16.MAX >>> UInt16.MAX).isTypeUInt16();
		(UInt16.MAX >>> 1).isTypeUInt16();
		(1 >>> UInt16.MAX).isTypeInt();
	}

}