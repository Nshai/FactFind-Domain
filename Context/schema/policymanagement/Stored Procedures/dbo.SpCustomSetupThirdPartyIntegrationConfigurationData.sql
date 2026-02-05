SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSetupThirdPartyIntegrationConfigurationData]
	@SourceTenantId BIGINT,
	@NewTenantId BIGINT

AS

/*
This Procedure safely inserts Third Party Integration Configuration Data (TApplicationLink, TApplicationProductGroupAccess, TRefProductLink)
for the specified @NewTenantId using the Data of the @SourceTenantId as a source. 
Data is only inserted if it doesn't exist

This procedure can ultimately replace any other procedures in the tenant configuration process. It is impossbile to find, in the miriad of procedures 
being used, all the instances where third party configuration data is being added so, this procedure has been written to insert all the necessary data 
on it's own BUT it still works if data has already been inserted by another procedure as it wont insert duplicate data. Duplicate checking is based on 
as narrow set of criteria as possible (2 required columns that can only have a specific value) so, even if config data is inserted somewhere else that is 
slightly different from the data for the source tenant used in this procedure (for instance, AllowAccess set to 0 instead of 1), it will still be recognised 
as already being present and will not be duplicated. 

IP-56794
17/07/2019: Clone SystemArchived, otherwise, will cause errors when Source tenant has SystemArchived=1
*/

DECLARE @StampActionCreate CHAR(1), @StampDateTime DATETIME, @StampUserSystem CHAR(1)
SELECT @StampActionCreate = 'C', @StampDateTime = GETDATE(), @StampUserSystem = '0'

