SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteExistingMortgage]
@ConcurrencyId bigint,  
@ExistingMortgageId bigint,  
@StampUser varchar(50),
@CurrentUserDate datetime 

AS

DECLARE @MortgageId bigint
SELECT @MortgageId=MortgageId FROM PolicyManagement..TMortgage WHERE PolicyBusinessId=@ExistingMortgageId

BEGIN
	--Delete any repayment vehicle records
	INSERT PolicyManagement..TRepaymentVehicleAudit(MortgageId,PolicyBusinessId,ConcurrencyId,RepaymentVehicleId,StampAction,StampDateTime,StampUser)
	SELECT MortgageId,PolicyBusinessId,ConcurrencyId,RepaymentVehicleId,'D',getdate(),@StampUser
	FROM PolicyManagement..TRepaymentVehicle
	WHERE MortgageId=@MortgageId
	
	IF @@ERROR!=0 GOTO errh
	
	DELETE FROM PolicyManagement..TRepaymentVehicle
	WHERE MortgageId=@MortgageId
	
	--Delete the Mortgage 
	EXEC PolicyManagement..SpNAuditMortgage @StampUser,@MortgageId,'D'
	DELETE FROM PolicyManagement..TMortgage WHERE MortgageId=@MortgageId
	
	IF @@ERROR!=0 GOTO errh
	
	--Then the Policy Business
	EXEC SpNCustomDeletePlan @ExistingMortgageId, @StampUser, @CurrentUserDate
	IF @@ERROR!=0 GOTO errh
	
	RETURN(0)

END

errh:
RETURN(100)
GO
