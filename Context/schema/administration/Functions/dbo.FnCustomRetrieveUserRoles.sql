SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create  FUNCTION  [dbo].[FnCustomRetrieveUserRoles](@UserId bigint)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @Result varchar(1000) = (
        SELECT STRING_AGG(B.Identifier, ', ') WITHIN GROUP (ORDER BY CASE WHEN A.RoleId = U.ActiveRole THEN 0 ELSE 1 END) 
        FROM TMembership A
        INNER JOIN TUser U ON A.UserId = U.UserId
        INNER JOIN TRole B ON A.RoleId = B.RoleId
        WHERE A.UserId = @UserId
    );

    RETURN ISNULL(@Result, '')
END
GO
