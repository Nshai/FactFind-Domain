SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCheckPlanType] 
@RefPlanTypeId bigint, 
@PlanTypeName varchar(255),  
@ProdSubTypeId bigint,
@ProdSubTypeName varchar(255) = null,  
@RefPlanType2ProdSubTypeId bigint,
@DefaultCategory varchar(255),  
@FactFindCategory varchar(255),  
@SchemeType int,  
@IsWrapperFg bit=0,  
@AdditionalOwnersFg bit=0,  
@ArchiveFg bit = 0,  
@PortfolioReportCategory varchar(255),  
@PortfolioReportSubCategory varchar(255),
@LicenseType varchar(255),
@FactFindSection varchar(255) = null,
@IsConsumerFriendly BIT = 0,
@RefPlanDiscriminatorId bigint = null,
@RefPortfolioCategoryId bigint = null,
@RegionCode varchar(2) = 'GB',
@IsTaxQualifying bit = NULL
AS  

BEGIN

SET NOCOUNT ON  
IF @ProdSubTypeName = ''  
	SET @ProdSubTypeName = null  
  
DECLARE @RefFactFindCategoryId bigint
DECLARE @CurrentRefPlanTypeId bigint, @CurrentProdSubTypeId bigint, @CurrentRefPlanType2ProdSubTypeId bigint

DECLARE @StampActionCreate	AS char(1)
DECLARE @StampActionUpdate	AS char(1)
DECLARE @StampActionDelete	AS char(1)
DECLARE @StampDateTime AS DATETIME
DECLARE @StampUser AS VARCHAR(255)

SET @StampActionCreate = 'C'
SET @StampActionDelete = 'D'
SET @StampActionUpdate = 'U'
SET @StampDateTime = GETDATE()
SET @StampUser = '0'

IF @RefPortfolioCategoryId IS NOT NULL
BEGIN
	if (
		SELECT RefPortfolioCategoryId
		FROM policymanagement..TRefPortfolioCategory
		WHERE RefPortfolioCategoryId = @RefPortfolioCategoryId
		) IS NULL
	BEGIN
		PRINT 'PortfolioCategory with Specified @RefPortfolioCategoryId doesn''t exist'
		RETURN
	END
END

IF (@RefPlanDiscriminatorId IS NOT NULL) 
	AND  ((SELECT 1 FROM TRefPlanDiscriminator WHERE RefPlanDiscriminatorId = @RefPlanDiscriminatorId) IS NULL)
BEGIN
	PRINT 'Specified @RefPlanDiscriminatorId doesn''t exist'
	RETURN
END

--------------------------------------------------  
-- process TRefPlanType
-------------------------------------------------- 
SET @CurrentRefPlanTypeId = (SELECT top 1 rpt.RefPlanTypeId FROM TRefPlanType rpt 
							WHERE rpt.RefPlanTypeId = @RefPlanTypeId and rpt.PlanTypeName = @PlanTypeName)  

