module bi;
import bi::consts;
import std::math;

fn long BreakInfinity.decimal_places(BreakInfinity self)
{
	if (!self.is_finite()) return (long)double::nan;
	if (self.e >= consts::MAX_SIGNIFICANT_DIGITS) return 0;

	double mant = self.m;
	double e = 1;
	long places = -self.e;

	// Ugh this is bad
	while (math::abs(math::round(mant * e) / e - mant) > consts::ROUND_TOLERANCE)
	{
		e *= 10;
		places++;
	}

	return places > 0 ? places : 0;
}

fn String BreakInfinity.tto_exponential(BreakInfinity self, uint places)
{
	return self.to_exponential(tmem, places);
}

fn String BreakInfinity.to_exponential(BreakInfinity self, Allocator allocator, uint places)
{
	if (!self.is_finite()) return string::format(allocator, "%f", self.m);

	if (self.e <= consts::N_EXP_LIMIT || self.m == 0)
	{
		return "0".concat(allocator, zeroes::trail_zeroes(places)).concat(allocator, "e0");
	}
	return "TODO";
}

fn String BreakInfinity.tto_string(BreakInfinity self, uint places)
{
	return self.to_string(tmem, places);
}

fn String BreakInfinity.to_string(BreakInfinity self, Allocator allocator, uint places)
{
	return "TODO";
}

fn String BreakInfinity.tto_fixed(BreakInfinity self, uint places)
{
	return self.to_fixed(tmem, places);
}

fn String BreakInfinity.to_fixed(BreakInfinity self, Allocator allocator, uint places)
{
	if (!self.is_finite()) return string::format(allocator, "%f", self.m);

	if (self.e <= consts::N_EXP_LIMIT || self.m == 0) return "0".concat(allocator, zeroes::trail_zeroes(places));

	if (self.e >= consts::MAX_SIGNIFICANT_DIGITS)
	{
		return "TODO";
	}
	// return this.toNumber().toFixed(places);
	return "TODO";
}

fn double BreakInfinity.to_number(BreakInfinity self)
{
	if (!self.is_finite()) return self.m;

	if (self.e > consts::NUMBER_EXP_MAX) return self.m > 0 ? POSITIVE_INFINITY : NEGATIVE_INFINITY;

	if (self.e < consts::NUMBER_EXP_MIN) return 0;

	if (self.e == NUMBER_EXP_MIN) return self.m > 0 ? 5e-324 : -5e324;

	double result = self.m * consts::powerOf10(self.e);
	if (!math::is_finite(self.m) || self.e < 0) return result;

	result_rounded = math::round(result);
	if (math::abs(result_rounded - result) < consts::ROUND_TOLERANCE) return result_rounded;

	return result;
}