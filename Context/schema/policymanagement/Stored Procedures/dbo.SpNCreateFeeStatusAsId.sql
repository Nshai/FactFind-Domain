SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFeeStatusAsId]
	@StampUser varchar (255), 
	@FeeId bigint, 
	@Status varchar (50), 
	@StatusNotes varchar (250) = Null, 
	@StatusDate datetime, 
	@UpdatedUserId bigint, 
	@ConcurrencyId bigint = 1
AS

Declare @FeeStatusId Bigint

Insert Into dbo.TFeeStatus
(FeeId, Status, StatusNotes, StatusDate, UpdatedUserId, ConcurrencyId)
Values(@FeeId, @Status, @StatusNotes, @StatusDate, @UpdatedUserId, @ConcurrencyId)

Select @FeeStatusId = SCOPE_IDENTITY()
Insert Into dbo.TFeeStatusAudit
(FeeStatusId, FeeId, Status, StatusNotes, StatusDate, UpdatedUserId, 
ConcurrencyId, StampAction, StampDateTime, StampUser)
Select [FeeStatus].FeeStatusId, [FeeStatus].FeeId, [FeeStatus].Status, [FeeStatus].StatusNotes, [FeeStatus].StatusDate, [FeeStatus].UpdatedUserId, 
[FeeStatus].ConcurrencyId, 'C', getdate(), @StampUser
From TFeeStatus [FeeStatus]
Where FeeStatusId = @FeeStatusId

Select @FeeStatusId
GO
