SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAdviserDetails]
	 @TenantId bigint,                              
	 @AdviserCRMId bigint,
	 @LegalEntityId bigint = null
AS                              		                              
DECLARE @UserId bigint, @ApplyFactFindBranding bit = 1

IF @LegalEntityId IS NULL BEGIN
	SELECT @UserId = UserId FROM Administration..TUser WHERE CRMcontactId = @AdviserCRMId AND IndigoClientId = @TenantId
	SET @LegalEntityId = Administration.dbo.FnGetLegalEntityIdForUser(@UserId)
END

SELECT @ApplyFactFindBranding = ApplyFactFindBranding
FROM Administration..TGroup 
WHERE GroupId = @LegalEntityId

-- Adviser Details                              
SELECT                              
	A.CRMContactId,                              
	A.PractitionerId AS AdviserId,                     
	AC.FirstName,                              
	AC.LastName,                              
	AC.FirstName + ' ' + AC.LastName AS AdviserName,                    
	U.Email,                              
	U.GroupId,                      
	@ApplyFactFindBranding AS ApplyFactFindBranding,  
	Administration.dbo.FnGetGroupLogoForUser(U.UserId) AS GroupImageLocation
FROM                              
	CRM..TPractitioner A WITH(NOLOCK)                   
	JOIN CRM..TCRMContact AC WITH(NOLOCK) ON AC.CRMContactId = A.CRMContactId                              
	JOIN Administration..TUser U WITH(NOLOCK) ON U.CRMContactId = A.CRMContactId                              
WHERE                              
	A.CRMContactId = @AdviserCRMId                              
	AND A.IndClientId = @TenantId
GO
