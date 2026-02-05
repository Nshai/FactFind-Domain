SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spNAuditActionPlanWithdrawal]

    @StampUser varchar (255),
	@ActionPlanWithdrawalId bigint,
	@StampAction char(1)
AS

	INSERT INTO [TActionPlanWithdrawalAudit]
           ([ActionPlanWithdrawalId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser]
           ,[ActionPlanId]
           ,[WithdrawalAmount]
           ,[WithdrawalType]
           ,[WithdrawalFrequency]
           ,[TransferDestinationActionPlanContributionId]
		   ,[IsIncreased]
		   ,[IsEncashment]
           )
     SELECT 
			[ActionPlanWithdrawalId]
           ,@StampAction
           ,GetDate()
           ,@StampUser
           ,[ActionPlanId]
           ,[WithdrawalAmount]
           ,[WithdrawalType]
           ,[WithdrawalFrequency]
           ,[TransferDestinationActionPlanContributionId]
		   ,[IsIncreased]
		   ,[IsEncashment]
     FROM TActionPlanWithdrawal
	 WHERE ActionPlanWithdrawalId = @ActionPlanWithdrawalId
           
GO
