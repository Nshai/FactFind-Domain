SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Vinay>
-- Create date: <10-Jan-12,,>
-- Description:	<Audit SP to track the RefServiceStatusToFeeModel Table DML operation,,>
-- =============================================
Create PROCEDURE [dbo].[SpNAuditRefServiceStatusToFeeModel] 

-- parameters Needed for the stored procedure
@StampUser varchar (255),   
@RefServiceStatusToFeeModelId bigint,   
@StampAction char(1) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

    -- Insert statements for procedure
	INSERT INTO TRefServiceStatusToFeeModelAudit   
( 
	RefServiceStatusId,
	FeeModelId,
	IsDefault,
	TenantId,
	ConcurrencyId,
	RefServiceStatusToFeeModelId, 
	StampAction, 
	StampDateTime, 
	StampUser
)   
	Select 
	RefServiceStatusId,
	FeeModelId,
	IsDefault,
	TenantId,
	ConcurrencyId,        
	RefServiceStatusToFeeModelId, 
	@StampAction, 
	GetDate(), 
	@StampUser  

FROM TRefServiceStatusToFeeModel  
WHERE RefServiceStatusToFeeModelId = @RefServiceStatusToFeeModelId
END

IF @@ERROR != 0 

GOTO errh    

RETURN (0)    
errh:  RETURN (100)


GO
