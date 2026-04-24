module bi::format;
import bi::consts;
import bi::zeroes;
import std::math;

struct PrettyConfig
{
	uint places; // Number of places to display (3 -> 1.234)
	uint exponent_cutoff; // Number of digits before switching to e notation (999 -> 1e3, 9999 -> 1e4)
	bool digits_remove_places; // Remove places as digits grow larger (1.234 -> 12.34 -> 123.4 -> 1234 -> 12340)
}

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

fn String format_decimals(double m_dec, PrettyConfig pcfg) @private
{
	DString tmp;
	uint i = 0;
	char conv;

	if (pcfg.places == 0) return "";

	tmp.tinit();
	tmp.append_char('.');
	while (i < pcfg.places)
	{
		m_dec *= 10.0;
		conv = (char)m_dec;
		m_dec -= conv;
		tmp.append_char(conv + '0');
		i++;
	}
	return tmp.str_view();
}

fn String BreakInfinity.tto_pretty(BreakInfinity self, PrettyConfig pcfg)
{
	return self.to_pretty(tmem, pcfg);
}

fn String BreakInfinity.to_pretty(BreakInfinity self, Allocator allocator, PrettyConfig pcfg)
{
	if (!self.is_finite()) return string::format(allocator, "%f", self.m);

	if (math::abs(self.e) >= pcfg.exponent_cutoff)
	{
		double m_int = math::trunc(self.m);
		double m_dec = math::abs(self.m) - m_int;

		@pool()
		{
			// the '.' is managed in format_decimals()
			return string::format(allocator, "%d%se%d", (long)m_int, format_decimals(m_dec, pcfg), self.e);
		};
	}
	
	return "TODO";
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
		return string::format(allocator, "0%se0", zeroes::trail_zeroes(places));
	}

	if (self.e > consts::NUMBER_EXP_MIN && self.e < consts::NUMBER_EXP_MAX)
	{
		return string::format(allocator, "%fe%d", self.to_number(), self.e);
	}

	if (places > consts::MAX_SIGNIFICANT_DIGITS) places = consts::MAX_SIGNIFICANT_DIGITS;

	int len = places + 1;
	int num_digits = (int)math::max(1.0, math::ceil(math::log10(math::abs(self.m))));
	double rounded = math::round(self.m * math::pow(10, len - num_digits)) * math::pow(10, num_digits - len);

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

	if (self.e <= consts::N_EXP_LIMIT || self.m == 0)
	{
		return string::format(allocator, "0%s", zeroes::trail_zeroes(places));
	}

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

	if (self.e > consts::NUMBER_EXP_MAX) return self.m > 0 ? double::inf : -double::inf;

	if (self.e < consts::NUMBER_EXP_MIN) return 0;

	if (self.e == consts::NUMBER_EXP_MIN) return self.m > 0 ? 5e-324 : -5e-324;

	double result = self.m * consts::powerOf10(self.e);
	if (!math::is_finite(self.m) || self.e < 0) return result;

	double result_rounded = math::round(result);
	if (math::abs(result_rounded - result) < consts::ROUND_TOLERANCE) return result_rounded;

	return result;
}

const PrettyConfig PURE_SCIENTIFIC = (PrettyConfig){3, 0, false};
const PrettyConfig AD_SCIENTIFIC = (PrettyConfig){3, 3, true};