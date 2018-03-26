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
			// dále lze øešit i støedník, komentáøe, atp.
		}
	}
}