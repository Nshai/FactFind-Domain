SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomLinkPlanAndAdviceCaseToFileCheck]
	(
		@PolicyBusinessId bigint,   
		@StampUser varchar (255)     
	)

AS
    
Declare @FileCheckMiniId int,@AdviceCaseId bigint ,@AdviceCaseFileCheckId bigint

SET @FileCheckMiniId=(SELECT TOP 1 FileCheckMiniId FROM Compliance..TFileCheckMini 
							WHERE PolicyBusinessId=@PolicyBusinessId ORDER BY FileCheckMiniId DESC)
  
IF ISNULL(@FileCheckMiniId,0)!=0
BEGIN
	
INSERT INTO TAdviceCaseFileCheck(AdviceCaseId,FileCheckMiniId,ConcurrencyId)
	OUTPUT	inserted.AdviceCaseFileCheckId
			,inserted.AdviceCaseId
			,inserted.FileCheckMiniId
			,inserted.ConcurrencyId
			,'C'
			,GETDATE()
			,@StampUser
	INTO TAdviceCaseFileCheckAudit(AdviceCaseFileCheckId,AdviceCaseId,FileCheckMiniId,ConcurrencyId,StampAction,StampDateTime,StampUser)		
SELECT DISTINCT A.AdviceCaseId,@FileCheckMiniId,1  
FROM CRM..TAdviceCasePlan A
LEFT JOIN TAdviceCaseFileCheck B ON A.AdviceCaseId=B.AdviceCaseId
WHERE A.PolicyBusinessId=@PolicyBusinessId
--AND ISNULL(B.AdviceCaseFileCheckId,0)=0
		  
IF @@ERROR != 0 GOTO errh  		
END 

SELECT 1   
  
errh:  
SELECT 0
GO
