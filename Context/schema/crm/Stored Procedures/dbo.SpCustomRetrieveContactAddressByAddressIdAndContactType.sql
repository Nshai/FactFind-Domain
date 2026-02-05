SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveContactAddressByAddressIdAndContactType]
	@AddressId bigint,
	@RefContactType varchar(255)
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ContactAddressId AS [ContactAddress!1!ContactAddressId], 
    T1.ContactId AS [ContactAddress!1!ContactId], 
    T1.AddressId AS [ContactAddress!1!AddressId], 
    T1.ConcurrencyId AS [ContactAddress!1!ConcurrencyId], 
    NULL AS [Contact!2!ContactId], 
    NULL AS [Contact!2!IndClientId], 
    NULL AS [Contact!2!CRMContactId], 
    NULL AS [Contact!2!RefContactType], 
    NULL AS [Contact!2!Description], 
    NULL AS [Contact!2!Value], 
    NULL AS [Contact!2!DefaultFg], 
    NULL AS [Contact!2!ConcurrencyId]
  FROM TContactAddress T1

  WHERE (T1.AddressId = @AddressId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.ContactAddressId, 
    T1.ContactId, 
    T1.AddressId, 
    T1.ConcurrencyId, 
    T2.ContactId, 
    T2.IndClientId, 
    T2.CRMContactId, 
    T2.RefContactType, 
    ISNULL(T2.Description, ''), 
    T2.Value, 
    T2.DefaultFg, 
    T2.ConcurrencyId
  FROM TContact T2
  INNER JOIN TContactAddress T1
  ON T2.ContactId = T1.ContactId

  WHERE (T1.AddressId = @AddressId)
  AND T2.RefContactType = @RefContactType

  ORDER BY [ContactAddress!1!ContactAddressId], [Contact!2!ContactId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
