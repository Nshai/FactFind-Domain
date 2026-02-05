SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchClientFullSecureByAdviceCaseExport]      
 @IndigoClientId bigint,
 @SequentialRef varchar(50)= NULL,      
 @AdviceCaseName varchar(50)=NULL,   
 @_UserId bigint,      
 @_TopN int = 0      
AS      
      
-- User rights  
DECLARE @RightMask int, @AdvancedMask int  
SELECT @RightMask = 1, @AdvancedMask = 1  
  
-- Get Edit right for super viewers  
IF @_UserId < 0  
BEGIN  
 SELECT   
  @RightMask = RightMask,  
  @AdvancedMask = AdvancedMask  
 FROM  
  Administration..TUser U  
  JOIN Administration..TPolicy P ON P.RoleId = U.ActiveRole And P.EntityId = 2  
 WHERE  
  U.UserId = ABS(@_UserId)  
END  
  
--Fund stuff  
declare  @IsLimited bit  
  
select @IsLimited = 0  
  
-- Limit rows returned?  
IF (@_TopN > 0) SET ROWCOUNT @_TopN  

  
SELECT distinct  
 1 AS Tag,  
 NULL AS Parent,  
 T1.CRMContactId AS [CRMContact!1!CRMContactId],   
 T1.CRMContactType AS [CRMContact!1!CRMContactType],   
 ISNULL(T1.PersonId, '') AS [CRMContact!1!PersonId],   
 ISNULL(T1.CorporateId, '') AS [CRMContact!1!CorporateId],   
 ISNULL(T1.TrustId, '') AS [CRMContact!1!TrustId],   
 ISNULL(T1.AdvisorRef, '') AS [CRMContact!1!AdvisorRef],   
 ISNULL(T1.LastName, '')+ISNULL(T1.CorporateName, '') AS [CRMContact!1!LastName],   
 ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName],   
 ISNULL(T1.CorporateName, '') AS [CRMContact!1!CorporateName],   
 CASE  
  WHEN T1.CRMContactType = 1 THEN 'Person'  
  WHEN T1.CRMContactType = 2 THEN 'Trust'  
  WHEN T1.CRMContactType = 3 THEN 'Corporate'  
  WHEN T1.CRMContactType = 4 THEN 'Group'  
 END AS  [CRMContact!1!CRMContactTypeName],  
 ISNULL(T1.CorporateName, '') + ISNULL(T1.FirstName + ' ' + T1.LastName, '') AS [CRMContact!1!ClientName],  
 ISNULL(T1.CorporateName, '') + ISNULL(T1.LastName, '') AS [CRMContact!1!CRMContactLastNameCorporateName],  
 ISNULL(Plans.PolicyNumber, '') AS [CRMContact!1!PolicyNumber],  
 ISNULL(Plans.ProductName, '') AS [CRMContact!1!ProductName],  
 ISNULL(Plans.[Name], '') AS [CRMContact!1!PolicyStatus],  
 CONVERT(varchar(24), Plans.ChangedToDate, 120) AS [CRMContact!1!StatusDate],  
 ISNULL(Plans.PlanTypeName, '') AS [CRMContact!1!PolicyType],  
 ISNULL(Plans.CorporateName, '') AS [CRMContact!1!ProviderName],  
 T1.OriginalAdviserCRMId AS [CRMContact!1!OriginalAdviserCRMId],   
 T1.CurrentAdviserCRMId AS [CRMContact!1!CurrentAdviserCRMId],   
 ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName],  
 ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference],  
 T1.ConcurrencyId AS [CRMContact!1!ConcurrencyId],   
 ISNULL(T14.AddressLine1, '') AS [CRMContact!1!AddressLine1],  
 ISNULL(T14.AddressLine2, '') AS [CRMContact!1!AddressLine2],  
 ISNULL(T14.AddressLine3, '') AS [CRMContact!1!AddressLine3],  
 ISNULL(T14.AddressLine4, '') AS [CRMContact!1!AddressLine4],  
 ISNULL(T14.CityTown, '') AS [CRMContact!1!CityTown],  
 ISNULL(T14.PostCode, '') AS [CRMContact!1!PostCode],  
 ISNULL(T15.CountyName, '') AS [CRMContact!1!County],  
 ISNULL(T16.CountryName, '') AS [CRMContact!1!Country],  
 ISNULL(T18.Title, '') AS [CRMContact!1!Title],  
 ISNULL(T19.Value, '') AS [CRMContact!1!Telephone],  
 ISNULL(T20.Value, '') AS [CRMContact!1!Mobile],  
 ISNULL(T21.Value, '') AS [CRMContact!1!Fax],  
 ISNULL(T22.Value, '') AS [CRMContact!1!E-Mail],  
 ISNULL(T23.Value, '') AS [CRMContact!1!Web],  
    CASE T1._OwnerId  
  WHEN ABS(@_UserId) THEN 15  
     ELSE ISNULL(TCKey.RightMask|TEKey.RightMask, @RightMask)  
    END AS [CRMContact!1!_RightMask],  
    CASE T1._OwnerId  
  WHEN ABS(@_UserId) THEN 240  
  ELSE ISNULL(TCKey.AdvancedMask|TEKey.AdvancedMask, @AdvancedMask)   
    END AS [CRMContact!1!_AdvancedMask],  
 ISNULL(Plans.SequentialRef, '') AS [CRMContact!1!IOBReference],  
 ISNULL(Plans.PolicyBusinessId,0) AS [CRMContact!1!PolicyBusinessId]  
