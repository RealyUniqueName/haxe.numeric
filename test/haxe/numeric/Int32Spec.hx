package haxe.numeric;

import haxe.numeric.exceptions.InvalidArgumentException;
import haxe.numeric.exceptions.OverflowException;

class Int32Spec extends TestBase {
	static var maxInt:Int = 2147483647;
	static var minInt:Int = -2147483648;

	public function specMinMax() {
		2147483647 == Int32.MAX;
		-2147483648 == Int32.MIN;

		Int32.MAX.isTypeInt32();
		Int32.MIN.isTypeInt32();
	}

	public function specParseBits() {
		Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000').isTypeInt32();

		Int32.create(0) == Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');
		Int32.create(3) == Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0011');
		Int32.MAX == Int32.parseBits('0111 1111 1111 1111 1111 1111 1111 1111');
		Int32.MIN == Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000');
		Int32.create(-3) == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1101');
		Int32.create(-1) == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');

		Assert.raises(() -> Int32.parseBits('1234 5678 9012 3456 1234 5678 9012 3456'), InvalidArgumentException);
		Assert.raises(() -> Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 111'), InvalidArgumentException);
	}

	public function specCreate() {
		Int32.create(-0x8000).isTypeInt32();

		Int32.create(-2147483648) == Int32.MIN;
		Int32.create(2147483647) == Int32.MAX;

		#if (python || php || js || lua)
		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int32.create(maxInt + 1), OverflowException);
				Assert.raises(() -> Int32.create(minInt - 1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int32.MIN == Int32.create(maxInt + 1);
				Int32.MAX == Int32.create(minInt - 1);
			}
		);
		#end
	}