IF @CurrentRefPlanTypeId IS NULL  
BEGIN  
	-- plan type does not exist, so add a new one
	IF NOT EXISTS (SELECT 1 FROM TRefPlanType WHERE RefPlanTypeId = @RefPlanTypeId)
	BEGIN
		print 'adding new plan type'  
		SET IDENTITY_INSERT TRefPlanType ON
		
		INSERT INTO	dbo.TRefPlanType 
				(RefPlanTypeId
				,PlanTypeName
				,RetireFg
				,SchemeType
				,IsWrapperFg
				,AdditionalOwnersFg
				,ConcurrencyId
				,IsTaxQualifying)
		OUTPUT	INSERTED.PlanTypeName
				, INSERTED.RetireFg
				, INSERTED.SchemeType
				, INSERTED.IsWrapperFg
				, INSERTED.AdditionalOwnersFg
				, INSERTED.ConcurrencyId
				, INSERTED.RefPlanTypeId
				, INSERTED.IsTaxQualifying
				, @StampActionCreate
				, @StampDateTime
				, @StampUser
		INTO	dbo.TRefPlanTypeAudit 
				(PlanTypeName
				, RetireFg
				, SchemeType
				, IsWrapperFg
				, AdditionalOwnersFg
				, ConcurrencyId
				, RefPlanTypeId
				, IsTaxQualifying
				, StampAction
				, StampDateTime
				, StampUser)
		VALUES	(@RefPlanTypeId
				,@PlanTypeName
				,@ArchiveFg -- RetireFg
				,@SchemeType
				,@IsWrapperFg
				,@AdditionalOwnersFg
				,1 -- ConcurrencyId
				,@IsTaxQualifying)

		SET IDENTITY_INSERT TRefPlanType OFF
	END
	ELSE
	BEGIN
		-- uh-oh, the plan type is is already in use!
		print 'Specified RefPlanTypeId already exists with a different name, cannot continue!'
		return
	END	
END  
ELSE  
BEGIN  
		-- plan type exists and has the correct id, so update
		print 'updating existing plan type ' + convert(varchar(50),@RefPlanTypeId)
		
		UPDATE	dbo.TRefPlanType
		SET		RetireFg = @ArchiveFg,  
				SchemeType = @SchemeType,
				IsTaxQualifying = ISNULL(@IsTaxQualifying, IsTaxQualifying)
		OUTPUT	INSERTED.PlanTypeName, INSERTED.WebPage, INSERTED.OrigoRef, INSERTED.QuoteRef, INSERTED.NBRef, INSERTED.RetireFg
				, INSERTED.RetireDate, INSERTED.FindFg, INSERTED.SchemeType, INSERTED.IsWrapperFg, INSERTED.AdditionalOwnersFg
				, INSERTED.Extensible, INSERTED.ConcurrencyId, INSERTED.RefPlanTypeId, INSERTED.IsTaxQualifying
				, @StampActionUpdate, @StampDateTime, @StampUser
		INTO	dbo.TRefPlanTypeAudit(PlanTypeName, WebPage, OrigoRef, QuoteRef, NBRef, RetireFg
				, RetireDate, FindFg, SchemeType, IsWrapperFg, AdditionalOwnersFg
				, Extensible, ConcurrencyId, RefPlanTypeId, IsTaxQualifying
				, StampAction, StampDateTime, StampUser)
		WHERE	RefPlanTypeId = @RefPlanTypeId
END

--------------------------------------------------  
-- process TProdSubType
--------------------------------------------------
SET @CurrentProdSubTypeId = 
(  
	 SELECT t1.ProdSubTypeId   
	 FROM TRefPlanType2ProdSubType t1  
	 JOIN TProdSubType t2 ON t2.ProdSubTypeId = t1.ProdSubTypeId  
	 WHERE t1.RefPlanTypeId = @RefPlanTypeId  
	 AND t1.RegionCode = @RegionCode
	 AND t2.ProdSubTypeName = @ProdSubTypeName OR (@ProdSubTypeName IS NULL AND t2.ProdSubTypeName IS NULL) 
 )  
  
IF @ProdSubTypeName IS NOT NULL AND @CurrentProdSubTypeId IS NULL  
BEGIN  
	IF NOT EXISTS (SELECT 1 FROM TProdSubType WHERE ProdSubTypeId = @ProdSubTypeId)
	BEGIN
		print 'adding new sub type'  
		SET IDENTITY_INSERT TProdSubType ON

		INSERT INTO TProdSubType
					(ProdSubTypeId
					, ProdSubTypeName
					, ConcurrencyId)
		OUTPUT	INSERTED.ProdSubTypeName
				, INSERTED.ConcurrencyId
				, INSERTED.ProdSubTypeId
				, @StampActionCreate
				, @StampDateTime
				, @StampUser
		INTO	TProdSubTypeAudit
				(ProdSubTypeName
				, ConcurrencyId
				, ProdSubTypeId
				, StampAction
				, StampDateTime
				, StampUser)
		VALUES (@ProdSubTypeId
				, @ProdSubTypeName
				, 1)
 
 		SET IDENTITY_INSERT TProdSubType OFF
	END
	ELSE
	BEGIN
		-- uh-oh, the prod sub type is is already in use!
		print 'Specified ProdSubTypeId already exists with a different name, cannot continue!'
		return
	END
