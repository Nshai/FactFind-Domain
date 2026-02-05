SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE OR ALTER PROCEDURE [dbo].[spCreateBudgetMiscellaneousCommand] 
	@UserId BIGINT, -- execution user id
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

INSERT INTO TBudgetMiscellaneous (
	TotalEarnings,
	Tax,
	CRMContactId,
	AssetsNonDisclosure,
	AnyAssets,
	AnyLiabilities,
	AssetLiabilityNotes,
	BudgetNotes,
	LiabilitiesNonDisclosure,
	LiabilitiesRepayment,
	LiabilitiesWhyNot,
	LiabilityNotes,
	RepaymentDetails
)
OUTPUT
	inserted.TotalEarnings,
	inserted.Tax,
	inserted.BudgetMiscellaneousId,
	inserted.CRMContactId,
	inserted.AssetsNonDisclosure,
	inserted.AnyAssets,
	inserted.AnyLiabilities,
	inserted.AssetLiabilityNotes,
	inserted.BudgetNotes,
	inserted.LiabilitiesNonDisclosure,
	inserted.LiabilitiesRepayment,
	inserted.LiabilitiesWhyNot,
	inserted.LiabilityNotes,
	inserted.RepaymentDetails,
	inserted.ConcurrencyId,
	'C',
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
VALUES (    
	@TotalEarnings,
	@Tax,
	@BudgetMiscellaneousForClienId,
	@AssetsNonDisclosure,
	@AnyAssets,
	@AnyLiabilities,
	@AssetLiabilityNotes,
	@BudgetNotes,
	@LiabilitiesNonDisclosure,
	@LiabilitiesRepayment,
	@LiabilitiesWhyNot,
	@LiabilityNotes,
	@RepaymentDetails)

GO
