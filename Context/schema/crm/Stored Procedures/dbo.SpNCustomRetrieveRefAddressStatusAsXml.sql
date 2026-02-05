SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRefAddressStatusAsXml]	
AS
SELECT	
	RefAddressStatusId, 
	AddressStatus
FROM TRefAddressStatus
ORDER BY [RefAddressStatusId]
FOR XML RAW('AddressStatus')
GO