FROM   
 TAdviceCase AC WITH(NOLOCK)  
 JOIN TCRMContact T1 WITH(NOLOCK) ON AC.CRMContactId=T1.CRMContactId
 JOIN  
 (  
  SELECT  
   T7.PolicyBusinessId,  
   T2.CRMContactId,  
   T7.SequentialRef,  
   T7.PolicyNumber,  
   T7.ProductName,  
   T6.RefPlanTypeId,  
   T6.PlanTypeName,  
   T8.RefProdProviderId,  
   T10.ChangedToDate,  
   T9.CorporateName,  
   T11.[Name]  
  FROM  
   CRM..TAdviceCase A WITH(NOLOCK)
   JOIN CRM..TAdviceCasePlan AP WITH(NOLOCK) ON A.AdviceCaseId=AP.AdviceCaseId
   JOIN PolicyManagement..TPolicyBusiness T7 WITH(NOLOCK) ON AP.PolicyBusinessId = T7.PolicyBusinessId AND T7.IndigoClientId = @IndigoClientId  
   JOIN PolicyManagement..TPolicyDetail T3 WITH(NOLOCK) ON T7.PolicyDetailId=T3.PolicyDetailId
   JOIN PolicyManagement..TPolicyOwner T2 WITH(NOLOCK) ON T2.PolicyDetailId = T3.PolicyDetailId  
   JOIN PolicyManagement..TPlanDescription T4 WITH(NOLOCK) ON T3.PlanDescriptionId = T4.PlanDescriptionId  
   JOIN PolicyManagement..TRefPlanType2ProdSubType T5 WITH(NOLOCK) ON T4.RefPlanType2ProdSubTypeId = T5.RefPlanType2ProdSubTypeId  
   JOIN PolicyManagement..TRefPlanType T6 WITH(NOLOCK) ON T5.RefPlanTypeId = T6.RefPlanTypeId   
   JOIN PolicyManagement..TRefProdProvider T8 WITH(NOLOCK) ON T8.RefProdProviderId = T4.RefProdProviderId  
   JOIN TCRMContact T9 WITH(NOLOCK) ON T9.CRMContactId = T8.CRMContactId  
   JOIN PolicyManagement..TStatusHistory T10 WITH(NOLOCK) ON T10.PolicyBusinessId = T7.PolicyBusinessId  AND T10.CurrentStatusFG = 1  
   JOIN PolicyManagement..TStatus T11 WITH(NOLOCK) ON T11.StatusId = T10.StatusId AND ISNULL(T11.IntelligentOfficeStatusType, '') != 'Deleted'  
   LEFT JOIN PolicyManagement..TPolicyBusinessFund Pbf WITH(NOLOCK) ON Pbf.PolicyBusinessId = T7.PolicyBusinessId  
   LEFT JOIN Fund2..TFundUnit fu WITH(NOLOCK) ON fu.FundUnitId = Pbf.FundId AND Pbf.FromFeedFg = 1 AND pbf.EquityFg = 0      
   LEFT JOIN Fund2..TFund f WITH(NOLOCK) ON f.FundId = fu.FundId  
   LEFT JOIN PolicyManagement..TNonFeedFund Nff WITH(NOLOCK) ON Nff.NonFeedFundId = Pbf.FundId AND Pbf.FromFeedFg = 0      
  WHERE  
   T3.IndigoClientId = @IndigoClientId      
   AND (ISNULL(@SequentialRef,'')='' OR LTRIM(RTRIM(A.CaseRef))=LTRIM(RTRIM(@SequentialRef)))
   AND (ISNULL(@AdviceCaseName,'')='' OR LTRIM(RTRIM(A.CaseName)) LIKE @AdviceCaseName + '%')
 ) AS Plans ON Plans.CRMContactId = T1.CRMContactId  
 LEFT JOIN TPractitioner T12 WITH(NOLOCK) ON T12.CRMContactId = T1.CurrentAdviserCRMId  
 LEFT JOIN TAddress T13 WITH(NOLOCK) ON T13.CRMContactId = T1.CRMContactId AND T13.DefaultFG = 1  
 LEFT JOIN TAddressStore T14 WITH(NOLOCK) ON T14.AddressStoreId = T13.AddressStoreId  
 LEFT JOIN TRefCounty T15 WITH(NOLOCK) ON T15.RefCountyId = T14.RefCountyId  
 LEFT JOIN TRefCountry T16 WITH(NOLOCK) ON T16.RefCountryId = T14.RefCountryId  
 LEFT JOIN TPerson T18 WITH(NOLOCK) ON T18.PersonId = T1.PersonId  
 LEFT JOIN TContact T19 WITH(NOLOCK) ON T19.CRMContactId = T1.CRMContactId AND T19.DefaultFG = 1 AND T19.RefContactType = 'Telephone'  
 LEFT JOIN TContact T20 WITH(NOLOCK) ON T20.CRMContactId = T1.CRMContactId AND T20.DefaultFG = 1 AND T20.RefContactType = 'Mobile'  
 LEFT JOIN TContact T21 WITH(NOLOCK) ON T21.CRMContactId = T1.CRMContactId AND T21.DefaultFG = 1 AND T21.RefContactType = 'Fax'  
 LEFT JOIN TContact T22 WITH(NOLOCK) ON T22.CRMContactId = T1.CRMContactId AND T22.DefaultFG = 1 AND T22.RefContactType = 'E-Mail'  
 LEFT JOIN TContact T23 WITH(NOLOCK) ON T23.CRMContactId = T1.CRMContactId AND T23.DefaultFG = 1 AND T23.RefContactType = 'Web Site'
 -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)  
 LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey WITH(NOLOCK) ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId  
 LEFT JOIN VwCRMContactKeyByEntityId AS TEKey WITH(NOLOCK) ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId  
WHERE   
 T1.IndClientId = @IndigoClientId AND ISNULL(T1.RefCRMContactStatusId,0) = 1 AND T1.ArchiveFG=0   
 AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))  
 AND (@IsLimited=0 OR (@IsLimited=1 AND Plans.PolicyBusinessId IS NOT NULL))  
 AND (@SequentialRef IS NULL OR AC.CaseRef=@SequentialRef)
 AND (@AdviceCaseName IS NULL OR AC.CaseName LIKE @AdviceCaseName + '%')
ORDER BY   
 [CRMContact!1!CRMContactLastNameCorporateName] ASC, [CRMContact!1!FirstName] ASC  
FOR XML EXPLICIT  
  
IF (@_TopN > 0) SET ROWCOUNT 0  
RETURN (0)  
  
  
  
  
  
  
  
  
  
GO
