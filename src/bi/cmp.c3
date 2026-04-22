module bi;

// Costly since it converts to bi through a normalize, avoid
fn bool BreakInfinity.eq_double(BreakInfinity self, double val) @operator_s(==)
{
	return self == bi_val(val);
}

fn bool BreakInfinity.eq_bi(BreakInfinity self, BreakInfinity other) @operator(==)
{
	return self.m == other.m && self.e == other.e;
}

// Costly since it converts to bi through a normalize, avoid
fn bool BreakInfinity.lt_double(BreakInfinity self, double val) @operator(<)
{
	return self < bi_val(val);
}

fn bool BreakInfinity.lt_bi(BreakInfinity self, BreakInfinity other) @operator(<)
{
	if (self.m == 0) return other.m > 0;
	if (other.m == 0) return self.m <= 0;
	if (self.e == other.e) return self.m < other.m;
	if (self.e > 0) return other.m > 0 && self.e < other.e;
	return other.m > 0 || self.e > other.e;
}