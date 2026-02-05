SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveIndigoClientByGuid] 
	@Guid varchar(50)
AS


Select 1 AS Tag,
	NULL AS PARENT,

	T1.IndigoClientId as [IndigoClient!1!IndigoClientId],
	T1.Identifier as [IndigoClient!1!Identifier],
	T1.Guid as [IndigoClient!1!Guid]
FROM TIndigoClient T1
Where T1.Guid = @Guid

FOR XML EXPLICIT
GO
