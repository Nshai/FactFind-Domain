SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomRetrieveCurrentPensionByOwnerAndType]
	@CRMOwnerId bigint,
	@PlanTypeId bigint
AS

DECLARE @PolicyBusinessId bigint

SELECT
		@PolicyBusinessId = Pb.PolicyBusinessId
		--P.PensionInfoId
	FROM
		TPolicyBusiness Pb WITH(NOLOCK)
		JOIN TPensionInfo P ON P.PolicyBusinessId = Pb.PolicyBusinessId AND P.IsCurrent = 1
		JOIN TStatusHistory Sh ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND Sh.CurrentStatusFg = 1
		JOIN TStatus S ON S.StatusId = Sh.StatusId AND S.IntelligentOfficeStatusType = 'In Force'
		JOIN TPolicyDetail Pd WITH(NOLOCK) ON Pd.PolicyDetailId = Pb.PolicyDetailId
		JOIN TPolicyOwner Po WITH(NOLOCK) ON Po.PolicyDetailId = Pd.PolicyDetailId AND Po.CRMContactId = @CRMOwnerId
		JOIN TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId
		JOIN TRefPlanType2ProdSubType P2P WITH(NOLOCK) ON P2P.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId
		JOIN TRefPlanType Pt WITH(NOLOCK) ON Pt.RefPlanTypeId = P2P.RefPlanTypeId AND Pt.RefPlanTypeId = @PlanTypeId

IF (@PolicyBusinessId <> NUlL AND @PolicyBusinessId > 0)
		SELECT @PolicyBusinessId
ELSE
	BEGIN
		SET @PolicyBusinessId = 0
		SELECT @PolicyBusinessId
	END
GO
