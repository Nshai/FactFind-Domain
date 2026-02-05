SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFeePaymentStatusAsId]
	@StampUser varchar (255), 
	@FeeId bigint, 
	@PaymentStatus varchar (50), 
	@PaymentStatusNotes varchar (250) = Null, 
	@PaymentStatusDate datetime, 
	@UpdatedUserId bigint, 
	@ConcurrencyId bigint = 1
AS

Declare @FeePaymentStatusId Bigint

Insert Into dbo.TFeePaymentStatus
(FeeId, PaymentStatus, PaymentStatusNotes, PaymentStatusDate, UpdatedUserId, ConcurrencyId)
Values(@FeeId, @PaymentStatus, @PaymentStatusNotes, @PaymentStatusDate, @UpdatedUserId, @ConcurrencyId)

Select @FeePaymentStatusId = SCOPE_IDENTITY()
Insert Into dbo.TFeePaymentStatusAudit
(FeePaymentStatusId, FeeId, PaymentStatus, PaymentStatusNotes, PaymentStatusDate, UpdatedUserId, 
ConcurrencyId, StampAction, StampDateTime, StampUser)
Select [FeePaymentStatus].FeePaymentStatusId, [FeePaymentStatus].FeeId, [FeePaymentStatus].PaymentStatus, [FeePaymentStatus].PaymentStatusNotes, [FeePaymentStatus].PaymentStatusDate, [FeePaymentStatus].UpdatedUserId, 
[FeePaymentStatus].ConcurrencyId, 'C', getdate(), @StampUser
From TFeePaymentStatus [FeePaymentStatus]
Where FeePaymentStatusId = @FeePaymentStatusId

Select @FeePaymentStatusId
GO
