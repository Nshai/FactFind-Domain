SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20231120    Salini M        SE-2825        Default Service Status
*/
CREATE PROCEDURE [dbo].[SpNAuditRefServiceStatus]
	@StampUser varchar (255),
	@RefServiceStatusId int,
	@StampAction char(1)
AS

INSERT INTO TRefServiceStatusAudit 
( ServiceStatusName, IndigoClientId,IsArchived, ConcurrencyId, 
	RefServiceStatusId, StampAction, StampDateTime, StampUser, GroupId, IsPropagated,ReportFrequency,ReportStartDateType,ReportStartDate,IsDefault) 
Select ServiceStatusName, IndigoClientId,IsArchived, ConcurrencyId, 
	RefServiceStatusId, @StampAction, GetDate(), @StampUser, GroupId, IsPropagated,ReportFrequency,ReportStartDateType,ReportStartDate,IsDefault
FROM TRefServiceStatus
WHERE RefServiceStatusId = @RefServiceStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
