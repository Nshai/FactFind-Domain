SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyOwnerById]
@PolicyOwnerId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PolicyOwnerId AS [PolicyOwner!1!PolicyOwnerId], 
    T1.CRMContactId AS [PolicyOwner!1!CRMContactId], 
    T1.PolicyDetailId AS [PolicyOwner!1!PolicyDetailId], 
    T1.ConcurrencyId AS [PolicyOwner!1!ConcurrencyId]
  FROM TPolicyOwner T1

  WHERE (T1.PolicyOwnerId = @PolicyOwnerId)

  ORDER BY [PolicyOwner!1!PolicyOwnerId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
