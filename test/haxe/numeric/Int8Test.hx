package haxe.numeric;

import haxe.numeric.exceptions.OverflowException;

class Int8Test extends utest.Test {
	public function testConstructor() {
		Assert.equals(Int8.MIN, Int8.create(-0xF));
		Assert.equals(Int8.MAX, Int8.create(0xF));
		Assert.raises(() -> Int8.create(0xF + 1), OverflowException);
		Assert.raises(() -> Int8.create(-0xF - 1), OverflowException);
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

		16 == Int8.MAX + 1;
		-16 == -1 + Int8.MIN;
	}

	// public function specSubtraction() {
	// 	Int8.create(0) == Int8.MAX - Int8.MAX;
	// 	Int8.create(0) == Int8.MIN - Int8.MIN;
	// 	Assert.raises(() -> Int8.MAX - Int8.create(-1), OverflowException);
	// 	Assert.raises(() -> Int8.MIN - Int8.create(1), OverflowException);

	// 	-16 == Int8.MAX - (-1);
	// 	16 == 1 - Int8.MIN;
	// }

	// public function specMultiplication() {
	// 	Int8.MAX == Int8.MIN * Int8.create(-1);
	// 	Int8.MIN == Int8.MAX * Int8.create(-1);
	// 	Assert.raises(() -> Int8.MAX * Int8.create(2), OverflowException);
	// 	Assert.raises(() -> Int8.MIN * Int8.create(2), OverflowException);
	// }
}