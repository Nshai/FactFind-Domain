SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create PROCEDURE [dbo].[SpNAuditRefInterviewType]
	@StampUser varchar (255),
	@RefInterviewTypeId int,
	@StampAction char(1)
AS

INSERT INTO TRefInterviewTypeAudit 
( RefInterviewTypeId,InterviewType,ConcurrencyId, StampAction, StampDateTime, StampUser) 
Select RefInterviewTypeId,InterviewType,ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM TRefInterviewType
WHERE RefInterviewTypeId = @RefInterviewTypeId
GO