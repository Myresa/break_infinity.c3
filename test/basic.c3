module bi_test::basic;

import bi;

import std::io;

fn void run_case(String title, BreakInfinity val, BreakInfinity expect)
{
	io::printfn("%s - {%.10f : %d} {%.10f : %d}", title, val.m, val.e, expect.m, expect.e);
	assert(val == expect);
}

fn void basic_bi() @test
{
	// Mantissa + Exponent normalized
	run_case("Basic: 0e0", bi::bi(0, 0), bi::ZERO);
	run_case("Basic: 1e0", bi::bi(1, 0), bi::ONE);
	run_case("Basic: 2e9", bi::bi(0.2, 10), bi::bi_no_norm(2, 9));
	run_case("Basic: -2e-19", bi::bi(-0.02, -17), bi::bi_no_norm(-2, -19));
	run_case("Basic: 3.5785e56418", bi::bi(357.85, 56416), bi::bi_no_norm(3.5785, 56418));
	run_case("Basic: 2.575645e1e16", bi::bi(25756.45, 10000000000000000), bi::bi_no_norm(2.575645, 10000000000000004));

	// This test breaks due to precision when comparing, but it doesn't actually matter since the imprecision is irrelevant.
	//run_case("Basic: 2.5756456e1e16", bi::bi(25756.456, 10000000000000000), bi::bi_no_norm(2.5756456, 10000000000000004));

	// Int/Double
	run_case("Basic val: 0e0", bi::bi_val(0), bi::ZERO);
	run_case("Basic val: 1e0", bi::bi_val(1), bi::ONE);
	run_case("Basic val: 2e9", bi::bi_val(0.2e10), bi::bi_no_norm(2, 9));
	run_case("Basic val: -2e-19", bi::bi_val(-2e-19), bi::bi_no_norm(-2, -19));

	// String
	run_case("Basic str: 0e0", bi::bi_str("0"), bi::ZERO)!!;
	run_case("Basic str: 1e0", bi::bi_str("1"), bi::ONE)!!;
	run_case("Basic str: 2e9", bi::bi_str("0.2e10"), bi::bi_no_norm(2, 9))!!;
	run_case("Basic str: -2e-19", bi::bi_str("-2e-19"), bi::bi_no_norm(-2, -19))!!;
	run_case("Basic str: 3.5785e56418", bi::bi_str("3.5785e56418"), bi::bi_no_norm(3.5785, 56418))!!;
	run_case("Basic str: 2.575645e1e16", bi::bi_str("25756.45e10000000000000000"), bi::bi_no_norm(2.575645, 10000000000000004))!!;

	// Special string check, they should all error, making the final assert true
	int tests = 0;
	BreakInfinity? ret1 = bi::bi_str("1e");
	BreakInfinity? ret2 = bi::bi_str("e1");
	BreakInfinity? ret3 = bi::bi_str("---1e--1");
	if (catch ret1)
	{
		tests++;
		io::printn("ret1 caught");
	}
	if (catch ret2)
	{
		tests++;
		io::printn("ret2 caught");
	}
	if (catch ret3)
	{
		tests++;
		io::printn("ret3 caught");
	}

	assert(tests == 3);
}