SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].SpGetPolicyDetailsWithPotentialPlans
    @PlanId INT,
    @ClientPartyId INT,
    @LoggedOnUserId INT,
    @TenantId INT,
    @AddressType INT,
    @CredentialOf INT
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    EXEC PolicyManagement.dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

    SELECT
    -- Plan
        pb.PolicyBusinessId AS Id,
        pb.SequentialRef,
        pb.PolicyNumber,
        pb.PolicyStartDate,
        pbe.PortalReference,
        ptr.RefPlanTypeId,
        ptr.ProdSubTypeId,
        mpt.PlanTypeName AS RefPlanTypeName,
        spt.ProdSubTypeName AS ProdSubTypeName,
    -- Selling Adviser
        sa.CRMContactId AS PartyId,
        sap.FirstName,
        sap.LastName,
        saas.Postcode,
    -- Tenant
        t.IndigoClientId AS Id,
        t.Identifier AS [Name],
        t.SIB,
        t.FSA,
        t.Postcode,
    -- Owner
        po.CRMContactId AS PartyId,
      po.FirstName,
        po.LastName,
    -- Provider
        pp.RefProdProviderId AS Id,
        pp.Name,
      CASE WHEN pc.ValProviderConfigId IS NOT NULL THEN 1 ELSE 0 END AS HasProviderConfig,
        pc.AuthenticationType,
        pc.OrigoResponderId,
        pc.PostURL,
        pc.ValuationProviderCode,
        g.ImplementationCode,
        g.OrigoProductType,
        g.OrigoProductVersion,
    -- Credential User
        cu.CRMContactId AS PartyId,
        cac.CurrentAdviserCRMId AS CurrentPartyId,
        cu.UserId,
        ca.FSAReference,
        ca.PractitionerId,
        caas.Postcode,
        cug.FSARegNbr AS GroupFSA,
        cap.FirstName,
        cap.LastName,
        CASE WHEN cups.ValPortalSetupId IS NOT NULL THEN 1 ELSE 0 END AS HasCredentials,
        cups.UserName,
        PolicyManagement.dbo.FnCustomDecryptPortalPassword(cups.Password2) AS PasswordDecrypted,
        cups.Passcode,
        @LoggedOnUserId AS LoggedOnUserId,
        loggedonuser.CrmContactId AS LoggedOnUserPartyId,
        CASE WHEN cuc.CertificateId IS NOT NULL THEN 1 ELSE 0 END AS HasCertificate,
        cuc.Issuer,
        cuc.SerialNumber,
        cuc.[Subject],
        cuc.ValidFrom,
        cuc.ValidUntil

    -- sa: selling adviser
    -- ca: credential adviser
    FROM TPolicyBusiness pb
        -- Plan related
        INNER JOIN TPolicyBusinessExt pbe ON pbe.PolicyBusinessId = pb.PolicyBusinessId
        INNER JOIN TPolicyDetail pd ON pd.PolicyDetailId = pb.PolicyDetailId
        INNER JOIN TPlanDescription pdesc ON pdesc.PlanDescriptionId = pd.PlanDescriptionId
        INNER JOIN administration..TIndigoClient t ON t.IndigoClientId = pd.IndigoClientId
        INNER JOIN TRefPlanType2ProdSubType ptr ON ptr.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
        INNER JOIN TRefPlanType mpt ON mpt.RefPlanTypeId = ptr.RefPlanTypeId
      LEFT JOIN TProdSubType spt ON spt.ProdSubTypeId = ptr.ProdSubTypeId
      LEFT JOIN VPlanOwnerExt po ON po.PolicyBusinessId = @PlanId AND po.CRMContactId = @ClientPartyId
      LEFT JOIN crm..TCRMContact poc ON poc.CRMContactId = @ClientPartyId

      -- Provider related
        LEFT JOIN TValLookUp pl ON pl.RefProdProviderId = pdesc.RefProdProviderId
        LEFT JOIN VProvider pp ON pp.RefProdProviderId = COALESCE(pl.MappedRefProdProviderId, pdesc.RefProdProviderId) -- always reference pp to use mapped provider
        LEFT JOIN TValGating g ON g.RefProdProviderId = pp.RefProdProviderId
                    AND g.RefPlanTypeId = ptr.RefPlanTypeId
                    AND ((ptr.ProdSubTypeId IS NULL AND g.ProdSubTypeId IS NULL) OR g.ProdSubTypeId = ptr.ProdSubTypeId)
        LEFT JOIN TValProviderConfig pc ON pc.RefProdProviderId = pp.RefProdProviderId

        -- Selling Adviser Data
        INNER JOIN crm..TPractitioner sa ON sa.PractitionerId = pb.PractitionerId
        INNER JOIN crm..TCRMContact sac ON sac.CRMContactId = sa.CRMContactId
        LEFT JOIN crm..TPerson sap ON sap.PersonId = sac.PersonId
        LEFT JOIN crm..TAddressStore saas ON saas.AddressStoreId =
          ( SELECT TOP 1 saa.AddressStoreId
            FROM crm..TAddress saa
            WHERE saa.CRMContactId = sa.CRMContactId AND saa.RefAddressTypeId = @AddressType)

        -- Credential Adviser data
        LEFT JOIN administration..TUser cu ON
        (((@CredentialOf = 0 AND cu.UserId = @LoggedOnUserId) OR
        (@CredentialOf = 1 AND cu.CRMContactId = sa.CRMContactId) OR
        (@CredentialOf = 2 AND cu.CRMContactId = poc.CurrentAdviserCRMId))
        AND
        cu.Indigoclientid = @TenantId)
        LEFT JOIN administration..TGroup cug ON cug.GroupId = cu.GroupId
        LEFT JOIN crm..TPractitioner ca ON ca.CRMContactId = cu.CRMContactId
        LEFT JOIN crm..TCRMContact cac ON cac.CRMContactId = cu.CRMContactId
        LEFT JOIN crm..TPerson cap ON cap.PersonId = cac.PersonId
        LEFT JOIN TValPortalSetup cups ON cups.CRMContactId = cu.CRMContactId AND cups.RefProdProviderId = pp.RefProdProviderId
        LEFT JOIN Administration..TCertificate cuc ON cuc.CRMContactId = cu.CRMContactId AND cuc.IsRevoked = 0 AND cuc.HasExpired = 0
        LEFT JOIN crm..TAddressStore caas ON caas.AddressStoreId =
          ( SELECT TOP 1 caa.AddressStoreId
            FROM crm..TAddress caa
            WHERE caa.CRMContactId = ca.CRMContactId AND caa.RefAddressTypeId = @AddressType)
      INNER JOIN Administration..tuser loggedonuser ON loggedonuser.userid = @LoggedOnUserId AND loggedonuser.Indigoclientid = @TenantId

    WHERE pb.PolicyBusinessId = @PlanId
        AND pb.IndigoClientId = @TenantId


    SELECT
        vpp.PolicyBusinessId AS Id,
        vpp.PolicyNumber
    FROM TWrapperPolicyBusiness pw
        INNER JOIN TValPotentialPlan vpp ON vpp.PolicyBusinessId = pw.PolicyBusinessId
    WHERE pw.ParentPolicyBusinessId = @PlanId
END;
