SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefProductLinkByMaxId]
	@StampUser varchar (255),
	@MaxId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefProductLinkAudit 
( ApplicationLinkId, RefProductTypeId, ProductGroupData, ProductTypeData, 
		IsArchived, ConcurrencyId, 
	RefProductLinkId, StampAction, StampDateTime, StampUser) 
Select ApplicationLinkId, RefProductTypeId, ProductGroupData, ProductTypeData, 
		IsArchived, ConcurrencyId, 
	RefProductLinkId, @StampAction, GetDate(), @StampUser
FROM TRefProductLink
WHERE RefProductLinkId > @MaxId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
