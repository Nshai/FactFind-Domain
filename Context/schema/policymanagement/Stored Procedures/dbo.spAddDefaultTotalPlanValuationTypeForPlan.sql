-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Teodora Pilitis	
-- Create date: 29/05/2012
-- Description:	Insert a default record for new added plans/group schemas into TPolicyBusinessTotalPlanValuationType table. 
--				Sets the default total plan valuation type for the plan if it's a wrapper.
-- =============================================
CREATE PROCEDURE [dbo].[spAddDefaultTotalPlanValuationTypeForPlan]
	-- Add the parameters for the stored procedure here
	@StampUser	varchar(255),
	@PolicyBusinessId	bigint
AS

SET NOCOUNT ON;
DECLARE @StampDateTime AS DATETIME
DECLARE @ErrorMessage VARCHAR(MAX)

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	BEGIN TRANSACTION
		BEGIN TRY
			
			SET @StampDateTime = GETDATE()

			INSERT	
					policymanagement..TPolicyBusinessTotalPlanValuationType	(
					PolicyBusinessId
					, TenantId
					, RefTotalPlanValuationTypeId
					, ConcurrencyId)
			OUTPUT	inserted.TenantId
					, inserted.RefTotalPlanValuationTypeId
					, inserted.ConcurrencyId
					, inserted.PolicyBusinessId
					, inserted.PolicyBusinessTotalPlanValuationTypeId
					, 'C'
					, @StampDateTime
					, @StampUser
			INTO	policymanagement..TPolicyBusinessTotalPlanValuationTypeAudit	(
					TenantId
					, RefTotalPlanValuationTypeId
					, ConcurrencyId
					, PolicyBusinessId
					, PolicyBusinessTotalPlanValuationTypeId
					, StampAction
					, StampDateTime
					, StampUser
					)
			SELECT	policy.PolicyBusinessId
					, policy.IndigoClientId
					, CASE 
						WHEN refPlan.PlanTypeName = 'Wrap'
						THEN 1 -- default option should be: 'Total of Sub Plans, if any have a value, otherwise Total of Master Plan'
						ELSE 2 -- default option should be: 'Total of Master Plan and Sub Plans'
					END
					, 1
			FROM	policymanagement..TPolicyBusiness policy
			JOIN	policymanagement..TPolicyDetail pdetails on pdetails.PolicyDetailId = policy.PolicyDetailId
			JOIN	policymanagement..TPlanDescription pdesc on pdesc.PlanDescriptionId = pdetails.PlanDescriptionId
			JOIN	policymanagement..TRefPlanType2ProdSubType refPlanToProd on pdesc.RefPlanType2ProdSubTypeId = refPlanToProd.RefPlanType2ProdSubTypeId
			JOIN	policymanagement..TRefPlanType refPlan on refPlanToProd.RefPlanTypeId = refPlan.RefPlanTypeId
			WHERE	refPlan.IsWrapperFg = 1 AND policy.PolicyBusinessId = @PolicyBusinessId
		END TRY
		BEGIN CATCH
		
			SET @ErrorMessage = ERROR_MESSAGE()
			RAISERROR(@ErrorMessage, 16, 1)
			WHILE(@@TRANCOUNT > 0)ROLLBACK
			RETURN 100
		
		END CATCH
	COMMIT TRANSACTION
END
RETURN 0
GO