	//this test makes no sense for targets with 32bit native integers.
	#if (python || php || js || lua)
	public function specCreateBits() {
		var excessive:Int =
			#if php php.Syntax.code('0x1FFFFFFFF')
			#elseif python python.Syntax.code('0x1FFFFFFFF')
			#elseif js js.Syntax.code('0x1FFFFFFFF')
			#elseif lua untyped __lua__('0x1FFFFFFFF')
			#end;
		overflow(
			function OVERFLOW_THROW() {
				trace(excessive);
				Assert.raises(() -> Int32.createBits(excessive), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int32.create(-1) == Int32.createBits(excessive);
			}
		);
	}
	#end

	public function specToString() {
		'12345' == Int32.create(12345).toString();
		'2147483647' == Int32.MAX.toString();
		'-2147483648' == Int32.MIN.toString();
		'-1' == Int32.create(-1).toString();
		'null' == '' + (null:Null<Int32>);
	}

	public function specToInt() {
		2147483647 == Int32.MAX.toInt();
		-2147483648 == Int32.MIN.toInt();
		-1 == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111').toInt();
	}

	public function specNegative() {
		(-Int32.create(10)).isTypeInt32();

		-Int32.create(10) == Int32.create(-10);

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> -Int32.MIN, OverflowException);
			},
			function OVERFLOW_WRAP() {
				-Int32.MIN == Int32.MIN;
			}
		);
	}

	public function specPrefixIncrement() {
		var i32 = Int32.create(0);
		++i32 == Int32.create(1);
		i32 == Int32.create(1);

		(++i32).isTypeInt32();

		overflow(
			function OVERFLOW_THROW() {
				var i32 = Int32.MAX;
				try {
					++i32;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int32.MAX, i32);
				}
			},
			function OVERFLOW_WRAP() {
				var i32 = Int32.MAX;
				++i32;
				i32 == Int32.MIN;
			}
		);
	}

	public function specPostfixIncrement() {
		var i32 = Int32.create(0);
		i32++ == Int32.create(0);
		i32 == Int32.create(1);

		(i32++).isTypeInt32();

		overflow(
			function OVERFLOW_THROW() {
				var i32 = Int32.MAX;
				try {
					i32++;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int32.MAX, i32);
				}
			},
			function OVERFLOW_WRAP() {
				var i32 = Int32.MAX;
				i32++;
				i32 == Int32.MIN;
			}
		);
	}

	public function specPrefixDecrement() {
		var i32 = Int32.create(0);
		--i32 == Int32.create(-1);
		i32 == Int32.create(-1);

		(--i32).isTypeInt32();

		overflow(
			function OVERFLOW_THROW() {
				var i32 = Int32.MIN;
				try {
					--i32;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int32.MIN, i32);
				}
			},
			function OVERFLOW_WRAP() {
				var i32 = Int32.MIN;
				--i32;
				i32 == Int32.MAX;
			}
		);
	}

	public function specPostfixDecrement() {
		var i32 = Int32.create(0);
		i32-- == Int32.create(0);
		i32 == Int32.create(-1);

		(i32--).isTypeInt32();

		overflow(
			function OVERFLOW_THROW() {
				var i32 = Int32.MIN;
				try {
					i32--;
					Assert.fail();
				} catch(e:OverflowException) {
					Assert.equals(Int32.MIN, i32);
				}
			},
			function OVERFLOW_WRAP() {
				var i32 = Int32.MIN;
				i32--;
				i32 == Int32.MAX;
			}
		);
	}

	public function specAddition() {
		Int32.create(-1) == Int32.MAX + Int32.MIN;

		1235.0 == Int32.create(1234) + 1.0;

		(Int32.create(0) + Int32.create(0)).isTypeInt32();
		(Int32.create(0) + 1.0).isTypeFloat();
		(1.0 + Int32.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int32.MAX + Int32.create(1), OverflowException);
				Assert.raises(() -> Int32.MIN + Int32.create(-1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int32.MAX + Int32.create(1) == Int32.MIN;
				Int32.MIN + Int32.create(-1) == Int32.MAX;
			}
		);
	}

	public function specSubtraction() {
		Int32.create(0) == Int32.MAX - Int32.MAX;
		Int32.create(0) == Int32.MIN - Int32.MIN;

		124.0 == Int32.create(123) - (-1.0);
		-122.0 == 1.0 - Int32.create(123);

		(Int32.create(0) - Int32.create(0)).isTypeInt32();
		(Int32.create(0) - 1.0).isTypeFloat();
		(1.0 - Int32.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int32.MAX - Int32.create(-1), OverflowException);
				Assert.raises(() -> Int32.MIN - Int32.create(1), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int32.MAX - Int32.create(-1) == Int32.MIN;
				Int32.MIN - Int32.create(1) == Int32.MAX;
			}
		);
	}

	public function specMultiplication() {
		Int32.create(50) == Int32.create(5) * Int32.create(10);
		Int32.create(-50) == Int32.create(5) * Int32.create(-10);

		246.0 == Int32.create(123) * 2.0;
		246.0 == 2.0 * Int32.create(123);

		(Int32.create(0) * Int32.create(0)).isTypeInt32();
		(Int32.create(0) * 1.0).isTypeFloat();
		(1.0 * Int32.create(0)).isTypeFloat();

		overflow(
			function OVERFLOW_THROW() {
				Assert.raises(() -> Int32.MAX * Int32.create(2), OverflowException);
				Assert.raises(() -> Int32.MIN * Int32.create(2), OverflowException);
			},
			function OVERFLOW_WRAP() {
				Int32.parseBits('0111 1111 1111 1111 1111 1111 1111 1111') * Int32.create(2) == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1110');
				Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000') * Int32.create(2) == Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');
			}
		);
	}

	public function specDivision() {
		7 == Int32.create(14) / Int32.create(2);
		7 == Int32.create(14) / 2;
		7 == 14 / Int32.create(2);
		7 == Int32.create(14) / 2.0;
		7 == 14.0 / Int32.create(2);

		(Int32.create(0) / Int32.create(1)).isTypeFloat();
		(Int32.create(0) / 1).isTypeFloat();
		(1 / Int32.create(1)).isTypeFloat();
		(Int32.create(0) / 1.0).isTypeFloat();
		(1.0 / Int32.create(1)).isTypeFloat();
	}

	public function specModulo() {
		Int32.create(7) == Int32.create(32767) % Int32.create(8);
		Int32.create(-8) == Int32.create(-32768) % Int32.create(63);
		Int32.create(7) == Int32.create(32767) % Int32.create(-8);

		Int32.create(7) == Int32.create(32767) % 8;
		Int32.create(-1) == Int32.create(-32768) % 7;
		Int32.create(7) == Int32.create(32767) % -8;
		Int32.create(1) == 100 % Int32.create(9);
		Int32.create(1) == 100 % Int32.create(-9);
		Int32.create(-1) == -100 % Int32.create(-9);

		54.25 == Int32.create(32767) % 117.25;
		-55.25 == Int32.create(-32768) % 117.25;
		-55.25 == Int32.create(-32768) % (-117.25);
		0.5 == 6.5 % Int32.create(3);
		-0.5 == -6.5 % Int32.create(3);
		-0.5 == -6.5 % Int32.create(-3);

		(Int32.create(0) % Int32.create(0)).isTypeInt32();
		(Int32.create(0) % 1).isTypeInt32();
		(1 % Int32.create(0)).isTypeInt32();
		(Int32.create(0) % 1.0).isTypeFloat();
		(1.0 % Int32.create(0)).isTypeFloat();
	}

	public function specEqual() {
		Int32.create(10) == Int32.create(10);
		10 == Int32.create(10);
		Int32.create(10) == 10;
		10.0 == Int32.create(10);
		Int32.create(10) == 10.0;
	}

	public function specNotEqual() {
		Int32.create(10) != Int32.create(9);
		11 != Int32.create(10);
		Int32.create(10) != 11;
		10.5 != Int32.create(10);
		Int32.create(10) != 10.5;
	}

	public function specGreater() {
		Int32.create(10) > Int32.create(9);
		11 > Int32.create(10);
		Int32.create(11) > 10;
		10.5 > Int32.create(10);
		Int32.create(10) > 9.5;
	}

	public function specGreaterOrEqual() {
		Int32.create(10) >= Int32.create(9);
		11 >= Int32.create(10);
		Int32.create(11) >= 10;
		10.5 >= Int32.create(10);
		Int32.create(10) >= 9.5;
	}

	public function specLess() {
		Int32.create(9) < Int32.create(10);
		10 < Int32.create(11);
		Int32.create(10) < 11;
		9.5 < Int32.create(10);
		Int32.create(10) < 10.5;
	}

	public function specLessOrEqual() {
		Int32.create(9) <= Int32.create(10);
		10 <= Int32.create(11);
		Int32.create(10) <= 11;
		9.5 <= Int32.create(10);
		Int32.create(10) <= 10.5;
	}

	public function specNegate() {
		~Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000') == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');
		~Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0010') == Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1101');
		~Int32.parseBits('1100 0000 0000 0000 0000 0000 0000 0100') == Int32.parseBits('0011 1111 1111 1111 1111 1111 1111 1011');

		(~Int32.MAX).isTypeInt32();
	}

	public function specAnd() {
		   Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000')
		 & Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111')
		== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

		   Int32.parseBits('1110 0000 0000 1111 0000 1111 1111 0111')
		 & Int32.parseBits('0101 0011 1100 0011 1100 0011 1100 1010')
		== Int32.parseBits('0100 0000 0000 0011 0000 0011 1100 0010');

		   Int32.parseBits('1110 0000 1111 0000 1111 0000 1111 0111')
		 & Int32.parseBits('1101 0011 1100 0011 1100 0011 1100 1010')
		== Int32.parseBits('1100 0000 1100 0000 1100 0000 1100 0010');

		(Int32.MAX & Int32.MAX).isTypeInt32();
	}

	public function specOr() {
		   Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000')
		 | Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111')
		== Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');

		   Int32.parseBits('1010 1111 0000 1111 0000 1111 0000 0101')
		 | Int32.parseBits('0100 0011 1100 0011 1100 0011 1100 0010')
		== Int32.parseBits('1110 1111 1100 1111 1100 1111 1100 0111');

		(Int32.MAX | Int32.MAX).isTypeInt32();
	}

	public function specXor() {
		   Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000')
		 ^ Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111')
		== Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');

		   Int32.parseBits('1010 1111 0000 1111 0000 1111 0000 0101')
		 ^ Int32.parseBits('1100 0011 1100 0011 1100 0011 1100 0011')
		== Int32.parseBits('0110 1100 1100 1100 1100 1100 1100 0110');

		(Int32.MAX ^ Int32.MAX).isTypeInt32();
	}

	public function specShiftLeft() {
		Int32.parseBits('0000 1111 0000 0000 0000 0000 0000 0001') << 2 == Int32.parseBits('0011 1100 0000 0000 0000 0000 0000 0100');
		Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0001') << 1 == Int32.parseBits('1001 1110 0000 0000 0000 0000 0000 0010');
		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0001') << 1 == Int32.parseBits('0001 1110 0000 0000 0000 0000 0000 0010');

		Int32.parseBits('0000 1111 0000 0000 0000 0000 0000 0001') << Int32.create(2)
		== Int32.parseBits('0011 1100 0000 0000 0000 0000 0000 0100');

		Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0001') << Int32.create(-1)
		== Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000');

		   Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0001')
		<< Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0001')
		== Int32.parseBits('1001 1110 0000 0000 0000 0000 0000 0010');

		Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0001') << -1 == Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000');
		Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0010') << -1 == Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

		Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0001') << Int32.create(-1)
		== Int32.parseBits('1000 0000 0000 0000 0000 0000 0000 0000');

		Int32.parseBits('1100 1111 0000 0000 0000 0000 0000 0010') << Int32.create(-1)
		== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

		1 << Int32.create(2) == 1 << 2;
		4 << Int32.create(1) == 4 << 1;

		(Int32.MAX << Int32.MAX).isTypeInt32();
		(Int32.MAX << 1).isTypeInt32();
		(1 << Int32.MAX).isTypeInt();
	}

	public function specShiftRight() {
		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >> 1
		== Int32.parseBits('1100 0111 1000 0000 0000 0000 0000 0001');

		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >> 2
		== Int32.parseBits('1110 0011 1100 0000 0000 0000 0000 0000');

		Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0010') >> 2
		== Int32.parseBits('0001 0011 1100 0000 0000 0000 0000 0000');

		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >> Int32.create(1)
		== Int32.parseBits('1100 0111 1000 0000 0000 0000 0000 0001');

		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >> Int32.create(2)
		== Int32.parseBits('1110 0011 1100 0000 0000 0000 0000 0000');

		Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0010') >> Int32.create(2)
		== Int32.parseBits('0001 0011 1100 0000 0000 0000 0000 0000');

		Int32.parseBits('1101 1111 0000 0000 0000 0000 0000 0101') >> -1
		== Int32.parseBits('1111 1111 1111 1111 1111 1111 1111 1111');

		Int32.parseBits('0101 1111 0000 0000 0000 0000 0000 0101') >> -1
		== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

		-2 >> Int32.create(10) == -2 >> 10;
		35001 >> Int32.create(10) == 35001 >> 10;

		(Int32.MAX >> Int32.MAX).isTypeInt32();
		(Int32.MAX >> 1).isTypeInt32();
		(1 >> Int32.MAX).isTypeInt();
	}

	public function specUnsignedShiftRight() {
		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >>> 1
		== Int32.parseBits('0100 0111 1000 0000 0000 0000 0000 0001');

		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >>> 2
		== Int32.parseBits('0010 0011 1100 0000 0000 0000 0000 0000');

		Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0010') >>> 2
		== Int32.parseBits('0001 0011 1100 0000 0000 0000 0000 0000');

		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >>> Int32.create(1)
		== Int32.parseBits('0100 0111 1000 0000 0000 0000 0000 0001');

		Int32.parseBits('1000 1111 0000 0000 0000 0000 0000 0010') >>> Int32.create(2)
		== Int32.parseBits('0010 0011 1100 0000 0000 0000 0000 0000');

		Int32.parseBits('0100 1111 0000 0000 0000 0000 0000 0010') >>> Int32.create(2)
		== Int32.parseBits('0001 0011 1100 0000 0000 0000 0000 0000');

		Int32.parseBits('1101 1111 0000 0000 0000 0000 0000 0101') >>> -1
		== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0001');

		Int32.parseBits('0101 1111 0000 0000 0000 0000 0000 0101') >>> -1
		== Int32.parseBits('0000 0000 0000 0000 0000 0000 0000 0000');

		-2 >>> Int32.create(10) == -2 >>> 10;
		32001 >>> Int32.create(10) == 32001 >>> 10;

		(Int32.MAX >>> Int32.MAX).isTypeInt32();
		(Int32.MAX >>> 1).isTypeInt32();
		(1 >>> Int32.MAX).isTypeInt();
	}

}