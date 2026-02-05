SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveClientDetails]    
@UserId bigint,    
@cid bigint    
      
AS      
      
      
declare @AdviserPostCode varchar(10), @Notes varchar(8000), @LastNoteData varchar(1000)        
declare @AlwaysOpenNotes bit, @TenantId bigint
      
select @TenantId = IndigoClientId FROM Administration..TUser where userid = @UserId
      
select @AdviserPostCode = isnull(ast.postcode,'')       
from taddress a      
inner join taddressstore ast on ast.addressstoreid = a.addressstoreid      
where crmcontactid = (select CurrentAdviserCRMId FROM TCRMContact WHERE CRMContactId = @cid)      
      
if @AdviserPostCode is null       
begin      
 select @AdviserPostCode = isnull(i.postcode,'') from administration..tindigoclient i      
 inner join crm..tcrmcontact c on c.indClientId = i.IndigoclientId      
 where c.CRMContactId = @cid      
end      

set @AlwaysOpenNotes = (
	select isnull(Value,0) 
	FROM Administration..TIndigoClientPreference 
	WHERE IndigoClientId = @TenantId
	AND PreferenceName = 'AutoOpenClientNotesOnDashboard'
)
  
-- quick fix to prevent notes appearing on the client portal dashboard  
if (select RefUserTypeId FROM Administration..TUser WHERE UserId = @UserId) = 1   
 SELECT @Notes = LatestNote from tnote WHERE EntityType = 'crmcontact' and EntityId = @cid          
      
IF @Notes IS NOT NULL AND charindex(': ', @notes) > 0      
 set @LastNoteData = left(@notes, charindex(': ', @notes)-1)  
  
--£ sign hack  
select @Notes = replace(@Notes,'£','&#163;')  
    
SELECT       
1 as tag,      
null as parent,      
c.CRMContactId as [ClientDetails!1!CRMContactId],    
c.CRMContactType as [ClientDetails!1!CRMContactType],    
@AdviserPostcode as [ClientDetails!1!AdviserPostcode],    
isnull(c.CorporateName,'') + isnull(p.Title,'') + ' ' + isnull(c.FirstName,'') + ' ' + isnull(p.MiddleName,'') + ' ' + isnull(c.LastName,'') as [ClientDetails!1!FullName],    
isnull(convert(varchar(10),c.DOB,103),'') as [ClientDetails!1!DateOfBirth],    
ISNULL(convert(varchar(3),CASE    
 WHEN dateadd(year, datediff (year, c.dob, getdate()), c.dob) > getdate() THEN datediff (year, c.dob, getdate()) - 1    
 ELSE datediff (year, c.dob, getdate())      
END),'') as [ClientDetails!1!CurrentAge],      
isnull(c.CorporateName,'') as [ClientDetails!1!CorporateName],      
isnull(c.FirstName,'') as [ClientDetails!1!FirstName],      
isnull(c.LastName,'') as [ClientDetails!1!LastName],      
c.CurrentAdviserCRMId as [ClientDetails!1!CurrentAdviserCRMId],      
c.ExternalReference as [ClientDetails!1!ExternalReference],      
isnull(ast.AddressLine1,'') as [ClientDetails!1!AddressLine1],      
isnull(ast.AddressLine2,'') as [ClientDetails!1!AddressLine2],      
isnull(ast.AddressLine3,'') as [ClientDetails!1!AddressLine3],      
isnull(ast.AddressLine4,'') as [ClientDetails!1!AddressLine4],      
isnull(ast.CityTown,'') as [ClientDetails!1!CityTown],      
isnull(ast.PostCode,'') as [ClientDetails!1!PostCode],      
isnull(county.CountyName,'') as [ClientDetails!1!CountyName],      
isnull(country.CountryName,'') as [ClientDetails!1!CountryName],      
@Notes as [ClientDetails!1!Notes],    
@LastNoteData as [ClientDetails!1!LastNote],   
isnull(@AlwaysOpenNotes,0) as [ClientDetails!1!AutoOpenNotes], 
null as [Contact!2!RefContactType],      
null as [Contact!2!Value]    
      
FROM TCRMContact c      
LEFT JOIN TAddress a ON a.CRMContactId = c.CRMContactId AND a.DefaultFg = 1      
LEFT JOIN TAddressStore ast ON ast.AddressStoreId = a.AddressStoreId      
LEFT JOIN TRefCounty county ON county.RefCountyId = ast.RefCountyId      
LEFT JOIN TRefCountry country ON country.RefCountryId = ast.RefCountryId      
LEFT JOIN TPerson p ON c.PersonId = p.PersonId      
WHERE c.CRMContactId = @cid      
      
UNION      
      
SELECT       
2 as tag,      
1 as parent,      
c.CRMContactId,      
null,      
null,      
null,      
null,    
null,    
null,    
null,      
null,      
null,    
null,      
null,      
null,      
null,      
null,      
null,      
null,    
null,    
null,      
null,      
null,      
null,
cn.RefContactType,      
cn.Value      
      
FROM TCRMContact c      
LEFT JOIN TContact cn ON cn.CRMContactId = c.CRMContactId      
WHERE c.CRMContactId = @cid      
AND cn.DefaultFg = 1      
      
FOR XML EXPLICIT   

GO