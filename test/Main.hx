import utest.Runner;
import utest.ui.Report;
import haxe.numeric.*;

class Main {
	static function main() {
		var runner = new Runner();
		var report = Report.create(runner);
		report.displayHeader = AlwaysShowHeader;
		report.displaySuccessResults = NeverShowSuccessResults;
		runner.run();
	}
}