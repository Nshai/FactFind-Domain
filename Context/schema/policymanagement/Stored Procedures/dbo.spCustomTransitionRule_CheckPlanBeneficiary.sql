SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckPlanBeneficiary]
  @PolicyBusinessId INT,
  @ErrorMessage VARCHAR(512) OUTPUT
AS
BEGIN

	--Make sure that the plan has a beneficiary
	DECLARE @BeneficiaryCount TINYINT

	SELECT @BeneficiaryCount = COUNT(*) 
	FROM TPolicyBeneficary PBY 
	INNER JOIN TPolicyBusiness PBS ON PBS.PolicyDetailId = PBY.PolicyDetailId
	WHERE PBS.PolicyBusinessId = @PolicyBusinessId AND PBY.IsArchived = 0
	
	
	IF(@BeneficiaryCount <= 0)
	BEGIN
		SELECT @ErrorMessage = 'BENEFICIARY'
	END

END


GO
