SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spNCustomGetSellingAdvisers]
	@IndigoClientId Bigint, 
	@UserId Bigint,
	@CRMContactId Bigint,
	@CRMContactId2 Bigint = null
	
AS
BEGIN
	
	--Use PractitionerId's, NOT  CRMContactIds
	
	Select Distinct A.PractitionerId, ISNULL(C.FirstName, '') + ' ' + ISNULL(C.LastName, '') as AdviserName
	from(
		
		Select B.PractitionerId 
		from administration..TUser A
		Inner join CRM..TPractitioner B on A.CRMContactId = B.CRMContactId		
		Where A.UserId = @UserId
		
		Union
		
		Select PractitionerId 
		from compliance..TPreExistingAdviser A
		Where A.IndigoClientId = @IndigoClientId
		
		Union
		
		Select B.PractitionerId from CRM..TCRMContact A
		Inner join CRM..TPractitioner B on A.CurrentAdviserCRMId = B.CRMContactId
		Where A.CRMContactId in(@CRMContactId, @CRMContactId2)
		
	) A		
	Inner join CRM..TPractitioner B on A.PractitionerId = B.PractitionerId
	inner join CRM..TCRMContact C on B.CRMContactId = C.CRMContactId

	
	
	
	
	
	
	
	
END
GO
