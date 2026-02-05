SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomCalculateAge](@DOB date)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
    SELECT 
        Age = DATEDIFF(YEAR, @DOB, GETDATE())
              - CASE
                  WHEN DATEADD(YEAR, DATEDIFF(YEAR, @DOB, GETDATE()), @DOB) > GETDATE()
                  THEN 1
                  ELSE 0
                END;


GO