END  
ELSE  
BEGIN  
	IF @CurrentProdSubTypeId <> @ProdSubTypeId
	BEGIN
		-- uh-oh, the sub type already exists with a different id!
		print 'Existing ProdSubTypeId (' + convert(varchar(50), @CurrentProdSubTypeId) + ' does not match supplied value (' + convert(varchar(50), @ProdSubTypeId) + ', cannot continue'
		return
	END
END  

SET @CurrentRefPlanType2ProdSubTypeId = 
							(
							SELECT RefPlanType2ProdSubTypeId 
							FROM TRefPlanType2ProdSubType 
							WHERE RefPlanTypeId = @RefPlanTypeId
							AND RegionCode = @RegionCode
							AND (ProdSubTypeId = @ProdSubTypeId OR (@ProdSubTypeId IS NULL AND ProdSubTypeId IS NULL)) 
							)

IF @CurrentRefPlanType2ProdSubTypeId IS NULL 
BEGIN  
	IF NOT EXISTS (SELECT 1 FROM TRefPlanType2ProdSubType WHERE RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId)
	BEGIN
		PRINT 'adding RefPlanType2ProdSubType'  
		
		SET IDENTITY_INSERT TRefPlanType2ProdSubType ON

		INSERT INTO	TRefPlanType2ProdSubType 
					(RefPlanType2ProdSubTypeId
					, RefPlanTypeId
					, ProdSubTypeId
					, DefaultCategory
					, ConcurrencyId
					, IsConsumerFriendly
					, RefPortfolioCategoryId
					, RefPlanDiscriminatorId
					, RegionCode)
		OUTPUT	INSERTED.RefPlanTypeId
				, INSERTED.ProdSubTypeId
				, INSERTED.RefPortfolioCategoryId
				, INSERTED.RefPlanDiscriminatorId
				, INSERTED.DefaultCategory
				, INSERTED.ConcurrencyId
				, INSERTED.RefPlanType2ProdSubTypeId
				, INSERTED.IsConsumerFriendly
				, INSERTED.RegionCode
				, @StampActionCreate, @StampDateTime, @StampUser
		INTO	TRefPlanType2ProdSubTypeAudit
				(RefPlanTypeId
				, ProdSubTypeId
				, RefPortfolioCategoryId
				, RefPlanDiscriminatorId
				, DefaultCategory
				, ConcurrencyId
				, RefPlanType2ProdSubTypeId
				, IsConsumerFriendly
				, RegionCode
				, StampAction
				, StampDateTime
				, StampUser)
		VALUES	(@RefPlanType2ProdSubTypeId, @RefPlanTypeId, @ProdSubTypeId, @DefaultCategory, 1, @IsConsumerFriendly, @RefPortfolioCategoryId, @RefPlanDiscriminatorId, @RegionCode)
		
		SET IDENTITY_INSERT TRefPlanType2ProdSubType OFF
	END
	ELSE
	BEGIN
		-- uh-oh, the RefPlanType2ProdSubTypeId is is already in use!
		PRINT 'Specified RefPlanType2ProdSubTypeId already exists with a different name, cannot continue!'
		RETURN
	END
