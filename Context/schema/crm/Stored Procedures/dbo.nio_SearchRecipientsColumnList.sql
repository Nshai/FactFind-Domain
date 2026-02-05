USE [crm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[nio_SearchRecipientsColumnList]
    @ExcludeDeceased BIT = 1,
    @IncludePfpRegistered BIT = 1,
    @PlanTypeId BIGINT = 0, 
    @RefProdProviderId BIGINT = 0, 
    @AdviserCRMContactId BIGINT = 0, 
    @ProductName VARCHAR(50) = NULL,        
    @ServiceStatusId BIGINT = NULL, 
    @Fund VARCHAR(50) = NULL, 
    @GroupId BIGINT = NULL, 
    @SecondaryRef VARCHAR(50) = NULL,
    @FeeCategoryId BIGINT = 0, 
    @FeeTypeId BIGINT = 0,
    @FeeChargingTypeId BIGINT = 0, 
    @FeeStatusId BIGINT = 0,    
    @ClientTag VARCHAR(100) = NULL,
    @IncludeDeleted BIT = 0,
    @CanContactForMarketingPurposes BIT = 0,
    @RelatedProductsServicesOnly BIT = 0,
    @_TopN INT = 5000
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    NULL AS [ClientId],     
    NULL AS [LastName],   
    NULL AS [FirstName],    
    NULL AS [CurrentAdviserName],     
    NULL AS [ServiceStatusName],     
    NULL AS [Salutation],
    NULL AS [PfpUserEmail],
    NULL AS [AdviserCRMContactId],
    NULL AS [GroupId],
    NULL AS [PlanTypeId],   
    NULL AS [RefProdProviderId],
    NULL AS [ProductName],
    NULL AS [ServiceStatusId],     
    NULL AS [Fund], 
    NULL AS [SecondaryRef],     
    NULL AS [FeeCategoryId],
    NULL AS [FeeTypeId],     
    NULL AS [FeeChargingTypeId],   
    NULL AS [FeeStatusId],    
    NULL AS [ClientTag],     
    NULL AS [IncludeDeleted],
    NULL AS [CanContactForMarketingPurposes],
    NULL AS [RelatedProductsServicesOnly]
GO