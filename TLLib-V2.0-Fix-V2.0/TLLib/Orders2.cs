using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace TLLib
{
    public class Orders2
    {
        string connectionString = Common.ConnectionString;
        DBNull dbNULL = DBNull.Value;

        public int Orders2Insert(
            string Order2ID,
            string UserName,
            string CreateDate,
            string CompanyName,
            string FullName,
            string Address,
            string HomePhone,
            string CellPhone,
            string Email,
            string OrderStatusID
        )
        {
            try
            {
                var scon = new SqlConnection(connectionString);
                var cmd = new SqlCommand("usp_Orders2_Insert", scon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Order2ID", string.IsNullOrEmpty(Order2ID) ? dbNULL : (object)Order2ID);
                cmd.Parameters.AddWithValue("@UserName", string.IsNullOrEmpty(UserName) ? dbNULL : (object)UserName);
                cmd.Parameters.AddWithValue("@CreateDate", string.IsNullOrEmpty(CreateDate) ? dbNULL : (object)CreateDate);
                cmd.Parameters.AddWithValue("@CompanyName", string.IsNullOrEmpty(CompanyName) ? dbNULL : (object)CompanyName);
                cmd.Parameters.AddWithValue("@FullName", string.IsNullOrEmpty(FullName) ? dbNULL : (object)FullName);
                cmd.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(Address) ? dbNULL : (object)Address);
                cmd.Parameters.AddWithValue("@HomePhone", string.IsNullOrEmpty(HomePhone) ? dbNULL : (object)HomePhone);
                cmd.Parameters.AddWithValue("@CellPhone", string.IsNullOrEmpty(CellPhone) ? dbNULL : (object)CellPhone);
                cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(Email) ? dbNULL : (object)Email);
                cmd.Parameters.AddWithValue("@OrderStatusID", string.IsNullOrEmpty(OrderStatusID) ? dbNULL : (object)OrderStatusID);
                SqlParameter errorCodeParam = new SqlParameter("@ErrorCode", null);
                errorCodeParam.Size = 4;
                errorCodeParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(errorCodeParam);
                scon.Open();
                int success = cmd.ExecuteNonQuery();
                scon.Close();

                if (errorCodeParam.Value.ToString() != "0")
                    throw new Exception("Stored Procedure 'usp_Orders2_Insert' reported the ErrorCode : " + errorCodeParam.Value.ToString());

                return success;
            }
            //catch (SqlException ex)
            //{
            //    throw new Exception(ex.Number.ToString());
            //}
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public int Orders2Update(
            string Order2ID,
            string UserName,
            string CreateDate,
            string CompanyName,
            string FullName,
            string Address,
            string HomePhone,
            string CellPhone,
            string Email,
            string OrderStatusID
        )
        {
            try
            {
                var scon = new SqlConnection(connectionString);
                var cmd = new SqlCommand("usp_Orders2_Update", scon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Order2ID", string.IsNullOrEmpty(Order2ID) ? dbNULL : (object)Order2ID);
                cmd.Parameters.AddWithValue("@UserName", string.IsNullOrEmpty(UserName) ? dbNULL : (object)UserName);
                cmd.Parameters.AddWithValue("@CreateDate", string.IsNullOrEmpty(CreateDate) ? dbNULL : (object)CreateDate);
                cmd.Parameters.AddWithValue("@CompanyName", string.IsNullOrEmpty(CompanyName) ? dbNULL : (object)CompanyName);
                cmd.Parameters.AddWithValue("@FullName", string.IsNullOrEmpty(FullName) ? dbNULL : (object)FullName);
                cmd.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(Address) ? dbNULL : (object)Address);
                cmd.Parameters.AddWithValue("@HomePhone", string.IsNullOrEmpty(HomePhone) ? dbNULL : (object)HomePhone);
                cmd.Parameters.AddWithValue("@CellPhone", string.IsNullOrEmpty(CellPhone) ? dbNULL : (object)CellPhone);
                cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(Email) ? dbNULL : (object)Email);
                cmd.Parameters.AddWithValue("@OrderStatusID", string.IsNullOrEmpty(OrderStatusID) ? dbNULL : (object)OrderStatusID);
                SqlParameter errorCodeParam = new SqlParameter("@ErrorCode", null);
                errorCodeParam.Size = 4;
                errorCodeParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(errorCodeParam);
                scon.Open();
                int success = cmd.ExecuteNonQuery();
                scon.Close();

                if (errorCodeParam.Value.ToString() != "0")
                    throw new Exception("Stored Procedure 'usp_Orders2_Update' reported the ErrorCode : " + errorCodeParam.Value.ToString());

                return success;
            }
            catch (SqlException ex)
            {
                throw new Exception(ex.Number.ToString());
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public int Order2QuickUpdate(
            string Order2ID,
            string OrderStatusID
        )
        {
            try
            {
                var scon = new SqlConnection(connectionString);
                var cmd = new SqlCommand("usp_Orders2_QuickUpdate", scon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Order2ID", string.IsNullOrEmpty(Order2ID) ? dbNULL : (object)Order2ID);
                cmd.Parameters.AddWithValue("@OrderStatusID", string.IsNullOrEmpty(OrderStatusID) ? dbNULL : (object)OrderStatusID);

                SqlParameter errorCodeParam = new SqlParameter("@ErrorCode", null);
                errorCodeParam.Size = 4;
                errorCodeParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(errorCodeParam);
                scon.Open();
                int success = cmd.ExecuteNonQuery();
                scon.Close();

                if (errorCodeParam.Value.ToString() != "0")
                    throw new Exception("Stored Procedure 'usp_Orders2_QuickUpdate' reported the ErrorCode : " + errorCodeParam.Value.ToString());

                return success;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public int Orders2Delete(
            string Order2ID
        )
        {
            try
            {
                var scon = new SqlConnection(connectionString);
                var cmd = new SqlCommand("usp_Orders2_Delete", scon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Order2ID", string.IsNullOrEmpty(Order2ID) ? dbNULL : (object)Order2ID);
                SqlParameter errorCodeParam = new SqlParameter("@ErrorCode", null);
                errorCodeParam.Size = 4;
                errorCodeParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(errorCodeParam);
                scon.Open();
                int success = cmd.ExecuteNonQuery();
                scon.Close();

                if (errorCodeParam.Value.ToString() != "0")
                    throw new Exception("Stored Procedure 'usp_Orders2_Delete' reported the ErrorCode : " + errorCodeParam.Value.ToString());

                return success;
            }
            catch (SqlException ex)
            {
                throw new Exception(ex.Number.ToString());
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public DataTable Orders2SelectAll(
            string Keyword,
            string Order2ID,
            string UserName,
            string FromDate,
            string ToDate,
            string CompanyName,
            string FullName,
            string Address,
            string HomePhone,
            string CellPhone,
            string Email,
            string OrderStatusID
        )
        {
            try
            {
                var dt = new DataTable();
                var scon = new SqlConnection(connectionString);
                var cmd = new SqlCommand("usp_Orders2_SelectAll", scon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Keyword", string.IsNullOrEmpty(Keyword) ? dbNULL : (object)Keyword);
                cmd.Parameters.AddWithValue("@Order2ID", string.IsNullOrEmpty(Order2ID) ? dbNULL : (object)Order2ID);
                cmd.Parameters.AddWithValue("@UserName", string.IsNullOrEmpty(UserName) ? dbNULL : (object)UserName);
                cmd.Parameters.AddWithValue("@FromDate", string.IsNullOrEmpty(FromDate) ? dbNULL : (object)FromDate);
                cmd.Parameters.AddWithValue("@ToDate", string.IsNullOrEmpty(ToDate) ? dbNULL : (object)ToDate);
                cmd.Parameters.AddWithValue("@CompanyName", string.IsNullOrEmpty(CompanyName) ? dbNULL : (object)CompanyName);
                cmd.Parameters.AddWithValue("@FullName", string.IsNullOrEmpty(FullName) ? dbNULL : (object)FullName);
                cmd.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(Address) ? dbNULL : (object)Address);
                cmd.Parameters.AddWithValue("@HomePhone", string.IsNullOrEmpty(HomePhone) ? dbNULL : (object)HomePhone);
                cmd.Parameters.AddWithValue("@CellPhone", string.IsNullOrEmpty(CellPhone) ? dbNULL : (object)CellPhone);
                cmd.Parameters.AddWithValue("@Email", string.IsNullOrEmpty(Email) ? dbNULL : (object)Email);
                cmd.Parameters.AddWithValue("@OrderStatusID", string.IsNullOrEmpty(OrderStatusID) ? dbNULL : (object)OrderStatusID);
                var errorCodeParam = new SqlParameter("@ErrorCode", null);
                errorCodeParam.Size = 4;
                errorCodeParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(errorCodeParam);
                var sda = new SqlDataAdapter(cmd);
                sda.Fill(dt);

                if (errorCodeParam.Value.ToString() != "0")
                    throw new Exception("Stored Procedure 'usp_Orders2_SelectAll' reported the ErrorCode : " + errorCodeParam.Value.ToString());

                return dt;
            }
            catch (SqlException ex)
            {
                throw new Exception(ex.Number.ToString());
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public DataTable Orders2SelectOne(
            string Order2ID
        )
        {
            try
            {
                var dt = new DataTable();
                var scon = new SqlConnection(connectionString);
                var cmd = new SqlCommand("usp_Orders2_SelectOne", scon);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Order2ID", string.IsNullOrEmpty(Order2ID) ? dbNULL : (object)Order2ID);
                SqlParameter errorCodeParam = new SqlParameter("@ErrorCode", null);
                errorCodeParam.Size = 4;
                errorCodeParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(errorCodeParam);
                var sda = new SqlDataAdapter(cmd);
                sda.Fill(dt);

                if (errorCodeParam.Value.ToString() != "0")
                    throw new Exception("Stored Procedure 'usp_Orders2_SelectOne' reported the ErrorCode : " + errorCodeParam.Value.ToString());

                return dt;
            }
            catch (SqlException ex)
            {
                throw new Exception(ex.Number.ToString());
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
