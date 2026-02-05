SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDeletePolicyBusinessFundAttributeByPolicyBusinessFundId]
	@PolicyBusinessFundId Bigint,   
	@StampUser varchar (255)     

AS    

SET NOCOUNT ON    

DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX    

BEGIN      
	INSERT INTO TPolicyBusinessFundAttributeAudit (
		PolicyBusinessFundId,
		RefFundAttributeId,
		ConcurrencyId,
		PolicyBusinessFundAttributeId,
		StampAction,
		StampDateTime,
		StampUser
	)   
	SELECT 
		T1.PolicyBusinessFundId, 
		T1.RefFundAttributeId, 
		T1.ConcurrencyId,    
		T1.PolicyBusinessFundAttributeId,    
		'D',   
		GetDate(),   
		@StampUser    
	FROM TPolicyBusinessFundAttribute T1    
	WHERE T1.PolicyBusinessFundId = @PolicyBusinessFundId 
	
	DELETE T1 FROM TPolicyBusinessFundAttribute T1   
	WHERE T1.PolicyBusinessFundId = @PolicyBusinessFundId
	
	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW    
	
	IF @@ERROR != 0 GOTO errh  
	IF @tx = 0 COMMIT TRANSACTION TX    
END  
RETURN (0)    

errh:    
IF @tx = 0 ROLLBACK TRANSACTION TX    
RETURN (100)
GO
