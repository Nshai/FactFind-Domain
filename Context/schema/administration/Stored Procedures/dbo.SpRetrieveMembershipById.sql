SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveMembershipById]
@MembershipId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.MembershipId AS [Membership!1!MembershipId], 
    T1.UserId AS [Membership!1!UserId], 
    T1.RoleId AS [Membership!1!RoleId], 
    T1.ConcurrencyId AS [Membership!1!ConcurrencyId]
  FROM TMembership T1

  WHERE (T1.MembershipId = @MembershipId)

  ORDER BY [Membership!1!MembershipId]

  FOR XML EXPLICIT

END
RETURN (0)






GO
