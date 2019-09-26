import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.Tools;

class MacroTools {
	macro static public function isTypeInt(value:Expr):Expr {
		return isType(value, 'Int');
	}

	macro static public function isTypeFloat(value:Expr):Expr {
		return isType(value, 'Float');
	}

	macro static public function isTypeBool(value:Expr):Expr {
		return isType(value, 'Float');
	}

	macro static public function isTypeInt8(value:Expr):Expr {
		return isType(value, 'haxe.numeric.Int8');
	}

	macro static public function isTypeUInt8(value:Expr):Expr {
		return isType(value, 'haxe.numeric.UInt8');
	}

#if macro
	static function isType(value:Expr, type:String):Expr {
		if(Context.typeof(value).toString() != type) {
			var error = value.toString() + ' is not of $type type. Actual type: ' + Context.typeof(value).toString();
			return macro @:pos(value.pos) utest.Assert.fail($v{error});
		} else {
			return macro @:pos(value.pos) utest.Assert.pass();
		}
	}
#end
}