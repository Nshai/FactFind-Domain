SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.SpNCustomRetrieveMortgagePlanSummaryDetails
(
    @PolicyBusinessId BIGINT,
    @TenantId BIGINT,
    @CRMContactId BIGINT
)
AS
    SELECT
    pb.PolicyBusinessId,
    pb.ProductName,
    m.FeatureExpiryDate,
    m.InterestRate,
    m.RepayDebtFg AS IsRepayDebt,
    m.LoanAmount,
    m.LTV,
    m.MortgageRefNo,
    m.MortgageTerm,
    mrm.MortgageRepaymentMethod,
    m.TargetCompletionDate,
    m.PriceValuation,
    CASE
        WHEN practCont.PersonId IS NOT NULL THEN practCont.FirstName+' '+ practCont.LastName
        ELSE practCont.CorporateName
    END AS SellingAdviserName,
    CASE
        WHEN sc.PersonId IS NOT NULL THEN sc.FirstName+' '+ sc.LastName
        ELSE sc.CorporateName
    END AS ServicingAdminName,
    m.RedemptionFigure,
    m.RedemptionFigure2 AS RedemptionFigure2ndCharge,
    m.NetProceed,
    STUFF(
        COALESCE(', ' + NULLIF(ast.AddressLine1, ''), '') +
        COALESCE(', ' + NULLIF(ast.AddressLine2, ''), '') +
        COALESCE(', ' + NULLIF(ast.AddressLine3, ''), '') +
        COALESCE(', ' + NULLIF(ast.AddressLine4, ''), '') +
        COALESCE(', ' + NULLIF(ast.CityTown, ''), '') +
        COALESCE(', ' + cty.CountyName, '') +
        COALESCE(', ' + ctry.CountryName, '') +
        COALESCE(', ' + NULLIF(ast.PostCode, ''), ''), 1, 2, '') AS MortgageAddress,
    p.FSAReference,
    g.FSARegNbr AS GroupFSARegistrationNumber,
    g.Identifier AS GroupName,
    parentGroup.Identifier AS ParentGroupName,
    (SELECT SUM(ExpectedAmount)
    FROM policymanagement..TPolicyDetail pd
    INNER JOIN policymanagement..TPolicyBusiness pb2 ON pb2.PolicyDetailId = pd.PolicyDetailId
    INNER JOIN policymanagement..TPolicyExpectedCommission pec ON pec.PolicyBusinessId = pb2.PolicyBusinessId
    INNER JOIN policymanagement.dbo.TStatusHistory sh ON pb2.PolicyBusinessId = sh.PolicyBusinessId AND sh.CurrentStatusFG = 1
    INNER JOIN policymanagement.dbo.TStatus s ON sh.StatusId = s.StatusId AND s.IntelligentOfficeStatusType != 'Deleted'
    WHERE pd.PolicyDetailId = pb.PolicyDetailId) AS CommissionAndProcFees,
    sol.SolicitorName,
    sol.SolicitorTelephone,
    sol.SolicitorEmail,
    sol.SolicitorCompany,
    ea.EstateAgentName,
    ea.EstateAgentTelephone,
    ea.EstateAgentEmail,
    ea.EstateAgentCompany,
    (SELECT TOP 1 ff.FactFindId 
    FROM factfind..TFactFind ff
    WHERE CRMContactId1 = @CRMContactId
    ORDER BY ff.FactFindId DESC) AS FactFindId
    FROM policymanagement..TPolicyBusiness pb
    INNER JOIN CRM..TPractitioner p On p.PractitionerId = pb.PractitionerId
    INNER JOIN CRM..TCRMContact practCont ON practCont.CRMContactId = p.CRMContactId
    LEFT JOIN  policymanagement..TMortgage m ON pb.PolicyBusinessId = m.PolicyBusinessId
    LEFT JOIN policymanagement..TRefMortgageRepaymentMethod mrm ON mrm.RefMortgageRepaymentMethodId = m.RefMortgageRepaymentMethodId
    LEFT JOIN administration..TUser su On su.UserId = pb.ServicingUserId
    LEFT JOIN CRM..TCRMContact sc ON su.CRMContactId = sc.CRMContactId
    LEFT JOIN administration..TUser u ON u.CRMContactId = p.CRMContactId
    LEFT JOIN administration..TGroup g ON g.GroupId = u.GroupId
    LEFT JOIN administration..TGroup parentGroup ON parentGroup.GroupId = g.ParentId
    -- Most recent Solicitor
    LEFT JOIN (SELECT TOP 1 pb2pc.PolicyBusinessId
                , pc.ContactName AS SolicitorName
                , CASE
                    WHEN ISNULL(pc.TelephoneNumber, '') = '' THEN pc.MobileNumber
                    WHEN ISNULL(pc.MobileNumber, '') = '' THEN pc.TelephoneNumber
                    ELSE CONCAT(pc.TelephoneNumber, ' \ ', pc.MobileNumber)
                 END AS SolicitorTelephone
                , pc.EmailAddress AS SolicitorEmail
                , pc.CompanyName AS SolicitorCompany
                FROM policymanagement..TPolicyBusinessToProfessionalContact pb2pc
                INNER JOIN factfind..TProfessionalContact pc ON pc.ProfessionalContactId = pb2pc.ProfessionalContactId AND pc.ContactType = 'Solicitor'
                WHERE pb2pc.PolicyBusinessId = @PolicyBusinessId AND pb2pc.TenantId = @TenantId
                ORDER BY pb2pc.PolicyBusinessToProfessionalContactId DESC) sol ON sol.PolicyBusinessId = pb.PolicyBusinessId
    -- Most recent Estate Agent
    LEFT JOIN (SELECT TOP 1 @PolicyBusinessId AS PolicyBusinessId
                , pc.ContactName AS EstateAgentName
                , CASE
                    WHEN ISNULL(pc.TelephoneNumber, '') = '' THEN pc.MobileNumber
                    WHEN ISNULL(pc.MobileNumber, '') = '' THEN pc.TelephoneNumber
                    ELSE CONCAT(pc.TelephoneNumber, ' \ ', pc.MobileNumber)
                END AS EstateAgentTelephone
                , pc.EmailAddress AS EstateAgentEmail
                , pc.CompanyName AS EstateAgentCompany
                FROM factfind..TProfessionalContact pc
                WHERE pc.CRMContactId = @CRMContactId AND pc.ContactType = 'Estate Agent'
                ORDER BY pc.ProfessionalContactId DESC) ea ON ea.PolicyBusinessId = pb.PolicyBusinessId
    LEFT JOIN CRM..TAddressStore ast ON ast.AddressStoreId = m.AddressStoreId
    LEFT JOIN CRM..TRefCounty cty ON cty.RefCountyId = ast.RefCountyId  
    LEFT JOIN CRM..TRefCountry ctry ON ctry.RefCountryId = ast.RefCountryId
    WHERE pb.IndigoClientId = @TenantId
    AND pb.PolicyBusinessId = @PolicyBusinessId;

    -- Get Fees for calculation
    SELECT f.FeeId
    FROM policymanagement..TFee2Policy f2p
    INNER JOIN policymanagement..TFee f ON f.FeeId = f2p.FeeId
    INNER JOIN (SELECT FeeId, MAX(FeeStatusId) AS FeeStatusId
                FROM policymanagement..TFeeStatus
                GROUP BY FeeId) fs ON fs.FeeId = f2p.FeeId
    INNER JOIN policymanagement..TFeeStatus fs2 ON fs2.FeeStatusId = fs.FeeStatusId
    WHERE f2p.PolicyBusinessId = @PolicyBusinessId AND fs2.Status IN ('Paid', 'Payment Received', 'Due');
GO