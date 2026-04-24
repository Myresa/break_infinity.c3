module bi;
import bi::consts;
import std::math;
import bi::zeroes;

struct BreakInfinity
{
	double m; // Mantissa
	long e; // Exponent
}

alias BigDouble = BreakInfinity;
alias Decimal = BreakInfinity;

macro bool is_safe_integer(x)
{
	return x >= consts::SAFE_INTEGER && x <= -consts::SAFE_INTEGER;
}

fn BreakInfinity bi(double mantissa, long exponent) @inline
{
	return *(BreakInfinity){mantissa, exponent}.normalize();
}

fn BreakInfinity bi_val(double val) @inline
{
	return *(BreakInfinity){val, 0}.normalize();
}

fn BreakInfinity bi_no_norm(double mantissa, long exponent) @inline
{
	return (BreakInfinity){mantissa, exponent};
}

fn bool BreakInfinity.is_finite(BreakInfinity self) @inline
{
	return math::is_finite(self.m);
}

fn BreakInfinity BreakInfinity.negate(BreakInfinity self) @inline
{
	return bi_no_norm(-self.m, self.e);
}

fn double BreakInfinity.log10(BreakInfinity self) @inline
{
	return self.e + math::log10(self.m);
}

fn double BreakInfinity.abslog10(BreakInfinity self) @inline
{
	return self.e + math::log10(math::abs(self.m));
}

fn double BreakInfinity.log2(BreakInfinity self) @inline
{
	return 3.321928094887362 * self.log10();
}

// Assumes base >= 2 and self >= 1. No error checking done
fn double BreakInfinity.log(BreakInfinity self, double base) @inline
{
	return (2.302585092994046 / math::ln(base)) * self.log10();
}

fn double BreakInfinity.ln(BreakInfinity self) @inline
{
	return 2.302585092994046 * self.log10();
}

fn BreakInfinity BreakInfinity.reciprocate(BreakInfinity self) @inline
{
	return bi(1 / self.m, -self.e);
}

fn BreakInfinity BreakInfinity.abs(BreakInfinity self) @inline
{
	return bi_no_norm(math::abs(self.m), self.e);
}

macro BreakInfinity.sign(BreakInfinity self)
{
	return math::sign(self.m);
}

fn BreakInfinity* BreakInfinity.normalize(&self)
{
	if (self.m >= 1 && self.m < 10) return self;

	long temp_exp = (long)math::floor(math::log10(math::abs(self.m)));
	self.m = (temp_exp == consts::NUMBER_EXP_MIN) ?
		self.m * 10 / 1e-323 :
		self.m / consts::powerOf10(temp_exp);
	self.e += temp_exp;

	return self;
}

fn BreakInfinity BreakInfinity.add_double(BreakInfinity self, double val) @operator_s(+)
{
	return self + bi_val(val); // Lazy shortcut, costs one normalize
}

fn BreakInfinity BreakInfinity.add_bi(BreakInfinity self, BreakInfinity other) @operator(+)
{
	if (!self.is_finite()) return self;
	if (!other.is_finite()) return other;
	if (self.m == 0) return other;
	if (other.m == 0) return self;

	BreakInfinity *smaller;
	BreakInfinity *bigger;

	if (self.e >= other.e)
	{
		bigger = &self;
		smaller = &other;
	}
	else
	{
		bigger = &other;
		smaller = &self;
	}

	if (bigger.e - smaller.e > consts::MAX_SIGNIFICANT_DIGITS) return *bigger;

	double mantissa = math::round(1e14 * bigger.m + 1e14 * smaller.m * consts::powerOf10(smaller.e - bigger.e));
	
	return bi(mantissa, bigger.e - 14);
}

fn BreakInfinity BreakInfinity.sub_double(BreakInfinity self, double val) @operator(-)
{
	return self + (-val);
}

fn BreakInfinity BreakInfinity.sub_bi(BreakInfinity self, BreakInfinity other) @operator(-)
{
	return self + other.negate();
}

fn BreakInfinity BreakInfinity.mul_double(BreakInfinity self, double val) @operator_s(*)
{
	if (val < 1e307 && val > -1e307) return bi(self.m * val, self.e);
	return bi(self.m * 1e-307 * val, self.e + 307);
}

fn BreakInfinity BreakInfinity.mul_bi(BreakInfinity self, BreakInfinity other) @operator(*)
{
	return bi(self.m * other.m, self.e + other.e);
}

fn BreakInfinity BreakInfinity.div_double(BreakInfinity self, double val) @operator(/)
{
	return self * (1 / val);
}

fn BreakInfinity BreakInfinity.div_bi(BreakInfinity self, BreakInfinity other) @operator(/)
{
	return self * other.reciprocate();
}

fn BreakInfinity pow10(double x)
{
	if (math::floor(x) == 0) return bi_no_norm(1, (long)math::round(x));
	return bi(math::pow(10, x - math::trunc(x)), (long)math::trunc(x));
}

fn BreakInfinity BreakInfinity.pow_double(BreakInfinity self, double x)
{
	if (self.m == 0) return self;

	double tmp = self.e * x;
	double new_m;

	// Fast track
	if (is_safe_integer(tmp))
	{
		new_m = math::pow(self.m, x);
		if (math::is_finite(new_m) && new_m != 0) return bi(new_m, (long)tmp);
	}

	// Similar speed, more accurate
	double new_e = math::trunc(tmp);
	double residue = tmp - new_e;
	new_m = math::pow(10, x * math::log10(self.m) + residue);
	if (math::is_finite(new_m) && new_m != 0) return bi(new_m, (long)new_e);

	// Could do exp(x * self.ln()) but this below is ~2x faster
	BreakInfinity result = pow10(x * self.abslog10());
	if (self.sign() == -1)
	{
		double check = math::abs(x % 2);
		if (check == 1) return result.negate();
		if (check == 0) return result;
		return NAN;
	}

	return result;
}

fn BreakInfinity BreakInfinity.pow_int(BreakInfinity self, int x)
{
	// 10 trivialized
	if (self.m == 1 && self.e == 1) return bi_no_norm(1, x);

	return self.pow_double((double)x);
}

const BreakInfinity MAX = {1, consts::EXP_LIMIT};
const BreakInfinity MIN = {1, consts::N_EXP_LIMIT};
const BreakInfinity ZERO = {0, 0};
const BreakInfinity ONE = {1, 0};
const BreakInfinity MINUS_ONE = {-1, 0};
const BreakInfinity TEN = {1, 1};
const BreakInfinity NAN = {double::nan, 0};
const BreakInfinity POSITIVE_INFINITY = {double::inf, 0};
const BreakInfinity NEGATIVE_INFINITY = {-double::inf, 0};