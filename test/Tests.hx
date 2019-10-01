import utest.Runner;
import utest.ui.Report;
import haxe.numeric.*;

class Tests {
	static function main() {
		var runner = new Runner();
		runner.addCase(new NumericSpec());
		runner.addCase(new Int8Spec());
		runner.addCase(new UInt8Spec());
		runner.addCase(new Int16Spec());
		runner.addCase(new Int8UInt8Spec());
		runner.addCase(new Int8Int16Spec());
		runner.addCase(new Int16UInt8Spec());
		var report = Report.create(runner);
		report.displayHeader = AlwaysShowHeader;
		report.displaySuccessResults = NeverShowSuccessResults;
		runner.run();
	}
}