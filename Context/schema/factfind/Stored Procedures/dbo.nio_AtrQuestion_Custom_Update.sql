SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrQuestion_Custom_Update]  
@Description varchar(500),  
@Ordinal int,  
@IsInvestment bit,  
@IsRetirement bit,  
@IsActive bit,            
@Guid uniqueidentifier  
  
  
  
AS  
  

DECLARE @StampUser varchar(255),@AtrQuestionId bigint

SELECT @StampUser='999999998'  

IF ISNULL(@AtrQuestionId,0)=0
BEGIN
	SELECT @AtrQuestionId=AtrQuestionId FROM TAtrQuestion WHERE Guid=@Guid 
END
  
BEGIN  

 

  
--Audited by nio.
 Update TAtrQuestion   
 SET Description=@Description,Ordinal=@Ordinal,  
 Investment=@IsInvestment,Retirement=@IsRetirement,  
 Active=@IsActive,ConcurrencyId=ConcurrencyId + 1  
  
 WHERE Guid=@Guid AND AtrQuestionId=@AtrQuestionId  

 EXEC FactFind..SpNAuditAtrQuestionCombined @StampUser,@AtrQuestionId,'U'

 Update TAtrQuestionCombined   
 SET Description=@Description,Ordinal=@Ordinal,  
 Investment=@IsInvestment,Retirement=@IsRetirement,  
 Active=@IsActive,ConcurrencyId=ConcurrencyId + 1  
  
 WHERE Guid=@Guid AND AtrQuestionId=@AtrQuestionId  
  
  
END  

GO
