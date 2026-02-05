SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomRetrieveAdviceCaseCountByAdviceCaseRef]
	(
		@CaseRef varchar(50),
		@IndigoClientId bigint,
		@AdviceCaseId bigint=null
	)

AS
    

DECLARE @RecordCount int

SET @RecordCount=(SELECT ISNULL(COUNT(A.AdviceCaseId),0) 
					FROM TAdviceCase A JOIN TCRMContact B ON A.CRMContactId=B.CRMContactId 
					WHERE LTRIM(RTRIM(A.CaseRef))=@CaseRef AND B.IndClientId=@IndigoClientId 
						AND (ISNULL(@AdviceCaseId,0)=0 OR A.AdviceCaseId !=@AdviceCaseId))
  
SELECT @RecordCount
GO
