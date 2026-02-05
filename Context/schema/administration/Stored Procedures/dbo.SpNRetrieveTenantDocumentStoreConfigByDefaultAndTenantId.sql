SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveTenantDocumentStoreConfigByDefaultAndTenantId]
	@tenantId bigint,
	@default bit
AS
Select 
	   [StorageConfigId]
      ,[Name]
      ,[DocStoreType]
      ,[TenantId]
      ,[Default]
      ,[ReadOnly]
      ,[BucketName]
      ,[SecretKey]
      ,[AccessKey]
      ,[Region]
      ,[EncryptionAlgorithm]
      ,[CreationDate]
      ,[CreatedBy]
      ,[CreatedByOidcClientId]
      ,[EncryptionProfileId]
From Administration.dbo.TTenantDocumentStoreConfig
Where TenantId = @tenantId
and [default] = @default
GO