SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[SpNioCustomPersonByExternalReference]
	@ExternalReference VARCHAR(100), 
	@IndigoClientId BIGINT 
AS
BEGIN   
 SET NOCOUNT ON;  
  
 SELECT 
	c.CRMContactId as PartyId,  
	ext.ExternalId as GcdPartyId,  
	c.FirstName as FirstName,  
	c.LastName as LastName,
	c.DOB		as Dob,
	IsNull(an.AgencyNumber,'') as AdviserAgencyNumber
     
 FROM   
	TCRMContact c
	Inner Join TCRMContactExt ext On c.CRMContactId = ext.CRMContactId  
	
	--IO Servicing Adviser Mapping  
	Inner Join TPractitioner p WITH(NOLOCK) On p.CRMContactId = c.CurrentAdviserCRMId  
    
	--IO Adviser > Agency Numbers Mapping  
	Left Join CRM..TAgencyNumber an WITH(NOLOCK) On an.PractitionerId = p.PractitionerId  
	And an.RefProdProviderId = 199  	
	
 WHERE  ext.ExternalId = @ExternalReference /* @p0 */      
     and c.IndClientId = @IndigoClientId /* @p2 */  

END

GO


