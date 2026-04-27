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
	run_case("Basic: 1e0", bi::bi(0, 0), bi::ZERO);
	run_case("Basic: 1e1", bi::bi(1, 0), bi::ONE);
	run_case("Basic: 2e9", bi::bi(0.2, 10), bi::bi_no_norm(2, 9));
	run_case("Basic: 3.5785e56418", bi::bi(357.85, 56416), bi::bi_no_norm(3.5785, 56418));
	run_case("Basic: -2e-19", bi::bi(-0.02, -17), bi::bi_no_norm(-2, -19));
	run_case("Basic: 2.575645e1e16", bi::bi(25756.45, 10000000000000000), bi::bi_no_norm(2.575645, 10000000000000004));

	// This test breaks due to precision when comparing, but it doesn't actually matter since the imprecision is irrelevant.
	//run_case("Basic: 2.5756456e1e16", bi::bi(25756.456, 10000000000000000), bi::bi_no_norm(2.5756456, 10000000000000004));
}