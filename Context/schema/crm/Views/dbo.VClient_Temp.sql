SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VClient_Temp]  
  
AS  
  
SELECT  
 A.CRMContactId,  
 A.IndClientId,  
 A.RefServiceStatusId,  
 A.CRMContactId AS PartyCRMContactId,  
 A._OwnerId,  
 A.ConcurrencyId,  
 NULL AS Salary--This is used as a dummy column for group scheme member imports.  
FROM  
 dbo.TCRMContact A  
   
   
WHERE  
 ISNULL(A.RefCRMContactStatusId,0) IN (0,1)  
 AND ISNULL(A.InternalContactFG, 0) = 0
GO
