using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;

namespace SqlInjectionApp
{
	public static class Program
	{
		public static void Main(string[] args)
		{
			// Vypíšeme počet účtů, které mají zůstatek vyšší než X.

			Console.Write("Minimalni zustatek? ");
			string vstup = Console.ReadLine();
			
			string sql = "SELECT COUNT(*) FROM Ucet WHERE Zustatek > @MinimalniZustatek";
	
			using (SqlConnection conn = new SqlConnection("Data Source=localhost;Initial Catalog=WugDemo;Integrated Security=True"))	// nastavit ConnectionString !!!
			{
				conn.Open();
				SqlCommand cmd = new SqlCommand(sql, conn);
				cmd.Parameters.AddWithValue("@MinimalniZustatek", vstup);  // ještě lépe s konverzí na číselný typ Convert.ToDecimal(vstup)

				Console.WriteLine(cmd.ExecuteScalar());
			}

			Console.ReadLine();
		}
	}
}
