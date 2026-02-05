SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Teodora Pilitis	
-- Create date: 23 Feb 2015
-- Description:	Get plan details for a plan
-- =============================================
CREATE PROCEDURE [dbo].[nio_PS_GetPlanDetails]
	-- Add the parameters for the stored procedure here
	@PlanId		INT,
	@TenantId	INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PlanDetails TABLE
	(
		PlanId			INT,
		PolicyNumber	VARCHAR(255),
		Provider		VARCHAR(255),
		PlanTypeId		INT
	)

	INSERT INTO
		@PlanDetails
		(
		PlanId,
		PolicyNumber,
		Provider,
		PlanTypeId
		)
	SELECT
		pb.PolicyBusinessId as PlanId,
		pb.PolicyNumber as PolicyNumber,
		pcrm.CorporateName as Provider,
		pdescr.RefPlanType2ProdSubTypeId as PlanTypeId
	FROM 
		policymanagement..TPolicyBusiness pb WITH (NOLOCK)
	INNER JOIN
		policymanagement..TPolicyDetail pdet WITH (NOLOCK) on pb.PolicyDetailId = pdet.PolicyDetailId
	INNER JOIN
		policymanagement..TPlanDescription pdescr WITH (NOLOCK) on pdescr.PlanDescriptionId = pdet.PlanDescriptionId
	INNER JOIN
		policymanagement..TRefProdProvider provider WITH (NOLOCK) on provider.RefProdProviderId = pdescr.RefProdProviderId
	INNER JOIN
		crm..TCRMContact pcrm on provider.CRMContactId = pcrm.CRMContactId
	WHERE
		pb.PolicyBusinessId = @PlanId and pb.IndigoClientId = @TenantId

	SELECT * FROM @PlanDetails
END
GO
