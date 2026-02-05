SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveContactAddressById]
@ContactAddressId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ContactAddressId AS [ContactAddress!1!ContactAddressId], 
    T1.ContactId AS [ContactAddress!1!ContactId], 
    T1.AddressId AS [ContactAddress!1!AddressId], 
    T1.ConcurrencyId AS [ContactAddress!1!ConcurrencyId]
  FROM TContactAddress T1

  WHERE (T1.ContactAddressId = @ContactAddressId)

  ORDER BY [ContactAddress!1!ContactAddressId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
