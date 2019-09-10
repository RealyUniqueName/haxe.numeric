package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

class Int8Test extends utest.Test {
	public function testConstructor() {
		Assert.equals(Int8.MIN, Int8.create(-0xFF));
		Assert.equals(Int8.MAX, Int8.create(0xFF));
		Assert.raises(() -> Int8.create(0xFF + 1), OverflowException);
		Assert.raises(() -> Int8.create(-0xFF - 1), OverflowException);
	}

	public function specNegative() {
		-Int8.MAX == Int8.MIN;
	}

	public function specPrefixIncrement() {
		var i8 = Int8.create(0);
		++i8 == Int8.create(1);
		i8 == Int8.create(1);

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

		var i8 = Int8.MIN;
		try {
			i8--;
			Assert.fail();
		} catch(e:OverflowException) {
			Assert.equals(Int8.MIN, i8);
		}
	}

	public function specAddition() {
		Int8.create(0) == Int8.MAX + Int8.MIN;
		Assert.raises(() -> Int8.MAX + Int8.create(1), OverflowException);
		Assert.raises(() -> Int8.MIN + Int8.create(-1), OverflowException);

		256 == Int8.MAX + 1;
		-256 == -1 + Int8.MIN;
		256.0 == Int8.MAX + 1.0;
		-256.0 == -1.0 + Int8.MIN;
	}

	public function specSubtraction() {
		Int8.create(0) == Int8.MAX - Int8.MAX;
		Int8.create(0) == Int8.MIN - Int8.MIN;
		Assert.raises(() -> Int8.MAX - Int8.create(-1), OverflowException);
		Assert.raises(() -> Int8.MIN - Int8.create(1), OverflowException);

		256 == Int8.MAX - (-1);
		256 == 1 - Int8.MIN;
		256.0 == Int8.MAX - (-1.0);
		256.0 == 1.0 - Int8.MIN;
	}

	public function specMultiplication() {
		Int8.MAX == Int8.MIN * Int8.create(-1);
		Int8.MIN == Int8.MAX * Int8.create(-1);
		Assert.raises(() -> Int8.MAX * Int8.create(2), OverflowException);
		Assert.raises(() -> Int8.MIN * Int8.create(2), OverflowException);

		510 == Int8.MAX * 2;
		-510 == 2 * Int8.MIN;
		510.0 == Int8.MAX * 2.0;
		-510.0 == 2.0 * Int8.MIN;
	}

	public function specDivision() {
		7 == Int8.create(14) / 2;
		7 == 14 / Int8.create(2);
		7 == Int8.create(14) / 2.0;
		7 == 14.0 / Int8.create(2);
	}

	public function specModulo() {
		Int8.create(7) == Int8.MAX % Int8.create(8);
		Int8.create(-7) == Int8.MIN % Int8.create(8);
		Int8.create(7) == Int8.MAX % Int8.create(-8);

		Int8.create(7) == Int8.MAX % 8;
		Int8.create(-7) == Int8.MIN % 8;
		Int8.create(7) == Int8.MAX % -8;
		Int8.create(1) == 100 % Int8.create(9);
		Int8.create(1) == 100 % Int8.create(-9);
		Int8.create(-1) == -100 % Int8.create(-9);

		20.5 == Int8.MAX % 117.25;
		-20.5 == Int8.MIN % 117.25;
		-20.5 == Int8.MIN % (-117.25);
		0.5 == 6.5 % Int8.create(3);
		-0.5 == -6.5 % Int8.create(3);
		-0.5 == -6.5 % Int8.create(-3);
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
}