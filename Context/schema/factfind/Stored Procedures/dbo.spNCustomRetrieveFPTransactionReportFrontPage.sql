SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFPTransactionReportFrontPage]

@Financialplanningid bigint

as

declare @RefPDFTemplateTypeId bigint,
		@IndigoClientId bigint,
		@AdviserCRMId bigint,
		@AdviserUserId bigint,
		@LogoOption varchar(50),
		@LogoPosition varchar(50),
		@AddressOption varchar(50),
		@CRMContactId bigint

select @RefPDFTemplateTypeId = RefPDFTemplateTypeId from reporter..TRefPDFTemplateType where Description = 'Financial Planning'

select @CRMContactId = CRMContactId from factfind..TFinancialPlanningSession where financialplanningid = @FinancialPlanningId

select @IndigoClientId = IndClientId from crm..TCRMContact where crmcontactid = @CRMContactId

-- Get current Adviser for this client  
SELECT  
 @AdviserCRMId = CurrentAdviserCRMId,  
 @AdviserUserId = UserId  
FROM  
 CRM..TCRMContact C  
 JOIN Administration..TUser U ON U.CRMContactId = C.CurrentAdviserCRMId  
WHERE  
 C.CRMContactId = @CRMContactId  
  
  
-- contact details
 SELECT    
	@AddressOption = PropertyValue	
 FROM  
  reporter..TPDFTemplateType T  
  JOIN reporter..TRefPDFTemplateTypeProperty P ON P.RefPDFTemplateTypePropertyId = T.RefPDFTemplateTypePropertyId  
 WHERE  
	IndigoClientId = @IndigoClientId  AND 
	RefPDFTemplateTypeId = @RefPDFTemplateTypeId and
	PropertyName = 'Contact Details'

select @AddressOption as AddressOption

--logo		
SELECT  
  @LogoOption = PropertyValue	
 FROM  
  reporter..TPDFTemplateType T  
  JOIN reporter..TRefPDFTemplateTypeProperty P ON P.RefPDFTemplateTypePropertyId = T.RefPDFTemplateTypePropertyId  
 WHERE  
	IndigoClientId = @IndigoClientId  AND 
	RefPDFTemplateTypeId = @RefPDFTemplateTypeId and
	PropertyName = 'Logo'

select @LogoOption as Logo

SELECT  
  @LogoPosition = PropertyValue 
 FROM  
  reporter..TPDFTemplateType T  
  JOIN reporter..TRefPDFTemplateTypeProperty P ON P.RefPDFTemplateTypePropertyId = T.RefPDFTemplateTypePropertyId  
 WHERE  
	IndigoClientId = @IndigoClientId  AND 
	RefPDFTemplateTypeId = @RefPDFTemplateTypeId and
	PropertyName = 'Logo Position'

select @LogoPosition as LogoPosition

-- Client address  
SELECT   
 *  
FROM  
 CRM..VwAddress WITH(NOLOCK)  
WHERE  
 CRMContactId = @CRMContactId  
 AND DefaultFg = 1  
   
-- correct address  
EXEC reporter..SpNCustomRetrieveReportAddress @AdviserCRMId, @AddressOption, @IndigoClientId  
  
-- logo  
EXEC reporter..SpNCustomRetrieveReportLogo @AdviserUserId, @LogoOption, @IndigoClientId  



GO
