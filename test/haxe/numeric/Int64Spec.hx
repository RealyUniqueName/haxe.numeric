package haxe.numeric;

import haxe.numeric.Numeric.native32BitsInt;
import haxe.numeric.Numeric.is32BitsIntegers;
import haxe.numeric.exceptions.InvalidArgumentException;
import haxe.numeric.exceptions.OverflowException;

class Int64Spec extends TestBase {
	public function specMinMax() {
		'9223372036854775807' == Int64.MAX.toString();
		'-9223372036854775808' == Int64.MIN.toString();
	}

	public function specComposeBits() {
		'4294967298' == Int64.composeBits(1, 2).toString();
		'-1' == Int64.composeBits(native32BitsInt, native32BitsInt).toString();
		'4294967295' == Int64.composeBits(0, native32BitsInt).toString();
		'-4294967296' == Int64.composeBits(native32BitsInt, 0).toString();

		if(!is32BitsIntegers) {
			overflow(
				function OVERFLOW_THROW() {
					Assert.raises(() -> Int64.composeBits(native32BitsInt + 1, 0), OverflowException);
					Assert.raises(() -> Int64.composeBits(0, native32BitsInt + 1), OverflowException);
				},
				function OVERFLOW_WRAP() {
					'4294967294' == Int64.composeBits(0, native32BitsInt + native32BitsInt).toString();
					'-8589934592' == Int64.composeBits(native32BitsInt + native32BitsInt, 0).toString();
				}
			);
		}
	}

	public function specCreate() {
		Int64.create(123).isTypeInt64();

		'$native32BitsInt' == Int64.create(native32BitsInt).toString();
		'-1' == Int64.create(-1).toString();
		'1234567890' == Int64.create(1234567890).toString();
		'-1234567890' == Int64.create(-1234567890).toString();
	}

	public function specCreateBits() {
		Int64.create(123).isTypeInt64();

		'1234567890' == Int64.createBits(1234567890).toString();
		if(Numeric.is32BitsIntegers) {
			'4294967295' == Int64.createBits(-1).toString();
			'3060399406' == Int64.createBits(-1234567890).toString();
		} else{
			'-1' == Int64.createBits(-1).toString();
			'-1234567890' == Int64.createBits(-1234567890).toString();
		}
	}

	public function specParseBits() {
		Int64.parseBits('0000000000000000 0000000000000000 0000000000000000 0000000000000000').isTypeInt64();

		'0' == Int64.parseBits('0000000000000000 0000000000000000 0000000000000000 0000000000000000').toString();
		'3' == Int64.parseBits('0000000000000000 0000000000000000 0000000000000000 0000000000000011').toString();
		'9223372036854775807' == Int64.parseBits('0111111111111111 1111111111111111 1111111111111111 1111111111111111').toString();
		'-9223372036854775808' == Int64.parseBits('1000000000000000 0000000000000000 0000000000000000 0000000000000000').toString();
		'-3' == Int64.parseBits('1111111111111111 1111111111111111 1111111111111111 1111111111111101').toString();
		'-1' == Int64.parseBits('1111111111111111 1111111111111111 1111111111111111 1111111111111111').toString();

		Assert.raises(
			() -> Int64.parseBits('1234567890123456 1234567890123456 1234567890123456 1234567890123456'),
			InvalidArgumentException
		);
		Assert.raises(
			() -> Int64.parseBits('1111111111111111 1111111111111111 1111111111111111 111111111111111'),
			InvalidArgumentException
		);
		Assert.raises(
			() -> Int64.parseBits('1111111111111111'),
			InvalidArgumentException
		);
	}

