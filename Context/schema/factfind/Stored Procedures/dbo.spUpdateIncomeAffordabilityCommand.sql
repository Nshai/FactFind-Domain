SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spUpdateIncomeAffordabilityCommand] 
	@UserId BIGINT, -- execution user id
	@IncomeId BIGINT,
	@HasIncludeInAffordability BIT

AS
    UPDATE a
	SET HasIncludeInAffordability = @HasIncludeInAffordability
	OUTPUT		
	   deleted.[DetailedincomebreakdownId]
      ,deleted.[CRMContactId]
      ,deleted.[CRMContactId2]
      ,deleted.[Owner]
      ,deleted.[Description]
      ,deleted.[Amount]
      ,deleted.[HasIncludeInAffordability]
      ,deleted.[Frequency]
      ,deleted.[IncomeType]
      ,deleted.[ConcurrencyId]
      ,deleted.[GrossOrNet]
      ,deleted.[EmploymentDetailIdValue]
      ,deleted.[NetAmount]
      ,deleted.[StartDate]
      ,deleted.[EndDate]
      ,deleted.[PolicyBusinessId]
      ,deleted.[WithdrawalId]
	  ,'U'
	  ,GETUTCDATE()
	  ,@UserId
	INTO TDetailedIncomeBreakdownAudit
	  ([DetailedincomebreakdownId]
      ,[CRMContactId]
      ,[CRMContactId2]
      ,[Owner]
      ,[Description]
      ,[Amount]
      ,[HasIncludeInAffordability]
      ,[Frequency]
      ,[IncomeType]
      ,[ConcurrencyId]
      ,[GrossOrNet]
      ,[EmploymentDetailIdValue]
      ,[NetAmount]
      ,[StartDate]
      ,[EndDate]
      ,[PolicyBusinessId]
      ,[WithdrawalId]
	  ,[STAMPACTION]
      ,[STAMPDATETIME]
      ,[STAMPUSER])
	FROM TDetailedIncomeBreakdown a
    WHERE a.DetailedincomebreakdownId = @IncomeId
GO
