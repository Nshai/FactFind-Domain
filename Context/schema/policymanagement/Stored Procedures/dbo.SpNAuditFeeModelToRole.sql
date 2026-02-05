SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		<Author,,Vinay>
-- Create date: <03-Dec-11,,>
-- Description:	<Audit SP to track the FeeModleToRole Table DML operation,,>
-- =============================================
CREATE PROCEDURE [dbo].[SpNAuditFeeModelToRole] 

-- parameters Needed for the stored procedure
@StampUser varchar (255),   
@FeeModelToRoleId bigint,   
@StampAction char(1) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

    -- Insert statements for procedure
	INSERT INTO TFeeModelToRoleAudit   
( 
	FeeModelId,
	RoleId,
	TenantId,
	ConcurrencyId,
	FeeModelToRoleId, 
	StampAction, 
	StampDateTime, 
	StampUser
)   
	Select 
	FeeModelId,
	RoleId,
	TenantId, 
	ConcurrencyId,        
	FeeModelToRoleId, 
	@StampAction, 
	GetDate(), 
	@StampUser  

FROM TFeeModelToRole  
WHERE FeeModelToRoleId = @FeeModelToRoleId
END

IF @@ERROR != 0 

GOTO errh    

RETURN (0)    
errh:  RETURN (100)



GO
