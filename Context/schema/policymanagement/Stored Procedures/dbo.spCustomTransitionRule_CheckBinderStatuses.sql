SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
    
    
CREATE PROCEDURE [dbo].[spCustomTransitionRule_CheckBinderStatuses]    
  @PolicyBusinessId bigint,    
  @ResponseCode varchar(512) output    
AS    
    
BEGIN        
 
 --1. Get List of all Binders linked to Plan through Service Case 
 --2. Check if atleast one binder is in 'Ready' or 'Sent To Client'    
     
   
Declare @Result as Table(Description nvarchar(50),BinderId int,StatusDate Datetime,ROWNUM int)

INSERT INTO @Result
SELECT * FROM (
	SELECT y.Description, x.BinderId,StatusDate, 
	ROW_NUMBER() OVER(PARTITION BY BinderID order by BinderStatusHistoryId Desc) Row_NUM -- Get Row_NUM based on the latest BinderStatus
	FROM DocumentManagement..TBinderStatusHistory x    
	INNER JOIN DocumentManagement..TRefBinderStatus y ON x.RefBinderStatusId=y.RefBinderStatusId    
	WHERE BinderId IN 
	(
		-- Get list of all the binders related to the plan through Service Case
		SELECT BinderId FROM CRM..TAdviceCasePlan ACP    
		INNER JOIN CRM..TAdviceCase AC ON AC.AdviceCaseId=ACP.AdviceCaseId    
		WHERE ACP.PolicyBusinessId=@PolicyBusinessId 
	)			
	
) x 
WHERE Row_NUM=1 --Filter latest Binder Status
AND Description IN ('Ready','Sent To Client') -- Having Status Ready or Sent to Client  
-- If count is 0 
--    it indicates that there is no binder which is in Ready or Sent To Client status, then show validation message
     
IF (SELECT COUNT(*) FROM @Result )= 0
 BEGIN        
  SELECT @ResponseCode = 'BINDERREADYORSENTTOCLIENT'          
 END        
END        
        
        
        
    
    
    
    
    
GO
