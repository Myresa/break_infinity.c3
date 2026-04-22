module genpow10;
import std::io;
import std::collections;

fn int main(String[] args)
{
	io::print("double[*] powersOf10 = {");
	for (long i = -324 + 1; i <= 308; i++)
	{
		String tmp = "1e".tconcat(string::tformat("%d", i));
		io::print(tmp);
		/*double? dtmp = tmp.to_double();

		fault excuse = @catch(dtmp);
		if (excuse)
		{
			io::printfn("Excuse found: %s", excuse);
			return 1;
		}
		if (catch dtmp) return 1;

		io::print(dtmp);*/

		if (i != 308) io::print(",");
	}
	io::printn("};");

	return 0;
}