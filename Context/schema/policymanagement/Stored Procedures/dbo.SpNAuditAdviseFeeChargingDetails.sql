SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviseFeeChargingDetails]   @StampUser varchar (255),   @AdviseFeeChargingDetailsId bigint,   @StampAction char(1)  
AS    
	INSERT INTO 
	TAdviseFeeChargingDetailsAudit   
	(AdviseFeeChargingTypeId, 
	Amount, 
	PercentageOfFee, 
	MinimumFee, 
	MaximumFee, 
	TenantId, 
	ConcurrencyId, 
	AdviseFeeChargingDetailsId, 
	StampAction, 
	StampDateTime, 
	StampUser, 
	IsArchived, 
	GroupId, 
	MinimumFeePercentage, 
	MaximumFeePercentage,
	IsSystemDefined) 
	SELECT 
		AdviseFeeChargingTypeId, 
		Amount, 
		PercentageOfFee, 
		MinimumFee, 
		MaximumFee, 
		TenantId, 
		ConcurrencyId, 
		AdviseFeeChargingDetailsId, 
		@StampAction, 
		GetDate(), 
		@StampUser, 
		IsArchived,
		GroupId, 
		MinimumFeePercentage, 
		MaximumFeePercentage,
		IsSystemDefined
	FROM 
		TAdviseFeeChargingDetails  
	WHERE 
		AdviseFeeChargingDetailsId = @AdviseFeeChargingDetailsId    
	
IF @@ERROR != 0 GOTO errh    RETURN (0)    errh:  RETURN (100)
GO
