SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20230505    Saumya Rajan    IOSE22-1695    User Search list displayed alphabetically

*/
CREATE PROCEDURE [dbo].[nio_SpCustomSearchCommissionUser]
@TenantId INT,  
@FirstName varchar(50)='%',  
@LastName varchar(50)='%',
@_TopN int = 0  
with recompile

AS  
  
if @FirstName <> '%'  
 Select  @FirstName = @FirstName + '%'  
  
if @LastName <> '%' 
 Select  @LastName = @LastName + '%'  


Declare @PractitionerRoleId bigint  
--Get 'Defined PractitionerRoleId' for the given IndigoClientId  
Select @PractitionerRoleId = PractitionerRoleId  
From Compliance.dbo.TComplianceSetup  
Where IndClientId = @TenantId  


BEGIN  
  
 SELECT Distinct  
   T1.UserId,T1.CRMContactId,  
   TRIM(T2.FirstName), TRIM(T2.LastName),  
   T5.Identifier AS GroupingName,   
   T4.Identifier AS GroupName  
  FROM [Administration].[dbo].TUser T1  
  INNER JOIN CRM..TCRMContact T2 on T1.CRMContactId=T2.CRMcontactId AND T1.IndigoClientId = T2.IndClientId
  Left Join CRM..TPractitioner T3 on T3.CRMContactId=T2.CRMContactId
  Left JOIN [Administration].[dbo].TGroup T4 ON T4.GroupId = T1.GroupId  
  Left JOIN [Administration].[dbo].TGrouping T5 ON T5.GroupingId = T4.GroupingId  
  
  WHERE T1.IndigoClientId = @TenantId  
  AND T2.FirstName LIKE @FirstName  
  AND T2.LastName LIKE @LastName  
  
  AND T1.RefUserTypeId = 1
  AND T1.CRMContactId Not In (Select CRMContactId From [CRM].[dbo].TPractitioner Where IndClientId = @TenantId)  
  ORDER BY TRIM(T2.FirstName) ASC, TRIM(T2.LastName)  ASC 
END  
RETURN 0  
  

GO