BEGIN TRANSACTION

	-- TApplicationLink
	INSERT
		PolicyManagement..TApplicationLink(IndigoClientId, RefApplicationId, AllowAccess, IntegratedSystemConfigRole, WealthLinkEnabled, SystemArchived)
	OUTPUT
		inserted.IndigoClientId, inserted.RefApplicationId, inserted.MaxLicenceCount, inserted.CurrentLicenceCount, inserted.AllowAccess, inserted.ExtranetURL, inserted.ReferenceCode, inserted.ConcurrencyId, inserted.ApplicationLinkId, @StampActionCreate, @StampDateTime, @StampUserSystem, inserted.IntegratedSystemConfigRole, inserted.WealthLinkEnabled, inserted.SystemArchived
	INTO
		PolicyManagement..TApplicationLinkAudit (IndigoClientId, RefApplicationId, MaxLicenceCount, CurrentLicenceCount, AllowAccess, ExtranetURL, ReferenceCode, ConcurrencyId, ApplicationLinkId, StampAction, StampDateTime, StampUser, IntegratedSystemConfigRole, WealthLinkEnabled, SystemArchived)
	SELECT
		@NewTenantId, Src.RefApplicationId, Src.AllowAccess, Src.IntegratedSystemConfigRole, Src.WealthLinkEnabled, Src.SystemArchived
	FROM
		PolicyManagement..TApplicationLink Src
		LEFT JOIN PolicyManagement..TApplicationLink Dest ON Dest.RefApplicationId = Src.RefApplicationId 
			AND (dest.IntegratedSystemConfigRole=src.IntegratedSystemConfigRole OR (dest.IntegratedSystemConfigRole is null and src.IntegratedSystemConfigRole is null))
			AND Dest.IndigoClientId = @NewTenantId
	WHERE
		Src.IndigoClientId = @SourceTenantId
		AND Dest.ApplicationLinkId IS NULL
		
	-- TApplicationProductGroupAccess
	INSERT
		PolicyManagement..TApplicationProductGroupAccess(ApplicationLinkId, RefProductGroupId, AllowAccess)
	OUTPUT
		inserted.ApplicationLinkId, inserted.RefProductGroupId, inserted.AllowAccess, inserted.ConcurrencyId, inserted.ApplicationProductGroupAccessId, @StampActionCreate, @StampDateTime, @StampUserSystem
	INTO
		PolicyManagement..TApplicationProductGroupAccessAudit (ApplicationLinkId, RefProductGroupId, AllowAccess, ConcurrencyId, ApplicationProductGroupAccessId, StampAction, StampDateTime, StampUser)
	SELECT 
		AL.ApplicationLinkId, Src.RefProductGroupId, Src.AllowAccess
	FROM
		PolicyManagement..TApplicationProductGroupAccess Src
		JOIN PolicyManagement..TApplicationLink SrcAL ON SrcAL.ApplicationLinkId = Src.ApplicationLinkId
			AND SrcAL.IndigoClientId = @SourceTenantId
		JOIN PolicyManagement..TApplicationLink AL ON AL.RefApplicationId = SrcAL.RefApplicationId
			AND (AL.IntegratedSystemConfigRole=srcAL.IntegratedSystemConfigRole OR (AL.IntegratedSystemConfigRole is null and AL.IntegratedSystemConfigRole is null))
			AND AL.IndigoClientId = @NewTenantId
		LEFT JOIN PolicyManagement..TApplicationProductGroupAccess Dest ON Dest.ApplicationLinkId = AL.ApplicationLinkId 
			AND Dest.RefProductGroupId = Src.RefProductGroupId
	WHERE
		Dest.ApplicationProductGroupAccessId IS NULL

	-- TRefProductLink
	INSERT
		PolicyManagement..TRefProductLink (ApplicationLinkId, Src.RefProductTypeId, Src.ProductGroupData, Src.ProductTypeData, Src.IsArchived)
	OUTPUT
		inserted.ApplicationLinkId, inserted.RefProductTypeId, inserted.ProductGroupData, inserted.ProductTypeData, inserted.IsArchived, inserted.ConcurrencyId, inserted.RefProductLinkId, @StampActionCreate, @StampDateTime, @StampUserSystem
	INTO
		PolicyManagement..TRefProductLinkAudit(ApplicationLinkId, RefProductTypeId, ProductGroupData, ProductTypeData, IsArchived, ConcurrencyId, RefProductLinkId, StampAction, StampDateTime, StampUser)
	SELECT 
		 AL.ApplicationLinkId, Src.RefProductTypeId, Src.ProductGroupData, Src.ProductTypeData, Src.IsArchived
	FROM
		PolicyManagement..TRefProductLink Src
		JOIN PolicyManagement..TApplicationLink SrcAL ON SrcAL.ApplicationLinkId = Src.ApplicationLinkId
			AND SrcAL.IndigoClientId = @SourceTenantId
		JOIN PolicyManagement..TApplicationLink AL ON AL.RefApplicationId = SrcAL.RefApplicationId
			AND (AL.IntegratedSystemConfigRole=srcAL.IntegratedSystemConfigRole OR (AL.IntegratedSystemConfigRole is null and AL.IntegratedSystemConfigRole is null))
			AND AL.IndigoClientId = @NewTenantId
		LEFT JOIN PolicyManagement..TRefProductLink Dest ON Dest.ApplicationLinkId = AL.ApplicationLinkId
			AND Dest.RefProductTypeId = Src.RefProductTypeId
	WHERE
		Dest.RefProductLinkId IS NULL

	-- Inserting entry into TIntegratedSystemDocumentMapping for FE Analytics 

	Declare @ApplicationName VARCHAR(255) ='FE Analytics'
	Declare @Identifier VARCHAR(255) = 'Fund Research'
		
	INSERT INTO TIntegratedSystemDocumentMapping(ApplicationLinkId
			,IsSaveDocuments
			,DocumentCategoryId
			,DocumentSubCategoryId
			,ConcurrencyId)
		OUTPUT INSERTED.ApplicationLinkId
				,INSERTED.IsSaveDocuments
				,INSERTED.DocumentCategoryId
				,INSERTED.DocumentSubCategoryId
				,INSERTED.ConcurrencyId
				,INSERTED.IntegratedSystemDocumentMappingId
				,@StampActionCreate
				,@StampDateTime
				,@StampUserSystem
		INTO TIntegratedSystemDocumentMappingAudit(ApplicationLinkId
				,IsSaveDocuments
				,DocumentCategoryId
				,DocumentSubCategoryId
				,ConcurrencyId
				,IntegratedSystemDocumentMappingId
				,StampAction
				,StampDateTime
				,StampUser)
		SELECT AL.ApplicationLinkId, 1, C.CategoryId, SC.SubCategoryId, 1 FROM administration..TIndigoClient IC 
			INNER JOIN policymanagement..TApplicationLink AL ON AL.IndigoClientId = IC.IndigoClientId 
			INNER JOIN policymanagement..TRefApplication RA ON Al.RefApplicationId = RA.RefApplicationId AND RA.ApplicationName = @ApplicationName
			INNER JOIN documentmanagement..TCategory C ON C.IndigoClientId =IC.IndigoClientId AND  C.Identifier = @ApplicationName 
			INNER JOIN documentmanagement..TSubCategory SC ON SC.IndigoClientId = IC.IndigoClientId AND Sc.Identifier= @Identifier
			LEFT OUTER JOIN PolicyManagement.dbo.TIntegratedSystemDocumentMapping ISDM ON ISDM.ApplicationLinkId = Al.ApplicationLinkId				
			WHERE ISDM.IntegratedSystemDocumentMappingId IS NULL	

COMMIT
GO
