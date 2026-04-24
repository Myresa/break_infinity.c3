module bi_test;

import bi;
import bi::format;

import std::io;

fn void run_case(BreakInfinity val, PrettyConfig pcfg, String expected)
{
	@pool()
	{
		String ret = val.tto_pretty(pcfg);
		io::printn(ret);
		assert(ret == expected);
	};
}

fn void pretty_basic_pure_sci() @test
{
	PrettyConfig pcfg = format::PURE_SCIENTIFIC;

	run_case(bi::bi(3.245555, 0), pcfg, "3.245e0");
	run_case(bi::bi(9.999999, 0), pcfg, "9.999e0");
}