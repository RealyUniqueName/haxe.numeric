class TestBase extends utest.Test {
	inline function overflow(throws:()->Void, wraps:()->Void) {
		#if OVERFLOW_THROW
			throws();
		#elseif OVERFLOW_WRAP
			wraps();
		#elseif debug
			throws();
		#else
			wraps();
		#end
	}
}