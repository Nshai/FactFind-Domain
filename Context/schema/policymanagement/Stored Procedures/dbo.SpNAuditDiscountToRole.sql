SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Vinay>
-- Create date: <29-Dec-11,,>
-- Description:	<Audit SP to track the DiscountToRole Table DML operation,,>
-- =============================================
Create PROCEDURE [dbo].[SpNAuditDiscountToRole] 

-- parameters Needed for the stored procedure
@StampUser varchar (255),   
@DiscountToRoleId bigint,   
@StampAction char(1) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

    -- Insert statements for procedure
	INSERT INTO TDiscountToRoleAudit   
( 
	DiscountId,
	RoleId,
	TenantId,
	ConcurrencyId,
	DiscountToRoleId, 
	StampAction, 
	StampDateTime, 
	StampUser
)   
	Select 
	DiscountId,
	RoleId,
	TenantId, 
	ConcurrencyId,        
	DiscountToRoleId, 
	@StampAction, 
	GetDate(), 
	@StampUser  

FROM TDiscountToRole  
WHERE DiscountToRoleId = @DiscountToRoleId
END

IF @@ERROR != 0 

GOTO errh    

RETURN (0)    
errh:  RETURN (100)

GO
