SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveIndigoClientSib]
AS
SELECT
	A.Sib,
	A.IndigoClientId,
	A.GroupId
FROM 
	TIndigoClientSibCombined A
FOR XML RAW('IndigoClientSib')
GO