	public function specNegative() {
		(-Int64.create(10)).isTypeInt64();

		'-9223372036854775807' == (-Int64.MAX).toString();
		Int64.create(-1) == -Int64.create(1);
		Int64.create(1) == -Int64.create(-1);

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> -Int64.MIN, OverflowException);
			},
			function OVERFLOW_WRAP() {
				-Int64.MIN == Int64.MIN;
			}
		);
	}

	public function specPrefixIncrement() {
		var i64 = Int64.create(0);
		++i64 == Int64.create(1);
		i64 == Int64.create(1);

		var i64 = Int64.composeBits(0, native32BitsInt);
		++i64 == Int64.composeBits(1, 0);

		(++i64).isTypeInt64();

		overflow(
			function OVERFLOW_THROW() {
				var i64 = Int64.MAX;
				try {
					++i64;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int64.MAX, i64);
				}
			},
			function OVERFLOW_WRAP() {
				var i64 = Int64.MAX;
				++i64;
				i64 == Int64.MIN;
			}
		);
	}

	public function specPostfixIncrement() {
		var i64 = Int64.create(0);
		i64++ == Int64.create(0);
		i64 == Int64.create(1);

		var i64 = Int64.composeBits(0, native32BitsInt);
		i64++ == Int64.composeBits(0, native32BitsInt);
		i64 == Int64.composeBits(1, 0);

		(i64++).isTypeInt64();

		overflow(
			function OVERFLOW_THROW() {
				var i64 = Int64.MAX;
				try {
					i64++;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int64.MAX, i64);
				}
			},
			function OVERFLOW_WRAP() {
				var i64 = Int64.MAX;
				i64++;
				i64 == Int64.MIN;
			}
		);
	}

	public function specPrefixDecrement() {
		var i64 = Int64.create(0);
		--i64 == Int64.create(-1);
		i64 == Int64.create(-1);

		var i64 = Int64.composeBits(1, 0);
		--i64 == Int64.composeBits(0, native32BitsInt);

		(--i64).isTypeInt64();

		overflow(
			function OVERFLOW_THROW() {
				var i64 = Int64.MIN;
				try {
					--i64;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int64.MIN, i64);
				}
			},
			function OVERFLOW_WRAP() {
				var i64 = Int64.MIN;
				--i64;
				i64 == Int64.MAX;
			}
		);
	}

	public function specPostfixDecrement() {
		var i64 = Int64.create(0);
		i64-- == Int64.create(0);
		i64 == Int64.create(-1);

		var i64 = Int64.composeBits(1, 0);
		i64-- == Int64.composeBits(1, 0);
		i64 == Int64.composeBits(0, native32BitsInt);

		(i64--).isTypeInt64();

		overflow(
			function OVERFLOW_THROW() {
				var i64 = Int64.MIN;
				try {
					i64--;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int64.MIN, i64);
				}
			},
			function OVERFLOW_WRAP() {
				var i64 = Int64.MIN;
				i64--;
				i64 == Int64.MAX;
			}
		);
	}

	// public function specAddition() {
	// 	Int32.create(-1) == Int32.MAX + Int32.MIN;

	// 	1235.0 == Int32.create(1234) + 1.0;

	// 	(Int32.create(0) + Int32.create(0)).isTypeInt32();
	// 	(Int32.create(0) + 1.0).isTypeFloat();
	// 	(1.0 + Int32.create(0)).isTypeFloat();

	// 	overflow(
	// 		function OVERFLOW_THROW() {
	// 			Assert.raises(() -> Int32.MAX + Int32.create(1), OverflowException);
	// 			Assert.raises(() -> Int32.MIN + Int32.create(-1), OverflowException);
	// 		},
	// 		function OVERFLOW_WRAP() {
	// 			Int32.MAX + Int32.create(1) == Int32.MIN;
	// 			Int32.MIN + Int32.create(-1) == Int32.MAX;
	// 		}
	// 	);
	// }

	// public function specSubtraction() {
	// 	Int32.create(0) == Int32.MAX - Int32.MAX;
	// 	Int32.create(0) == Int32.MIN - Int32.MIN;

	// 	124.0 == Int32.create(123) - (-1.0);
	// 	-122.0 == 1.0 - Int32.create(123);

	// 	(Int32.create(0) - Int32.create(0)).isTypeInt32();
	// 	(Int32.create(0) - 1.0).isTypeFloat();
	// 	(1.0 - Int32.create(0)).isTypeFloat();

	// 	overflow(
	// 		function OVERFLOW_THROW() {
	// 			Assert.raises(() -> Int32.MAX - Int32.create(-1), OverflowException);
	// 			Assert.raises(() -> Int32.MIN - Int32.create(1), OverflowException);
	// 		},
	// 		function OVERFLOW_WRAP() {
	// 			Int32.MAX - Int32.create(-1) == Int32.MIN;
	// 			Int32.MIN - Int32.create(1) == Int32.MAX;
	// 		}
	// 	);
	// }

	// public function specMultiplication() {
	// 	Int32.create(50) == Int32.create(5) * Int32.create(10);
	// 	Int32.create(-50) == Int32.create(5) * Int32.create(-10);

	// 	246.0 == Int32.create(123) * 2.0;
	// 	246.0 == 2.0 * Int32.create(123);

	// 	(Int32.create(0) * Int32.create(0)).isTypeInt32();
	// 	(Int32.create(0) * 1.0).isTypeFloat();
	// 	(1.0 * Int32.create(0)).isTypeFloat();

	// 	overflow(
	// 		function OVERFLOW_THROW() {
	// 			Assert.raises(() -> Int32.MAX * Int32.create(2), OverflowException);
	// 			Assert.raises(() -> Int32.MIN * Int32.create(2), OverflowException);
	// 		},
	// 		function OVERFLOW_WRAP() {
	// 			Int32.parseBits('0111 1111 1111 1111 1111 1111 1111 1111') * Int32.create(2) == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1110');
	// 			Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000') * Int32.create(2) == Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');
	// 		}
	// 	);
	// }

	// public function specDivision() {
	// 	7 == Int32.create(14) / Int32.create(2);
	// 	7 == Int32.create(14) / 2;
	// 	7 == 14 / Int32.create(2);
	// 	7 == Int32.create(14) / 2.0;
	// 	7 == 14.0 / Int32.create(2);

	// 	(Int32.create(0) / Int32.create(1)).isTypeFloat();
	// 	(Int32.create(0) / 1).isTypeFloat();
	// 	(1 / Int32.create(1)).isTypeFloat();
	// 	(Int32.create(0) / 1.0).isTypeFloat();
	// 	(1.0 / Int32.create(1)).isTypeFloat();
	// }

	// public function specModulo() {
	// 	Int32.create(7) == Int32.create(32767) % Int32.create(8);
	// 	Int32.create(-8) == Int32.create(-32768) % Int32.create(63);
	// 	Int32.create(7) == Int32.create(32767) % Int32.create(-8);

	// 	Int32.create(7) == Int32.create(32767) % 8;
	// 	Int32.create(-1) == Int32.create(-32768) % 7;
	// 	Int32.create(7) == Int32.create(32767) % -8;
	// 	Int32.create(1) == 100 % Int32.create(9);
	// 	Int32.create(1) == 100 % Int32.create(-9);
	// 	Int32.create(-1) == -100 % Int32.create(-9);

	// 	54.25 == Int32.create(32767) % 117.25;
	// 	-55.25 == Int32.create(-32768) % 117.25;
	// 	-55.25 == Int32.create(-32768) % (-117.25);
	// 	0.5 == 6.5 % Int32.create(3);
	// 	-0.5 == -6.5 % Int32.create(3);
	// 	-0.5 == -6.5 % Int32.create(-3);

	// 	(Int32.create(0) % Int32.create(0)).isTypeInt32();
	// 	(Int32.create(0) % 1).isTypeInt32();
	// 	(1 % Int32.create(0)).isTypeInt32();
	// 	(Int32.create(0) % 1.0).isTypeFloat();
	// 	(1.0 % Int32.create(0)).isTypeFloat();
	// }

	// public function specEqual() {
	// 	Int32.create(10) == Int32.create(10);
	// 	10 == Int32.create(10);
	// 	Int32.create(10) == 10;
	// 	10.0 == Int32.create(10);
	// 	Int32.create(10) == 10.0;
	// }

	// public function specNotEqual() {
	// 	Int32.create(10) != Int32.create(9);
	// 	11 != Int32.create(10);
	// 	Int32.create(10) != 11;
	// 	10.5 != Int32.create(10);
	// 	Int32.create(10) != 10.5;
	// }

	// public function specGreater() {
	// 	Int32.create(10) > Int32.create(9);
	// 	11 > Int32.create(10);
	// 	Int32.create(11) > 10;
	// 	10.5 > Int32.create(10);
	// 	Int32.create(10) > 9.5;
	// }

	// public function specGreaterOrEqual() {
	// 	Int32.create(10) >= Int32.create(9);
	// 	11 >= Int32.create(10);
	// 	Int32.create(11) >= 10;
	// 	10.5 >= Int32.create(10);
	// 	Int32.create(10) >= 9.5;
	// }

	// public function specLess() {
	// 	Int32.create(9) < Int32.create(10);
	// 	10 < Int32.create(11);
	// 	Int32.create(10) < 11;
	// 	9.5 < Int32.create(10);
	// 	Int32.create(10) < 10.5;
	// }

	// public function specLessOrEqual() {
	// 	Int32.create(9) <= Int32.create(10);
	// 	10 <= Int32.create(11);
	// 	Int32.create(10) <= 11;
	// 	9.5 <= Int32.create(10);
	// 	Int32.create(10) <= 10.5;
	// }

	// public function specNegate() {
	// 	~Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000') == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');
	// 	~Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0010') == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1101');
	// 	~Int32.parseBits('1100 0000 0000 0000 0000 0000 0000 0100') == Int32.parseBits('0011 1111 1111 1111 1111 1111 1111 1011');

	// 	(~Int32.MAX).isTypeInt32();
	// }

	// public function specAnd() {
	// 	   Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000')
	// 	 & Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111')
	// 	== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

	// 	   Int32.parseBits('1110 0000 0000 1111 0000 1111 1111 0111')
	// 	 & Int32.parseBits('0101 0011 1100 0011 1100 0011 1100 1010')
	// 	== Int32.parseBits('0100 0000 0000 0011 0000 0011 1100 0010');

	// 	   Int32.parseBits('1110 0000 1111 0000 1111 0000 1111 0111')
	// 	 & Int32.parseBits('1101 0011 1100 0011 1100 0011 1100 1010')
	// 	== Int32.parseBits('1100 0000 1100 0000 1100 0000 1100 0010');

	// 	(Int32.MAX & Int32.MAX).isTypeInt32();
	// }

	// public function specOr() {
	// 	   Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000')
	// 	 | Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111')
	// 	== Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');

	// 	   Int32.parseBits('1010 1111 0000 1111 0000 1111 0000 0101')
	// 	 | Int32.parseBits('0100 0011 1100 0011 1100 0011 1100 0010')
	// 	== Int32.parseBits('1110 1111 1100 1111 1100 1111 1100 0111');

	// 	(Int32.MAX | Int32.MAX).isTypeInt32();
	// }

	// public function specXor() {
	// 	   Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000')
	// 	 ^ Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111')
	// 	== Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');

	// 	   Int32.parseBits('1010 1111 0000 1111 0000 1111 0000 0101')
	// 	 ^ Int32.parseBits('1100 0011 1100 0011 1100 0011 1100 0011')
	// 	== Int32.parseBits('0110 1100 1100 1100 1100 1100 1100 0110');

	// 	(Int32.MAX ^ Int32.MAX).isTypeInt32();
	// }

	// public function specShiftLeft() {
	// 	Int32.parseBits('0000 1111 0000 0000 0000 0000 0000 0001') << 2 == Int32.parseBits('0011 1100 0000 0000 0000 0000 0000 0100');
	// 	Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0001') << 1 == Int32.parseBits('1001 1110 0000 0000 0000 0000 0000 0010');
	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0001') << 1 == Int32.parseBits('0001 1110 0000 0000 0000 0000 0000 0010');

	// 	Int32.parseBits('0000 1111 0000 0000 0000 0000 0000 0001') << Int32.create(2)
	// 	== Int32.parseBits('0011 1100 0000 0000 0000 0000 0000 0100');

	// 	Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0001') << Int32.create(-1)
	// 	== Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000');

	// 	   Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0001')
	// 	<< Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0001')
	// 	== Int32.parseBits('1001 1110 0000 0000 0000 0000 0000 0010');

	// 	Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0001') << -1 == Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000');
	// 	Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0010') << -1 == Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0001') << Int32.create(-1)
	// 	== Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0010') << Int32.create(-1)
	// 	== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

	// 	1 << Int32.create(2) == 1 << 2;
	// 	4 << Int32.create(1) == 4 << 1;

	// 	(Int32.MAX << Int32.MAX).isTypeInt32();
	// 	(Int32.MAX << 1).isTypeInt32();
	// 	(1 << Int32.MAX).isTypeInt();
	// }

	// public function specShiftRight() {
	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >> 1
	// 	== Int32.parseBits('1100 0111 1000 0000 0000 0000 0000 0001');

	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >> 2
	// 	== Int32.parseBits('1110 0011 1100 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0010') >> 2
	// 	== Int32.parseBits('0001 0011 1100 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >> Int32.create(1)
	// 	== Int32.parseBits('1100 0111 1000 0000 0000 0000 0000 0001');

	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >> Int32.create(2)
	// 	== Int32.parseBits('1110 0011 1100 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0010') >> Int32.create(2)
	// 	== Int32.parseBits('0001 0011 1100 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('1101 1111 0000 0000 0000 0000 0000 0101') >> -1
	// 	== Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');

	// 	Int32.parseBits('0101 1111 0000 0000 0000 0000 0000 0101') >> -1
	// 	== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

	// 	-2 >> Int32.create(10) == -2 >> 10;
	// 	35001 >> Int32.create(10) == 35001 >> 10;

	// 	(Int32.MAX >> Int32.MAX).isTypeInt32();
	// 	(Int32.MAX >> 1).isTypeInt32();
	// 	(1 >> Int32.MAX).isTypeInt();
	// }

	// public function specUnsignedShiftRight() {
	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >>> 1
	// 	== Int32.parseBits('0100 0111 1000 0000 0000 0000 0000 0001');

	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >>> 2
	// 	== Int32.parseBits('0010 0011 1100 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0010') >>> 2
	// 	== Int32.parseBits('0001 0011 1100 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >>> Int32.create(1)
	// 	== Int32.parseBits('0100 0111 1000 0000 0000 0000 0000 0001');

	// 	Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >>> Int32.create(2)
	// 	== Int32.parseBits('0010 0011 1100 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0010') >>> Int32.create(2)
	// 	== Int32.parseBits('0001 0011 1100 0000 0000 0000 0000 0000');

	// 	Int32.parseBits('1101 1111 0000 0000 0000 0000 0000 0101') >>> -1
	// 	== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0001');

	// 	Int32.parseBits('0101 1111 0000 0000 0000 0000 0000 0101') >>> -1
	// 	== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

	// 	-2 >>> Int32.create(10) == -2 >>> 10;
	// 	32001 >>> Int32.create(10) == 32001 >>> 10;

	// 	(Int32.MAX >>> Int32.MAX).isTypeInt32();
	// 	(Int32.MAX >>> 1).isTypeInt32();
	// 	(1 >>> Int32.MAX).isTypeInt();
	// }

}