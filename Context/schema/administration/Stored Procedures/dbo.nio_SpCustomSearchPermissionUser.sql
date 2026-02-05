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
CREATE PROCEDURE [dbo].[nio_SpCustomSearchPermissionUser]
@TenantId INT,  
@UserId INT,  
@FirstName varchar(50)='%',  
@LastName varchar(50)='%',
@UserName varchar(50)='%',
@UserGroupId INT = 0,
@_TopN int = 0, 
@IsSuperUserOrSuperViewer bit = 0 
with recompile

AS  
BEGIN
 
--Declarations
DECLARE @entityFlag bit
Declare @GroupId INT

if @FirstName <> '%'  
 Select  @FirstName = @FirstName + '%'  
  
if @LastName <> '%' 
 Select  @LastName = @LastName + '%'

if @UserName <> '%' 
 Select  @UserName = @UserName + '%'

--Initialize variables .
select @GroupId = GroupId from TUser where UserId = @UserId
SET @entityFlag = 0

--Find the Legal Entity Group Id.
IF @IsSuperUserOrSuperViewer = 1
BEGIN
    WHILE (@entityFlag = 0)
    BEGIN
	    select @entityFlag = G.LegalEntity from TGroup G where G.GroupId = @GroupId

	    if (@entityFlag != 1)
	      select @GroupId = G.ParentId from TGroup G where G.GroupId = @GroupId
    END
END

--Create a Temp Table to store the group ids.
Create Table #LegalEntityGroups
(
	GroupId bigint
)

--Next, Find all the groups in the Legal Entity
--and insert into #LegalEntityGroups
exec TraverseHierarchy @GroupId

--Select the users in the Legal Entity.
if @UserGroupId = 0
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
  AND T1.Identifier LIKE @UserName	
  AND T1.GroupId in (select GroupId from #LegalEntityGroups)
  AND T1.RefUserTypeId = 1 -- select only non portal users.
  ORDER BY TRIM(T2.FirstName) ASC, TRIM(T2.LastName)  ASC

END
else
Begin

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
	AND T1.Identifier LIKE @UserName
	AND T1.GroupId = @UserGroupId
	AND T1.RefUserTypeId = 1 -- select only non portal users.	
	ORDER BY TRIM(T2.FirstName) ASC, TRIM(T2.LastName)  ASC  

End
--Drop the Temp Table
drop table #LegalEntityGroups
	
END
GO
