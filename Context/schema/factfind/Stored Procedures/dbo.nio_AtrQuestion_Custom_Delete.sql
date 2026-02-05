SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_AtrQuestion_Custom_Delete]  
@Guid uniqueidentifier  
  
  
  
AS  

DECLARE @StampUser varchar(255),@AtrQuestionId bigint

SELECT @StampUser='999999998'  

SELECT @AtrQuestionId=AtrQuestionId FROM TAtrQuestion WHERE Guid=@Guid
  
BEGIN  
 INSERT TAtrAnswerAudit
	(Description,
		Ordinal,
		Weighting,
		AtrQuestionGuid,
		IndigoClientId,
		Guid,
		ConcurrencyId,
		AtrAnswerId,
		StampAction,
		StampDateTime,
		StampUser)

	SELECT Description,
		Ordinal,
		Weighting,
		AtrQuestionGuid,
		IndigoClientId,
		Guid,
		ConcurrencyId,
		AtrAnswerId,
		'D',getdate(),@StampUser

		FROM TAtrAnswer WHERE AtrQuestionGuid=@Guid  


		DELETE FROM TAtrAnswer WHERE AtrQuestionGuid=@Guid  

 INSERT TAtrAnswerCombinedAudit
 (AtrAnswerId,
	Description,
	Ordinal,
	Weighting,
	AtrQuestionGuid,
	IndigoClientId,
	IndigoClientGuid,
	ConcurrencyId,
	Guid,
	StampAction,
	StampDateTime,
	StampUser)

	SELECT AtrAnswerId,
	Description,
	Ordinal,
	Weighting,
	AtrQuestionGuid,
	IndigoClientId,
	IndigoClientGuid,
	ConcurrencyId,
	Guid,
	'D',getdate(),@StampUser
	FROM TAtrAnswerCombined WHERE AtrQuestionGuid=@Guid 
   
	DELETE FROM TAtrAnswerCombined WHERE AtrQuestionGuid=@Guid  

	DELETE FROM TAtrCategoryQuestion WHERE AtrQuestionGuid=@Guid  

	EXEC FactFind..SpNAuditAtrQuestionCombined @StampUser,@AtrQuestionId,'D'

	DELETE FROM TAtrQuestionCombined WHERE Guid=@Guid  
   
	DELETE FROM TAtrQuestion WHERE Guid=@Guid    
	
END  
  
GO
