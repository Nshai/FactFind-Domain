SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateRetainerPaymentStatusAsId]
	@StampUser varchar (255), 
	@RetainerId bigint, 
	@PaymentStatus varchar (50), 
	@PaymentStatusNotes varchar (250) = Null, 
	@PaymentStatusDate datetime, 
	@UpdatedUserId bigint, 
	@ConcurrencyId bigint = 1
AS

Declare @RetainerPaymentStatusId Bigint

Insert Into dbo.TRetainerPaymentStatus
(RetainerId, PaymentStatus, PaymentStatusNotes, PaymentStatusDate, UpdatedUserId, ConcurrencyId)
Values(@RetainerId, @PaymentStatus, @PaymentStatusNotes, @PaymentStatusDate, @UpdatedUserId, @ConcurrencyId)

Select @RetainerPaymentStatusId = SCOPE_IDENTITY()
Insert Into dbo.TRetainerPaymentStatusAudit
(RetainerPaymentStatusId, RetainerId, PaymentStatus, PaymentStatusNotes, PaymentStatusDate, UpdatedUserId, 
ConcurrencyId, StampAction, StampDateTime, StampUser)
Select [RetainerPaymentStatus].RetainerPaymentStatusId, [RetainerPaymentStatus].RetainerId, [RetainerPaymentStatus].PaymentStatus, [RetainerPaymentStatus].PaymentStatusNotes, [RetainerPaymentStatus].PaymentStatusDate, [RetainerPaymentStatus].UpdatedUserId, 
[RetainerPaymentStatus].ConcurrencyId, 'C', getdate(), @StampUser
From TRetainerPaymentStatus [RetainerPaymentStatus]
Where RetainerPaymentStatusId = @RetainerPaymentStatusId

Select @RetainerPaymentStatusId
GO
