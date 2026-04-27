module bi_test::basic;

import bi;

import std::io;

struct Expected
{
	double mant;
	long exp;
}

fn void run_case(BreakInfinity val, BreakInfinity expect)
{
	assert(val == expect);
}

fn void basic_bi() @test
{
	run_case(bi::bi(0, 0), bi::ZERO);
	run_case(bi::bi(1, 0), bi::ONE);
}