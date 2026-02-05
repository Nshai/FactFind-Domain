USE [crm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[nio_SearchVideoSharingClientsColumnList]
    @CorporateName VARCHAR(255) = NULL,
    @FirstName VARCHAR(255) = NULL,
    @LastName VARCHAR(255) = NULL,
    @PrimaryRef VARCHAR(50) = NULL,
    @SecondaryRef VARCHAR(50) = NULL,
    @AdviserCRMContactId BIGINT = 0,
    @ServiceStatusId BIGINT = NULL,
    @GroupId BIGINT = NULL,
    @ClientTag VARCHAR(100) = NULL,
    @PlanTypeId BIGINT = 0,
    @RefProdProviderId BIGINT = 0,
    @ProductName VARCHAR(50) = NULL,
    @Fund VARCHAR(50) = NULL,
    @CanContactForMarketingPurposes BIT = 0,
    @RelatedProductsServicesOnly BIT = 0,
    @_TopN INT = 5000
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    NULL AS [ClientId],
    NULL AS [LastName],
    NULL AS [FirstName],
    NULL AS [ServiceStatusName],
    NULL AS [CurrentAdviserName],
    NULL AS [CorporateName],
    NULL AS [PrimaryRef],
    NULL AS [SecondaryRef],
    NULL AS [AdviserCRMContactId],
    NULL AS [ServiceStatusId],
    NULL AS [GroupId],
    NULL AS [ClientTag],
    NULL AS [PlanTypeId],
    NULL AS [RefProdProviderId],
    NULL AS [ProductName],
    NULL AS [Fund],
    NULL AS [CanContactForMarketingPurposes],
    NULL AS [RelatedProductsServicesOnly]
GO