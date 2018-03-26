using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Threading;
using System.Security.Principal;

namespace ConnectionPoolingDemoApp
{
	// PerfMon - SQLServer:GeneralStatistics - Logical Connections
	public static class Program
	{
		private const string connectionString1 = "Data Source=localhost; Initial Catalog=AdventureWorks2012;Integrated Security=True;";
		private const string connectionString2 = "Data Source=localhost;Initial Catalog=AdventureWorks2012;Integrated Security=True;";
		private const string connectionString3 = "Data Source=localhost;initial Catalog=AdventureWorks2012;Integrated Security=True;";

		public static void Main(string[] args)
		{
			Console.WriteLine("Vytvářím connection1, stiskněte Enter pro uzavření.");

			using (SqlConnection connection1 = new SqlConnection(connectionString1))
			{
				connection1.Open();

				Console.ReadLine();
			}

			Console.WriteLine("Vytvářím connection2, stiskněte Enter pro uzavření.");
			using (SqlConnection connection2 = new SqlConnection(connectionString2))
			{
				connection2.Open();

				Console.ReadLine();
			}

			Console.WriteLine("Vytvářím connection3, stiskněte Enter pro uzavření.");
			using (SqlConnection connection3 = new SqlConnection(connectionString3))
			{
				connection3.Open();

				Console.ReadLine();
			}
		}
	}
}
