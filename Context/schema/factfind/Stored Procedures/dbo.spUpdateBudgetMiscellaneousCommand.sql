SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE OR ALTER PROCEDURE [dbo].[spUpdateBudgetMiscellaneousCommand] 
	@UserId BIGINT, -- execution user id
	@BudgetMiscellaneousId INT,
	@BudgetMiscellaneousForClienId BIGINT,
	@AssetsNonDisclosure bit = null,
	@AnyAssets bit = null,
	@AnyLiabilities bit = null,
	@AssetLiabilityNotes varchar(MAX),
	@BudgetNotes varchar(MAX),
	@LiabilitiesNonDisclosure bit = null,
	@LiabilitiesRepayment bit = null,
	@LiabilitiesWhyNot varchar(MAX),
	@LiabilityNotes varchar(MAX),
	@RepaymentDetails varchar(MAX),
	@Tax varchar(MAX),
	@TotalEarnings money
AS

UPDATE TBudgetMiscellaneous
SET    
	CRMContactId = @BudgetMiscellaneousForClienId,
	AssetsNonDisclosure = @AssetsNonDisclosure,
	AnyAssets = @AnyAssets,
	AnyLiabilities = @AnyLiabilities,
	AssetLiabilityNotes = @AssetLiabilityNotes,
	BudgetNotes = @BudgetNotes,
	LiabilitiesNonDisclosure = @LiabilitiesNonDisclosure,
	LiabilitiesRepayment = @LiabilitiesRepayment,
	LiabilitiesWhyNot = @LiabilitiesWhyNot,
	LiabilityNotes = @LiabilityNotes,
	RepaymentDetails = @RepaymentDetails,
	Tax = @Tax,
	TotalEarnings = @TotalEarnings
OUTPUT
	deleted.TotalEarnings,
	deleted.Tax,
	deleted.BudgetMiscellaneousId,
	deleted.CRMContactId,
	deleted.AssetsNonDisclosure,
	deleted.AnyAssets,
	deleted.AnyLiabilities,
	deleted.AssetLiabilityNotes,
	deleted.BudgetNotes,
	deleted.LiabilitiesNonDisclosure,
	deleted.LiabilitiesRepayment,
	deleted.LiabilitiesWhyNot,
	deleted.LiabilityNotes,
	deleted.RepaymentDetails,
	deleted.ConcurrencyId,
	'U',
    GETUTCDATE(),
    @UserId
INTO TBudgetMiscellaneousAudit
	  ([TotalEarnings]
	  ,[Tax]
	  ,[BudgetMiscellaneousId]
	  ,[CRMContactId]
	  ,[AssetsNonDisclosure]
	  ,[AnyAssets]
	  ,[AnyLiabilities]
	  ,[AssetLiabilityNotes]
	  ,[BudgetNotes]
	  ,[LiabilitiesNonDisclosure]
	  ,[LiabilitiesRepayment]
	  ,[LiabilitiesWhyNot]
	  ,[LiabilityNotes]
	  ,[RepaymentDetails]
	  ,[ConcurrencyId]
	  ,[STAMPACTION]
      ,[STAMPDATETIME]
      ,[STAMPUSER])
WHERE BudgetMiscellaneousId = @BudgetMiscellaneousId

GO
