import utest.Runner;
import utest.ui.Report;
import haxe.numeric.*;

class Main {
	static function main() {
		var runner = new Runner();
		runner.addCase(new Int8Spec());
		runner.addCase(new UInt8Spec());
		runner.addCase(new Int8UInt8Spec());
		var report = Report.create(runner);
		report.displayHeader = AlwaysShowHeader;
		report.displaySuccessResults = NeverShowSuccessResults;
		runner.run();
	}
}