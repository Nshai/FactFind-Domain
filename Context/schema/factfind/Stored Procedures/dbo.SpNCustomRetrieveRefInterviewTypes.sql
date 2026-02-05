SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveRefInterviewTypes] 
AS      
   SELECT 1 AS TAG,  
   NULL AS Parent,  
   RefInterviewTypeId  AS [RefInterviewType!1! RefInterviewTypeId],  
   InterviewType AS [RefInterviewType!1!InterviewType]  
FROM TRefInterviewType  
ORDER BY [RefInterviewType!1!InterviewType]  
FOR XML EXPLICIT
GO
