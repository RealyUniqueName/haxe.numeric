package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;
import haxe.numeric.exceptions.OverflowException;

class UInt32Spec extends TestBase {
	static var maxAsFloat:Float = 4294967295.0;
	static var maxInt32:Int = 2147483647;
	static var minInt32:Int = -2147483648;

	public function specMinMax() {
		maxAsFloat == UInt32.MAX;
		0 == UInt32.MIN;

		UInt32.MAX.isTypeUInt32();
		UInt32.MIN.isTypeUInt32();
	}

	public function specParseBits() {
		UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000').isTypeUInt32();

		UInt32.MAX == UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');
		UInt32.MIN == UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');
		UInt32.create(0) == UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');
		UInt32.create(3) == UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0011');

		Assert.raises(() -> UInt32.parseBits('1234 5678 9012 3456 1234 5678 9012 3456'), InvalidArgumentException);
		Assert.raises(() -> UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 111'), InvalidArgumentException);
	}

	public function specCreate() {
		UInt32.create(maxInt32).isTypeUInt32();

		UInt32.create(0) == UInt32.MIN;
		UInt32.create(maxInt32) == maxInt32;

		overflow(
			function OVERFLOW_THROW() {
				if(!Numeric.is32BitsIntegers) {
					Assert.raises(() -> UInt32.create(Numeric.native32BitsInt + 1), OverflowException);
				}
				Assert.raises(() -> UInt32.create(-1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt32.MIN == UInt32.create(Numeric.native32BitsInt + 1);
				UInt32.MAX == UInt32.create(-1);
			}
		);
	}

	public function specCreateBits() {
		UInt32.createBits(Numeric.native32BitsInt).isTypeUInt32();

		UInt32.createBits(Numeric.native32BitsInt) == UInt32.MAX;
		UInt32.createBits(maxInt32) == maxInt32;

		if(!Numeric.is32BitsIntegers) {
			overflow(
				function OVERFLOW_THROW() {
					Assert.raises(() -> UInt32.createBits(-1), OverflowException);
				},
				function OVERFLOW_WRAP() {
					UInt32.MAX == UInt32.createBits(Numeric.native32BitsInt + 1);
				}
			);
		}
	}

	public function specToString() {
		'43210' == UInt32.create(43210).toString();
		'4294967295' == UInt32.MAX.toString();
		'0' == UInt32.MIN.toString();
		'null' == '' + (null:Null<UInt32>);
	}

	public function specPrefixIncrement() {
		var u32 = UInt32.create(0);
		++u32 == UInt32.create(1);
		u32 == UInt32.create(1);

		(++u32).isTypeUInt32();

		overflow(
			function OVERFLOW_THROW() {
				var u32 = UInt32.MAX;
				try {
					++u32;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt32.MAX, u32);
				}
			},
			function OVERFLOW_WRAP() {
				var u32 = UInt32.MAX;
				++u32;
				u32 == UInt32.MIN;
			}
		);
	}

	public function specPostfixIncrement() {
		var u32 = UInt32.create(0);
		u32++ == UInt32.create(0);
		u32 == UInt32.create(1);

		(u32++).isTypeUInt32();

		overflow(
			function OVERFLOW_THROW() {
				var u32 = UInt32.MAX;
				try {
					u32++;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt32.MAX, u32);
				}
			},
			function OVERFLOW_WRAP() {
				var u32 = UInt32.MAX;
				u32++;
				u32 == UInt32.MIN;
			}
		);
	}

	public function specPrefixDecrement() {
		var u32 = UInt32.create(10);
		--u32 == UInt32.create(9);
		u32 == UInt32.create(9);

		(--u32).isTypeUInt32();

		overflow(
			function OVERFLOW_THROW() {
				var u32 = UInt32.MIN;
				try {
					--u32;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt32.MIN, u32);
				}
			},
			function OVERFLOW_WRAP() {
				var u32 = UInt32.MIN;
				--u32;
				u32 == UInt32.MAX;
			}
		);
	}