END  
ELSE  
BEGIN  
	IF @CurrentRefPlanType2ProdSubTypeId <> @RefPlanType2ProdSubTypeId
	BEGIN
		-- uh-oh, the sub type already exists with a different id!
		PRINT 'Existing RefPlanType2ProdSubTypeId (' + convert(varchar(50),@CurrentRefPlanType2ProdSubTypeId) + ' does not match supplied value (' + convert(varchar(50),@RefPlanType2ProdSubTypeId) + ', cannot continue'
		RETURN
	END
	ELSE
		PRINT 'updating refplantype2prodsubtype'
		
		UPDATE	TRefPlanType2ProdSubType  
		SET		DefaultCategory = @DefaultCategory
		OUTPUT	INSERTED.RefPlanTypeId, INSERTED.ProdSubTypeId, INSERTED.RefPortfolioCategoryId, INSERTED.RefPlanDiscriminatorId, INSERTED.DefaultCategory, INSERTED.ConcurrencyId, INSERTED.RefPlanType2ProdSubTypeId
				, @StampActionUpdate, @StampDateTime, @StampUser, INSERTED.IsArchived, INSERTED.IsConsumerFriendly
		INTO	TRefPlanType2ProdSubTypeAudit 
				( RefPlanTypeId
				, ProdSubTypeId
				, RefPortfolioCategoryId
				, RefPlanDiscriminatorId
				, DefaultCategory
				, ConcurrencyId
				, RefPlanType2ProdSubTypeId
				, StampAction
				, StampDateTime
				, StampUser
				, IsArchived
				, IsConsumerFriendly)
		WHERE	RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId
END  
  
-- populate TRefLicenseTypeToRefPlanType2ProdSubType
DELETE FROM TRefLicenseTypeToRefPlanType2ProdSubType
OUTPUT DELETED.RefLicenseTypeId
		, DELETED.RefPlanType2ProdSubTypeId
		, DELETED.ConcurrencyId
		, DELETED.RefLicenseTypeToRefPlanType2ProdSubTypeId
		, @StampActionDelete
		, @StampDateTime
		, @StampUser
INTO	TRefLicenseTypeToRefPlanType2ProdSubTypeAudit	
WHERE	RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId

IF @LicenseType = 'all'
BEGIN
	PRINT 'adding TRefLicenseTypeToRefPlanType2ProdSubType for all license types'
	
	INSERT INTO TRefLicenseTypeToRefPlanType2ProdSubType 
				(RefLicenseTypeId, RefPlanType2ProdSubTypeId)
	OUTPUT	INSERTED.RefLicenseTypeId
			, INSERTED.RefPlanType2ProdSubTypeId
			, INSERTED.ConcurrencyId
			, INSERTED.RefLicenseTypeToRefPlanType2ProdSubTypeId
			, @StampActionCreate
			, @StampDateTime
			, @StampUser
	INTO	TRefLicenseTypeToRefPlanType2ProdSubTypeAudit
	SELECT	RefLicenseTypeId, @RefPlanType2ProdSubTypeId
	FROM	Administration..TRefLicenseType
END
ELSE
BEGIN
	PRINT 'adding TRefLicenseTypeToRefPlanType2ProdSubType for license type ' + @LicenseType
	
	IF NOT EXISTS (SELECT 1 FROM Administration..TRefLicenseType WHERE LicenseTypeName = @LicenseType)
	BEGIN
		PRINT 'unable to find license type ' + @LicenseType
		RETURN
	END
	
	INSERT INTO	TRefLicenseTypeToRefPlanType2ProdSubType
				(RefLicenseTypeId, RefPlanType2ProdSubTypeId)
	OUTPUT	INSERTED.RefLicenseTypeId
			, INSERTED.RefPlanType2ProdSubTypeId
			, INSERTED.ConcurrencyId
			, INSERTED.RefLicenseTypeToRefPlanType2ProdSubTypeId
			, @StampActionCreate
			, @StampDateTime
			, @StampUser
	INTO	TRefLicenseTypeToRefPlanType2ProdSubTypeAudit
	SELECT	RefLicenseTypeId, @RefPlanType2ProdSubTypeId
	FROM	Administration..TRefLicenseType
	WHERE	LicenseTypeName = @LicenseType
