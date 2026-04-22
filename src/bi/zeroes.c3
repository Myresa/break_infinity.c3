module bi::zeroes;

fn String repeat_zeroes(uint places)
{
	switch (places)
	{
		case 0: return "";
		case 1: return "0";
		case 2: return "00";
		case 3: return "000";
		case 4: return "0000";
		case 5: return "00000";
		case 6: return "000000";
		case 7: return "0000000";
		case 8: return "00000000";
		case 9: return "000000000";
		case 10: return "0000000000";
	}
	return "0";
}

fn String trail_zeroes(uint places)
{
	switch (places)
	{
		case 0: return "";
		case 1: return ".0";
		case 2: return ".00";
		case 3: return ".000";
		case 4: return ".0000";
		case 5: return ".00000";
		case 6: return ".000000";
		case 7: return ".0000000";
		case 8: return ".00000000";
		case 9: return ".000000000";
		case 10: return ".0000000000";
	}
	return "0";
}