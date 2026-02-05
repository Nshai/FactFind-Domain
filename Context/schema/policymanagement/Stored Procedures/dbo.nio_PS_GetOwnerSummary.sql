SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Teodora Pilitis	
-- Create date: 23 Feb 2015
-- Description:	Get wner summary
-- =============================================
CREATE PROCEDURE [dbo].[nio_PS_GetOwnerSummary]
	-- Add the parameters for the stored procedure here
	@PlanId		INT,
	@TenantId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		PB.PolicyBusinessId
		, crm.CRMContactId
		, crm.FirstName
		, crm.LastName
	FROM
		policymanagement..TPolicyBusiness pb with (nolock)
	INNER JOIN
		policymanagement..TPolicyOwner pw with (nolock) on pb.PolicyDetailId = pw.PolicyDetailId
	INNER JOIN
		crm..TCRMContact crm with (nolock) on crm.CRMContactId = pw.CRMContactId
	where 
		pb.PolicyBusinessId = @PlanId and pb.IndigoClientId = @TenantId
END
GO