	public function specPostfixDecrement() {
		var u32 = UInt32.create(10);
		u32-- == UInt32.create(10);
		u32 == UInt32.create(9);

		(u32--).isTypeUInt32();

		overflow(
			function OVERFLOW_THROW() {
				var u32 = UInt32.MIN;
				try {
					u32--;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(UInt32.MIN, u32);
				}
			},
			function OVERFLOW_WRAP() {
				var u32 = UInt32.MIN;
				u32--;
				u32 == UInt32.MAX;
			}
		);
	}

	public function specAddition() {
		UInt32.create(251) == UInt32.create(250) + UInt32.create(1);
		maxAsFloat * 2 == UInt32.MAX + maxAsFloat;
		maxAsFloat * 2 == maxAsFloat + UInt32.MAX;

		(UInt32.create(0) + UInt32.create(0)).isTypeUInt32();
		(UInt32.create(0) + 1.0).isTypeFloat();
		(1.0 + UInt32.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt32.MAX + UInt32.create(1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt32.MAX + UInt32.create(1) == UInt32.MIN;
			}
		);
	}

	public function specSubtraction() {
		UInt32.create(0) == UInt32.MAX - UInt32.MAX;
		UInt32.create(0) == UInt32.MIN - UInt32.MIN;
		maxAsFloat + 1 == UInt32.MAX - (-1.0);
		-1.0 == -1.0 - UInt32.MIN;

		(UInt32.create(0) - UInt32.create(0)).isTypeUInt32();
		(UInt32.create(0) - 1.0).isTypeFloat();
		(1.0 - UInt32.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt32.create(2) - UInt32.create(3), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt32.MIN - UInt32.create(1) == UInt32.MAX;
			}
		);
	}

	public function specMultiplication() {
		UInt32.create(50) == UInt32.create(5) * UInt32.create(10);

		maxAsFloat * 2 == UInt32.MAX * 2.0;

		(UInt32.create(0) * UInt32.create(0)).isTypeUInt32();
		(UInt32.create(0) * 1.0).isTypeFloat();
		(1.0 * UInt32.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> UInt32.MAX * UInt32.create(2), OverflowException);
			},
			function OVERFLOW_WRAP() {
				UInt32.MAX * UInt32.MAX == UInt32.create(1);
				UInt32.MAX * UInt32.create(2) == 4294967294.0;
			}
		);
	}

	public function specDivision() {
		7 == UInt32.create(14) / 2;
		7 == 14 / UInt32.create(2);
		7 == UInt32.create(14) / 2.0;
		7 == 14.0 / UInt32.create(2);

		(UInt32.create(0) / UInt32.create(1)).isTypeFloat();
		(UInt32.create(0) / 1).isTypeFloat();
		(1 / UInt32.create(1)).isTypeFloat();
		(UInt32.create(0) / 1.0).isTypeFloat();
		(1.0 / UInt32.create(1)).isTypeFloat();
	}

	// public function specModulo() {
	// 	UInt32.create(2) == UInt32.create(43210) % UInt32.create(8);

	// 	UInt32.create(2) == UInt32.create(43210) % 8;
	// 	UInt32.create(2) == UInt32.create(43210) % -8;
	// 	1 == 100 % UInt32.create(9);

	// 	87.5 == UInt32.create(43210) % 117.5;
	// 	0.5 == 6.5 % UInt32.create(3);
	// 	-0.5 == -6.5 % UInt32.create(3);

	// 	(UInt32.create(0) % UInt32.create(0)).isTypeUInt32();
	// 	(UInt32.create(0) % 1).isTypeUInt32();
	// 	(1 % UInt32.create(0)).isTypeUInt32();
	// 	(UInt32.create(0) % 1.0).isTypeFloat();
	// 	(1.0 % UInt32.create(0)).isTypeFloat();
	// }

	// public function specEqual() {
	// 	UInt32.create(10) == UInt32.create(10);
	// 	10 == UInt32.create(10);
	// 	UInt32.create(10) == 10;
	// 	10.0 == UInt32.create(10);
	// 	UInt32.create(10) == 10.0;
	// }

	// public function specNotEqual() {
	// 	UInt32.create(10) != UInt32.create(9);
	// 	11 != UInt32.create(10);
	// 	UInt32.create(10) != 11;
	// 	10.5 != UInt32.create(10);
	// 	UInt32.create(10) != 10.5;
	// }

	// public function specGreater() {
	// 	UInt32.create(10) > UInt32.create(9);
	// 	11 > UInt32.create(10);
	// 	UInt32.create(11) > 10;
	// 	10.5 > UInt32.create(10);
	// 	UInt32.create(10) > 9.5;
	// }

	// public function specGreaterOrEqual() {
	// 	UInt32.create(10) >= UInt32.create(9);
	// 	11 >= UInt32.create(10);
	// 	UInt32.create(11) >= 10;
	// 	10.5 >= UInt32.create(10);
	// 	UInt32.create(10) >= 9.5;
	// }

	// public function specLess() {
	// 	UInt32.create(9) < UInt32.create(10);
	// 	10 < UInt32.create(11);
	// 	UInt32.create(10) < 11;
	// 	9.5 < UInt32.create(10);
	// 	UInt32.create(10) < 10.5;
	// }

	// public function specLessOrEqual() {
	// 	UInt32.create(9) <= UInt32.create(10);
	// 	10 <= UInt32.create(11);
	// 	UInt32.create(10) <= 11;
	// 	9.5 <= UInt32.create(10);
	// 	UInt32.create(10) <= 10.5;
	// }

	// public function specNegate() {
	// 	~UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000') == UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');
	// 	~UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111') == UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');
	// 	~UInt32.parseBits('0000 0011 1100 0010') == UInt32.parseBits('1111 1100 0011 1101');
	// 	~UInt32.parseBits('1100 0011 1100 0100') == UInt32.parseBits('0011 1100 0011 1011');

	// 	(~UInt32.MAX).isTypeUInt32();
	// }

	// public function specAnd() {
	// 	UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000') & UInt32.parseBits('1111 0000 0000 1111') == UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');
	// 	UInt32.parseBits('1110 0000 0000 0111') & UInt32.parseBits('0101 0000 0000 1010') == UInt32.parseBits('0100 0000 0000 0010');
	// 	UInt32.parseBits('1110 0000 0000 0111') & UInt32.parseBits('1101 0000 0000 1010') == UInt32.parseBits('1100 0000 0000 0010');

	// 	-1 & UInt32.MAX == 65535;
	// 	UInt32.MAX & 0 == 0;
	// 	UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111') & -1 == Numeric.parseBitsInt('1111 1111 1111 1111 1111 1111 1111 1111', 16);

	// 	(UInt32.MAX & UInt32.MAX).isTypeUInt32();
	// 	(UInt32.MAX & 1).isTypeInt();
	// 	(1 & UInt32.MAX).isTypeInt();
	// }

	// public function specOr() {
	// 	UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000') | UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111') == UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');
	// 	UInt32.parseBits('1010 0011 1100 0101') | UInt32.parseBits('0100 0011 0011 0010') == UInt32.parseBits('1110 0011 1111 0111');

	// 	-1 | UInt32.create(0) == -1;
	// 	UInt32.create(0) | -1 == -1;
	// 	0 | UInt32.parseBits('1000 0000 0000 0000') == 1 << 15;
	// 	UInt32.parseBits('1000 0000 0000 0000') | 0 == 1 << 15;

	// 	(UInt32.MAX | UInt32.MAX).isTypeUInt32();
	// 	(UInt32.MAX | 1).isTypeInt();
	// 	(1 | UInt32.MAX).isTypeInt();
	// }

	// public function specXor() {
	// 	UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000') ^ UInt32.parseBits('1111 0011 1100 1111') == UInt32.parseBits('1111 0011 1100 1111');
	// 	UInt32.parseBits('1010 0000 0000 0101') ^ UInt32.parseBits('1100 0011 1100 0011') == UInt32.parseBits('0110 0011 1100 0110');

	// 	-1 ^ UInt32.MIN == -1;
	// 	UInt32.MAX ^ 65535 == 0;
	// 	0 ^ UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111') == Numeric.parseBitsInt('1111 1111 1111 1111 1111 1111 1111 1111', 16);
	// 	UInt32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111') ^ 0 == Numeric.parseBitsInt('1111 1111 1111 1111 1111 1111 1111 1111', 16);

	// 	(UInt32.MAX ^ UInt32.MAX).isTypeUInt32();
	// 	(UInt32.MAX ^ 1).isTypeInt();
	// 	(1 ^ UInt32.MAX).isTypeInt();
	// }

	// public function specShiftLeft() {
	// 	UInt32.parseBits('0000 0000 0000 0001') << 2 == UInt32.parseBits('0000 0000 0000 0100');
	// 	UInt32.parseBits('0100 0000 0000 0001') << 1 == UInt32.parseBits('1000 0000 0000 0010');
	// 	UInt32.parseBits('1000 0000 0000 0001') << 1 == UInt32.parseBits('0000 0000 0000 0010');

	// 	UInt32.parseBits('0000 0000 0000 0001') << UInt32.create(2) == UInt32.parseBits('0000 0000 0000 0100');

	// 	UInt32.parseBits('1100 0000 0000 0001') << -1 == UInt32.parseBits('1000 0000 0000 0000');
	// 	UInt32.parseBits('1100 0000 0000 0010') << -1 == UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

	// 	1 << UInt32.create(2) == 1 << 2;
	// 	4 << UInt32.create(1) == 4 << 1;

	// 	(UInt32.MAX << UInt32.MAX).isTypeUInt32();
	// 	(UInt32.MAX << 1).isTypeUInt32();
	// 	(1 << UInt32.MAX).isTypeInt();
	// }

	// public function specShiftRight() {
	// 	UInt32.parseBits('1000 0000 0000 0010') >> 1 == UInt32.parseBits('0100 0000 0000 0001');
	// 	UInt32.parseBits('1000 0000 0000 0010') >> 2 == UInt32.parseBits('0010 0000 0000 0000');
	// 	UInt32.parseBits('0100 0000 0000 0010') >> 2 == UInt32.parseBits('0001 0000 0000 0000');

	// 	UInt32.parseBits('1000 0000 0000 0010') >> UInt32.create(1) == UInt32.parseBits('0100 0000 0000 0001');
	// 	UInt32.parseBits('1000 0000 0000 0010') >> UInt32.create(2) == UInt32.parseBits('0010 0000 0000 0000');
	// 	UInt32.parseBits('0100 0000 0000 0010') >> UInt32.create(2) == UInt32.parseBits('0001 0000 0000 0000');

	// 	UInt32.parseBits('1101 0000 0000 0101') >> -1 == UInt32.parseBits('0000 0000 0000 0001');
	// 	UInt32.parseBits('0101 0000 0000 0101') >> -1 == UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

	// 	-2 >> UInt32.create(10) == -2 >> 10;
	// 	32001 >> UInt32.create(10) == 32001 >> 10;

	// 	(UInt32.MAX >> UInt32.MAX).isTypeUInt32();
	// 	(UInt32.MAX >> 1).isTypeUInt32();
	// 	(1 >> UInt32.MAX).isTypeInt();
	// }

	// public function specUnsignedShiftRight() {
	// 	UInt32.parseBits('1000 0000 0000 0010') >>> 1 == UInt32.parseBits('0100 0000 0000 0001');
	// 	UInt32.parseBits('1000 0000 0000 0010') >>> 2 == UInt32.parseBits('0010 0000 0000 0000');
	// 	UInt32.parseBits('0100 0000 0000 0010') >>> 2 == UInt32.parseBits('0001 0000 0000 0000');

	// 	UInt32.parseBits('1000 0000 0000 0010') >>> UInt32.create(1) == UInt32.parseBits('0100 0000 0000 0001');
	// 	UInt32.parseBits('1000 0000 0000 0010') >>> UInt32.create(2) == UInt32.parseBits('0010 0000 0000 0000');
	// 	UInt32.parseBits('0100 0000 0000 0010') >>> UInt32.create(2) == UInt32.parseBits('0001 0000 0000 0000');

	// 	UInt32.parseBits('1101 0000 0000 0101') >>> -1 == UInt32.parseBits('0000 0000 0000 0001');
	// 	UInt32.parseBits('0101 0000 0000 0101') >>> -1 == UInt32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

	// 	-2 >>> UInt32.create(10) == -2 >>> 10;
	// 	32001 >>> UInt32.create(10) == 32001 >>> 10;

	// 	(UInt32.MAX >>> UInt32.MAX).isTypeUInt32();
	// 	(UInt32.MAX >>> 1).isTypeUInt32();
	// 	(1 >>> UInt32.MAX).isTypeInt();
	// }

}