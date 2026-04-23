module bi;
import bi::consts;
import std::math;

fn long BreakInfinity.decimal_places(&self)
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

fn String BreakInfinity.to_string(&self, uint places)
{
	return "TODO";
}

fn String BreakInfinity.to_fixed(&self, uint places)
{
	if (!self.is_finite()) return string::tformat("%f", self.m); //TEST

	if (self.e <= consts::N_EXP_LIMIT || self.m == 0) return "0".tconcat(zeroes::trail_zeroes(places));

	if (self.e >= consts::MAX_SIGNIFICANT_DIGITS)
	{
		return "TODO";
	}
	// return this.toNumber().toFixed(places);
	return "TODO";
}