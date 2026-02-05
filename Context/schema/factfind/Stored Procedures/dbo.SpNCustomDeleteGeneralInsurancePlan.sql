SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteGeneralInsurancePlan]
	@StampUser varchar(50),
	@GeneralInsurancePlanId bigint,
	@ConcurrencyId bigint,
	@CurrentUserDate datetime
AS
EXEC SpNCustomDeletePlan @GeneralInsurancePlanId, @StampUser, @CurrentUserDate
GO
