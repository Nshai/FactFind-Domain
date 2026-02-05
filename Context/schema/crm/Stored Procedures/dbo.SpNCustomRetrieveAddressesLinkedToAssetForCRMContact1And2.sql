SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAddressesLinkedToAssetForCRMContact1And2] 
        @CRMContactId1 bigint,
        @CRMContactId2 bigint,
        @PropertyDetailCreation bit = 0,
        @ExcludeDuplicates bit = 0
AS
    IF OBJECT_ID(N'tempdb..#DATA') IS NOT NULL
    BEGIN
        DROP TABLE #DATA
    END

    SELECT 1 AS TAG
    ,NULL AS Parent
    ,A.AddressId AS [Address!1!AddressId]
    ,B.AddressStoreId AS [Address!1!AddressStoreId]
    ,ISNULL(B.AddressLine1,'') AS [Address!1!AddressLine1]
    ,ISNULL(B.AddressLine2,'') AS [Address!1!AddressLine2]
    ,ISNULL(B.AddressLine3,'') AS [Address!1!AddressLine3]
    ,ISNULL(B.AddressLine4,'') AS [Address!1!AddressLine4]
    ,ISNULL(B.CityTown,'') AS [Address!1!CityTown]
    ,ISNULL(C.CountyName,'') AS [Address!1!County]
    ,ISNULL(B.PostCode,'') AS [Address!1!PostCode]
    ,(ROW_NUMBER() OVER(PARTITION BY B.AddressLine1 ORDER BY B.AddressStoreId)) AS row_num
    INTO #DATA
    FROM [factfind].[dbo].[TAssets] Asset
    INNER JOIN [crm].[dbo].[TAddress] A ON A.AddressId = Asset.AddressId
    INNER JOIN  [crm].[dbo].[TAddressStore] B ON A.AddressStoreId=B.AddressStoreId
    LEFT JOIN [crm].[dbo].[TRefCounty] C ON B.RefCountyId=C.RefCountyId
    LEFT JOIN [factfind].[dbo].[TPropertyDetail] PD ON (@PropertyDetailCreation = 1 AND PD.RelatedAddressStoreId = B.AddressStoreId)
    WHERE (A.CRMContactId IN (@CRMContactId1, @CRMContactId2)) 
            AND NOT A.CRMContactId = 0 
            AND (@PropertyDetailCreation = 0 OR PD.PropertyDetailId IS NULL OR A.IsPotentialMortgage IS NULL OR A.IsPotentialMortgage = 0)

    UNION

    SELECT 1 AS TAG
    ,NULL AS Parent
    ,A.AddressId AS [Address!1!AddressId]
    ,B.AddressStoreId AS [Address!1!AddressStoreId]
    ,ISNULL(B.AddressLine1,'')AS [Address!1!AddressLine1]
    ,ISNULL(B.AddressLine2,'')AS [Address!1!AddressLine2]
    ,ISNULL(B.AddressLine3,'')AS [Address!1!AddressLine3]
    ,ISNULL(B.AddressLine4,'')AS [Address!1!AddressLine4]
    ,ISNULL(B.CityTown,'')AS [Address!1!CityTown]
    ,ISNULL(C.CountyName,'')AS [Address!1!County]
    ,ISNULL(B.PostCode,'')AS [Address!1!PostCode]
    ,(ROW_NUMBER() OVER(PARTITION BY B.AddressLine1 ORDER BY B.AddressStoreId)) AS row_num
    FROM [crm].[dbo].[TAddress] A
    JOIN [crm].[dbo].[TAddressStore] B ON A.AddressStoreId=B.AddressStoreId    
    LEFT JOIN [crm].[dbo].[TRefCounty] C ON B.RefCountyId=C.RefCountyId    
    LEFT JOIN [factfind].[dbo].[TPropertyDetail] PD ON (1 = 1 AND PD.RelatedAddressStoreId = B.AddressStoreId)
    WHERE (A.CRMContactId IN (@CRMContactId1, @CRMContactId2)) 
            AND NOT A.CRMContactId = 0 
            AND (@PropertyDetailCreation = 0 OR PD.PropertyDetailId IS NULL OR A.IsPotentialMortgage IS NULL OR A.IsPotentialMortgage = 0)
            AND A.RefAddressStatusId = 4

    SELECT 
        TAG
        ,Parent
        ,[Address!1!AddressId]
        ,[Address!1!AddressStoreId]
        ,[Address!1!AddressLine1]
        ,[Address!1!AddressLine2]
        ,[Address!1!AddressLine3]
        ,[Address!1!AddressLine4]
        ,[Address!1!CityTown]
        ,[Address!1!County]
        ,[Address!1!PostCode]
    FROM #DATA t
    WHERE (@ExcludeDuplicates = 1 AND row_num = 1) OR @ExcludeDuplicates = 0
    ORDER BY t.[Address!1!AddressLine1]
    FOR XML EXPLICIT
GO