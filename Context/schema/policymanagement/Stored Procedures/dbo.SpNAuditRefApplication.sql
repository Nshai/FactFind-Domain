SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRefApplication]
	@StampUser varchar (255),
	@RefApplicationId bigint,
	@StampAction char(1)
AS

INSERT INTO TRefApplicationAudit 
( ApplicationName, ApplicationShortName, RefApplicationTypeId, ImageName, 
		IsArchived, ConcurrencyId, 
	RefApplicationId, StampAction, StampDateTime, StampUser) 
Select ApplicationName, ApplicationShortName, RefApplicationTypeId, ImageName, 
		IsArchived, ConcurrencyId, 
	RefApplicationId, @StampAction, GetDate(), @StampUser
FROM TRefApplication
WHERE RefApplicationId = @RefApplicationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
