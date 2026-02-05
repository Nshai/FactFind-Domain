drop Procedure SpNCustomEnableZurichIntermediaryPlatform
go
Create Procedure SpNCustomEnableZurichIntermediaryPlatform
	@IndigoClientId bigint 
As

IF EXISTS (SELECT 1 FROM TApplicationLink WHERE IndigoClientId = @IndigoClientId AND RefApplicationId = 18)
	Return 
	
Declare @AllowAccess bit
Select @AllowAccess = 1
	
	
DECLARE @MaxApplicationLinkId BIGINT

/*-- Delete any existing zip config details
IF EXISTS (SELECT 1 FROM TApplicationLink WHERE IndigoClientId = @IndigoClientId AND RefApplicationId = 18)
BEGIN		
	Select * From TRefApplication Where RefApplicationId=18	
	SELECT @MaxApplicationLinkId = ApplicationLinkId FROM TApplicationLink
	WHERE IndigoClientId = @IndigoClientId AND RefApplicationId = 18
				
	DELETE FROM TRefProductLink
	WHERE ApplicationLinkId = @MaxApplicationLinkId  AND RefProductTypeId IN (26, 27, 28)
	
	DELETE FROM TApplicationProductGroupAccess
	WHERE ApplicationLinkId = @MaxApplicationLinkId AND RefProductGroupId = 9
					
	DELETE FROM TApplicationLink
	WHERE IndigoClientId = @IndigoClientId AND RefApplicationId = 18
END*/

-----------------------------------------------------
-- Setup Application links for Zip application portal	
SELECT @MaxApplicationLinkId = MAX(ApplicationLinkId) FROM TApplicationLink
SELECT @MaxApplicationLinkId = IsNull(@MaxApplicationLinkId,0)
     
INSERT INTO TApplicationLink
(IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount,
	AllowAccess, WealthlinkEnabled,ExtranetURL, ReferenceCode, ConcurrencyId, IntegratedSystemConfigRole)
SELECT @IndigoClientId, 18, NULL, NULL, 
	/* @AllowAccess */ 1, 1, NULL, NULL, 1, 2 -- ZIP - IntegratedSystemConfigRole = Application

Exec SpNAuditApplicationLinkByMaxId @StampUser=0, @MaxId=@MaxApplicationLinkId, @StampAction='C'

-----------------------------------------------------
-- Setup Product links for Zip supported product types		    
DECLARE @MaxRefProductLinkId BIGINT
SELECT @MaxRefProductLinkId = MAX(RefProductLinkId) FROM TRefProductLink
SELECT @MaxRefProductLinkId = IsNull(@MaxRefProductLinkId,0)

INSERT INTO TRefProductLink
(ApplicationLinkId, RefProductTypeId, ProductGroupData, ProductTypeData, IsArchived, ConcurrencyId)

SELECT a.ApplicationLinkId, b.RefProductTypeId,	
	CASE WHEN IntegratedSystemConfigRole = 2 THEN 'Application' ELSE 'Quote' END + Replace(B.ProductTypeName, ' ', ''),
	'/origo/3.2/?.xsd', 
	Case When @AllowAccess = 1 Then 0 Else 1 End,
	1
FROM TApplicationLink a
CROSS JOIN TRefProductType b 
WHERE a.ApplicationLinkId > @MaxApplicationLinkId
AND ( b.ProductTypeName LIKE 'ISA (Cash)' 
	  OR b.ProductTypeName LIKE 'ISA (Stocks And Shares)' 
	  OR b.ProductTypeName LIKE 'General Investment Account')

EXEC SpNAuditRefProductLinkByMaxId @StampUser=0, @MaxId=@MaxRefProductLinkId, @StampAction='C'

-----------------------------------------------------
-- Setup Application Product Group Access 		
INSERT INTO dbo.TApplicationProductGroupAccess 
(ApplicationLinkId, RefProductGroupId, AllowAccess, ConcurrencyId)

OUTPUT INSERTED.ApplicationLinkId, INSERTED.RefProductGroupId, INSERTED.AllowAccess, INSERTED.ConcurrencyId, 
	INSERTED.ApplicationProductGroupAccessId, 'C', GetDate(), '0'

INTO dbo.TApplicationProductGroupAccessAudit 
	(ApplicationLinkId, RefProductGroupId, AllowAccess, ConcurrencyId,
		ApplicationProductGroupAccessId,StampAction,StampDateTime,StampUser)		

SELECT ApplicationLinkId, 9, @AllowAccess, 1	
FROM TApplicationLink
WHERE IndigoClientId = @IndigoClientId and RefApplicationId = 18 -- ZIP Application Portal