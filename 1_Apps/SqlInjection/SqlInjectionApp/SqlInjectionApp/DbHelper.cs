using System;
using System.Collections.Generic;

namespace SqlInjectionApp
{
	public static class DbHelper
	{
		public static string SanitizeSqlParameter(string vstup)
		{
			// double-quoting
			return vstup = vstup.Replace("'", "''");
			// d�le lze �e�it i st�edn�k, koment��e, atp.
		}
	}
}