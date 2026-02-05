SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAdviceCasesForClient] @CRMContactId bigint    
    
AS    
    
BEGIN    
 SELECT    
 1 AS Tag,    
 NULL AS Parent,    
 T1.AdviceCaseId AS [AdviceCase!1!AdviceCaseId],     
 T1.CaseName AS [AdviceCase!1!CaseName],    
 T1.CRMContactId AS [AdviceCase!1!CRMContactId],     
 T1.PractitionerId AS [AdviceCase!1!PractitionerId],     
 T1.StatusId AS [AdviceCase!1!StatusId],     
 CONVERT(varchar(24), T1.StartDate, 120) AS [AdviceCase!1!StartDate],      
 ISNULL(T1.CaseRef,'') AS [AdviceCase!1!CaseRef],    
 ISNULL(T1.BinderId, '') AS [AdviceCase!1!BinderId],     
 T1.ConcurrencyId AS [AdviceCase!1!ConcurrencyId],    
 T2.Descriptor AS [AdviceCase!1!Status],    
 ISNULL(T5.Description,'') AS [AdviceCase!1!Binder],    
 T4.FirstName + ' ' + T4.LastName AS [AdviceCase!1!Adviser],
 ISNULL(T2.IsComplete,0) AS [AdviceCase!1!IsComplete]
 FROM TAdviceCase T1    
 JOIN TAdviceCaseStatus T2 ON T1.StatusId=T2.AdviceCaseStatusId    
 JOIN CRM..TPractitioner T3 ON T1.PractitionerId=T3.PractitionerId    
    JOIN CRM..TCRMContact T4 ON T3.CRMContactId=T4.CRMContactId    
 LEFT JOIN DocumentManagement..TBinder T5 ON T1.BinderId=T5.BinderId    
 WHERE T1.CRMContactId=@CRMContactId    
 ORDER BY [AdviceCase!1!AdviceCaseId]    
    
  FOR XML EXPLICIT    
    
END    
RETURN (0)    
GO