END
   
IF NOT EXISTS (  
 SELECT 1  
 FROM TRefFactFindCategoryPlanType  
 WHERE RefPlanTypeId = @RefPlanTypeId  
 )  
BEGIN  
 PRINT 'adding reffactfindcategoryplantype'  
 SET @RefFactFindCategoryId = (select RefFactFindCategoryId from treffactfindcategory where identfier = @FactFindCategory)  
 EXEC SpCreateRefFactFindCategoryPlanType '0', @FactFindCategory, @RefFactFindCategoryId, @RefPlanTypeId  
END  

-- link a new plan type to a Fact Find section
IF (@FactFindSection = '')
	SET @FactFindSection = null

IF (@FactFindSection != null OR Len(@FactFindSection) > 0)
BEGIN
	IF NOT EXISTS (
		SELECT	1 
		FROM	factfind..TRefPlanTypeToSection
		WHERE	RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId
	)
	BEGIN
		PRINT 'Adding Plan type to Fact Find Section.'
		INSERT INTO factfind..TRefPlanTypeToSection
			(
			RefPlanType2ProdSubTypeId
			, Section
			, ConcurrencyId
			)
		OUTPUT
			inserted.RefPlanType2ProdSubTypeId,
			inserted.Section,
			inserted.ConcurrencyId,
			inserted.RefPlanTypeToSectionId,
			@StampActionCreate,
			@StampDateTime,
			@StampUser
		INTO factfind..TRefPlanTypeToSectionAudit
			(RefPlanType2ProdSubTypeId,
			Section,
			ConcurrencyId,
			RefPlanTypeToSectionId,
			StampAction,
			StampDateTime,
			StampUser)
		VALUES 
			(@RefPlanType2ProdSubTypeId,
			@FactFindSection,
			1)
	END
END
  
DELETE FROM TRefPlanType2ProdSubTypeCategory
OUTPUT	DELETED.IndigoClientId
		, DELETED.RefPlanType2ProdSubTypeId
		, DELETED.PlanCategoryId
		, DELETED.ConcurrencyId
		, DELETED.RefPlanType2ProdSubTypeCategoryId
		, @StampActionDelete
		, @StampDateTime
		, @StampUser
INTO	TRefPlanType2ProdSubTypeCategoryAudit
WHERE	RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId  

INSERT INTO TRefPlanType2ProdSubTypeCategory 
		(IndigoClientId
		, RefPlanType2ProdSubTypeId
		, PlanCategoryId
		, ConcurrencyId)
OUTPUT	INSERTED.IndigoClientId
		, INSERTED.RefPlanType2ProdSubTypeId
		, INSERTED.PlanCategoryId
		, INSERTED.ConcurrencyId
		, INSERTED.RefPlanType2ProdSubTypeCategoryId
		, @StampActionCreate
		, @StampDateTime
		, @StampUser
INTO	TRefPlanType2ProdSubTypeCategoryAudit				
		(IndigoClientId
		, RefPlanType2ProdSubTypeId
		, PlanCategoryId
		, ConcurrencyId
		, RefPlanType2ProdSubTypeCategoryId
		, StampAction
		, StampDateTime
		, StampUser)
SELECT	pc.IndigoClientId, pst.RefPlanType2ProdSubTypeId, pc.PlanCategoryId, 1  
FROM	TPlanCategory pc  
JOIN	TRefPlanType2ProdSubType pst ON pc.PlanCategoryName = pst.DefaultCategory  
where	pst.RefPlanType2ProdSubTypeId  = @RefPlanType2ProdSubTypeId  

-- Check the Portfolio Report Settings
print 'adding reporter plan settings'  
EXEC Reporter..SpCustomCheckPlanSetting @RefPlanType2ProdSubTypeId, @PortfolioReportCategory, @PortfolioReportSubCategory   
END  

GO
