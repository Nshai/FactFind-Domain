SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefData]
	@StampUser varchar (255),
	@RefDataId int,
	@StampAction char(1)
AS

INSERT INTO TRefDataAudit ( Name, Type, Property, RegionCode, Attributes, TenantId, Archived,
	RefDataId, StampAction, StampDateTime, StampUser) 
Select Name, Type, Property, RegionCode, Attributes, TenantId, Archived,  
       RefDataId, @StampAction, GetDate(), @StampUser
FROM TRefData
WHERE RefDataId = @RefDataId
   
GO
