SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveAUPensionSummary] @PolicyBusinessId BIGINT,@TenantId BIGINT,@ProductTypeId BIGINT
AS
     BEGIN

         DECLARE @ContributionType_Regular BIGINT,
                 @ContributorType_Self BIGINT,
                 @FrequencyId_Single BIGINT,
                 @ContributionType_LumpSum BIGINT,
                 @ContributionType_Transfer BIGINT,
                 @ContributionType_Rebate BIGINT;

         SELECT @ContributionType_Regular = RefContributionTypeId
           FROM PolicyManagement..TRefContributionType
           WHERE RefContributionTypeName = 'Regular'
             AND RetireFg = 0; --value = 1      

         SELECT @ContributorType_Self = RefContributorTypeId
           FROM PolicyManagement..TRefContributorType
           WHERE RefContributorTypeName = 'Self'
             AND RetireFg = 0; --value = 1      

         SELECT @FrequencyId_Single = RefFrequencyId
           FROM PolicyManagement..TRefFrequency
           WHERE FrequencyName = 'Single'
             AND RetireFg = 0; --value = 10      

         SELECT @ContributionType_LumpSum = RefContributionTypeId
           FROM PolicyManagement..TRefContributionType
           WHERE RefContributionTypeName = 'Lump Sum'
             AND RetireFg = 0; --value = 2       

         SELECT @ContributionType_Transfer = RefContributionTypeId
           FROM PolicyManagement..TRefContributionType
           WHERE RefContributionTypeName = 'Transfer'
             AND RetireFg = 0; --value = 3      

         SELECT @ContributionType_Rebate = RefContributionTypeId
           FROM PolicyManagement..TRefContributionType
           WHERE RefContributionTypeName = 'Rebate'
             AND RetireFg = 0; --value = 4      

         SELECT pp.protectionid,
                pld.refplantype2prodsubtypeid,
                p.policybusinessid,
                p.policynumber,
                p.ProductName,
                policymanagement.dbo.FNRetrieveAdviceCasesForPolicyBusiness( @PolicyBusinessId ) AS AdviceCasesCSV,
                Prov.RefProdProviderId AS ProductProviderId,
                Prov.CRMContactId AS ProductProviderPartyId,
                p.ProviderAddress,
                p.AgencyNumber,
                PractC.CRMContactId AS SellingAdviserPartyId,
                CASE
                WHEN PractC.PersonId IS NOT NULL THEN PractC.FirstName + ' ' + PractC.LastName
                    ELSE PractC.CorporateName
                END AS SellingAdviserName,
                TnCC.CRMContactId AS TnCCoachPartyId,
                CASE
                WHEN TnCC.PersonId IS NOT NULL THEN TnCC.FirstName + ' ' + TnCC.LastName
                    ELSE TnCC.CorporateName
                END AS TnCCoachName,
                p.servicingUserId,
                CASE
                WHEN ServicingCRM.PersonId IS NOT NULL THEN ServicingCRM.FirstName + ' ' + ServicingCRM.LastName
                    ELSE ServicingCRM.CorporateName
                END AS servicingUserName,
                p.paraplannerUserId,
                CASE
                WHEN ParaplannerCRM.PersonId IS NOT NULL THEN ParaplannerCRM.FirstName + ' ' + ParaplannerCRM.LastName
                    ELSE ParaplannerCRM.CorporateName
                END AS paraplannerUserName,
                p.policystartdate,
                p.sequentialref,
                PExt.ReportNotes,
                PExt.PortalReference,
                BT.[Description] AS BandingTemplateName,
                pd.policydetailid,
                po.CRMContactId AS Owner1PartyId,
                CASE
                WHEN O1C.PersonId IS NOT NULL THEN O1C.FirstName + ' ' + O1C.LastName
                    ELSE O1C.CorporateName
                END AS Owner1Name,
                po2.CRMContactId AS Owner2PartyId,
                CASE
                WHEN O2C.PersonId IS NOT NULL THEN O2C.FirstName + ' ' + O2C.LastName
                    ELSE O2C.CorporateName
                END AS Owner2Name,
                CASE
                WHEN SH.StatusReasonId IS NOT NULL THEN S.Name + ' (' + SR.Name + ')'
                    ELSE S.Name
                END AS CurrentStatusName,
                p.indigoclientid,
                P.MaturityDate AS PolicyEndDate,
                P.OffPanelFg AS AdviceOffPanel,
                P.BaseCurrency AS BaseCurrency,
                P.ExpectedPaymentDate,
                PMI.PolicyMoneyInId AS PremiumPolicyMoneyInId,
                ISNULL( p.TotalLumpSum,0 ) AS LumpSumAmount,
                PMI.Amount AS PremiumAmount,
                PMI.RefFrequencyId AS PremiumRefFrequencyId,
                PMI.StartDate AS PremiumStartDate,
                PMI.StopDate AS PremiumEndDate,
                PExt.WrapperCharge,
                PExt.InitialAdviceCharge,
                PExt.AnnualCharges,
                PExt.OngoingAdviceCharge,
                GSh.SchemeName AS SchemeName,
                GSh.JoiningDate AS JoiningDate,
                GSh.LeavingDate AS LeavingDate,
                P.BestAdvicePanelUsedFG AS IsBestAdvicePanelUsed,
                GSh.Categoryname AS CategoryName,
                GSh.NominatedBeneficiary AS NominatedBeneficiary,
                PExt.MigrationRef AS MigrationRef,
                AT.[Description] AS AdviceTypeLifecycleName,
                p.IsGuaranteedToProtectOriginalInvestment AS IsGuaranteedToProtectOriginalInvestment,
                p.ClientTypeId,
                RCT.Name AS ClientTypeName,
                Opp.SequentialRef AS OpportunitySequentialRef,
                Opp.OpportunityId AS OpportunityId,
                p.LowMaturityValue,
                p.MediumMaturityValue,
                p.HighMaturityValue,
                p.ProjectionDetails,
			 PExt.IsVisibleToClient,
			 PExt.IsVisibilityUpdatedByStatusChange,
			 PExt.IsPlanValueVisibleToClient,
			 PExt.FundIncome,
			 PExt.AdditionalNotes,
			 PInfo.optionsAvailableatRetirement,
			 PInfo.otherBenefitsAndMaterialFeatures,
			 CAST(PExt.IsTargetMarket as INT) AS TargetMarketId,
			 PExt.TargetMarketExplanation,
			 b1.PensionCommencementLumpSum AS TaxFree,
			 pinfo.TaxFreePercentageOfIncome,
			 PInfo.CentrelinkDeductibleAmount,
			 b1.BenefitId,
			 b1.SpousesOrDependentsPercentage,
			 b1.IsSpousesBenefit,
			 pp.ReviewDate AS NextReviewDate,
			 pd.GrossAnnualIncome,
             pd.RefAnnuityPaymentTypeId,
             pd.CapitalElement,
             pd.AssumedGrowthRatePercentage
           FROM policymanagement..tpolicybusiness p
                LEFT JOIN PolicyManagement..TPolicyBusinessExt PExt
                  ON PExt.PolicyBusinessId = p.PolicyBusinessId
                LEFT JOIN Commissions..TBandingTemplate BT
                  ON BT.BandingTemplateId = PExt.BandingTemplateId
                JOIN policymanagement..tpolicydetail pd
                  ON pd.policydetailid = p.policydetailid
                JOIN( 
                      SELECT MIN( PolicyOwnerId ) AS PolicyOwnerId1,
                             MAX( PolicyOwnerId ) AS PolicyOwnerId2,
                             PolicyDetailId
                        FROM policymanagement..tpolicyowner
                        GROUP BY PolicyDetailId ) Owners
                  ON Owners.PolicyDetailId = pd.PolicyDetailId
                JOIN policymanagement..tpolicyowner po
                  ON po.PolicyOwnerId = Owners.PolicyOwnerId1
                JOIN CRM..TCRMContact O1C
                  ON O1C.CRMContactId = po.CRMContactId
                LEFT JOIN policymanagement..tpolicyowner po2
                  ON po2.PolicyOwnerId = Owners.PolicyOwnerId2
                 AND (Owners.PolicyOwnerId2 != Owners.PolicyOwnerId1)
                LEFT JOIN CRM..TCRMContact O2C
                  ON O2C.CRMContactId = po2.CRMContactId
                LEFT JOIN Compliance..TTnCCoach TnC
                  ON TnC.TnCCoachId = p.TnCCoachId
                LEFT JOIN Administration..TUser U
                  ON U.UserId = TnC.UserId
                LEFT JOIN CRM..TCRMContact TnCC
                  ON TnCC.CRMContactId = U.CRMContactId
                LEFT JOIN Administration..TUser ServicingUser
                  ON ServicingUser.UserId = p.ServicingUserId
                LEFT JOIN CRM..TCRMContact ServicingCRM
                  ON ServicingUser.CRMContactId = ServicingCRM.CRMContactId

                LEFT JOIN Administration..TUser ParaplannerUser
                  ON ParaplannerUser.UserId = p.ParaplannerUserId
                LEFT JOIN CRM..TCRMContact ParaplannerCRM
                  ON ParaplannerUser.CRMContactId = ParaplannerCRM.CRMContactId

                JOIN CRM..TPractitioner Pract
                  ON Pract.PractitionerId = p.PractitionerId
                JOIN CRM..TCRMContact PractC
                  ON PractC.CRMContactId = Pract.CRMContactId
                INNER JOIN PolicyManagement..TAdviceType AT
                  ON AT.AdviceTypeId = p.AdviceTypeId
                JOIN PolicyManagement..TStatusHistory SH
                  ON SH.PolicyBusinessId = P.PolicyBusinessId
                 AND SH.CurrentStatusFG = 1
                JOIN PolicyManagement..TStatus S
                  ON S.StatusId = SH.StatusId
                LEFT JOIN PolicyManagement..TStatusReason SR
                  ON SR.StatusReasonId = SH.StatusReasonId
                JOIN policymanagement..tplandescription pld
                  ON pld.plandescriptionid = pd.plandescriptionid
                JOIN PolicyManagement..TRefProdProvider Prov
                  ON Prov.RefProdProviderId = pld.RefProdProviderId
                LEFT JOIN PolicyManagement..TPolicyMoneyIn PMI
                  ON PMI.PolicyBusinessId = p.PolicyBusinessId
                 AND PMI.CurrentFG = 1
                 AND PMI.RefContributionTypeId = @ContributionType_Regular -- Regular Contribution      

                 AND PMI.RefContributorTypeId = @ContributorType_Self -- Self Contributions      

                 AND PMI.RefFrequencyId != @FrequencyId_Single -- Exclude single frequency -- BAU 809      
                LEFT JOIN( 
                           SELECT PMIL.PolicyBusinessId,
                                  SUM( Amount ) AS LumpSumAmount
                             FROM PolicyManagement..TPolicyMoneyIn PMIL
                             WHERE PMIL.RefContributorTypeId = @ContributorType_Self -- Self Contributions      

                               AND (PMIL.RefContributionTypeId = @ContributionType_Rebate -- Rebate Contribution -- IO-18736

                                 OR PMIL.RefContributionTypeId = @ContributionType_Transfer -- Transfer Contribution -- IO-18736

                                 OR PMIL.RefContributionTypeId = @ContributionType_LumpSum -- Lump Sum Contribution      

                                 OR (PMIL.RefContributionTypeId = @ContributionType_Regular -- Regular Contribution --BAU-809      

                                 AND PMIL.RefFrequencyId = @FrequencyId_Single -- Single Frequency      

                                    ))
                             GROUP BY PMIL.PolicyBusinessId ) AS PMI2
                  ON PMI2.PolicyBusinessId = p.PolicyBusinessId
                LEFT JOIN policymanagement..TProtection pp
                  ON pp.policybusinessid = p.policybusinessid --new code re life assured      
                LEFT JOIN policymanagement..tbenefit b1
                  ON b1.PolicyBusinessId = p.PolicyBusinessId
                LEFT JOIN CRM..TOpportunityPolicyBusiness OppPlan
                  ON OppPlan.PolicyBusinessId = p.PolicyBusinessid
                LEFT JOIN CRM..TOpportunity Opp
                  ON Opp.OpportunityId = OppPlan.OpportunityId --Scheme Details
                LEFT JOIN(
                         --Main Group Plan
                         SELECT GS.SchemeName,
                                JoiningDate = NULL,
                                LeavingDate = NULL,
                                GS.PolicyBusinessId,
                                GSC.CategoryName,
                                NominatedBeneficiary = NULL
                           FROM PolicyManagement..TGroupScheme GS
                                LEFT JOIN PolicyManagement..TGroupSchemeCategory GSC
                                  ON GS.GroupSchemeId = GSC.GroupSchemeId
                           WHERE GS.PolicyBusinessId = @PolicyBusinessId
                         UNION ALL

                         --Member Plan
                         SELECT GS.SchemeName,
                                GSM.JoiningDate,
                                GSM.LeavingDate,
                                GSM.PolicyBusinessId,
                                GSC.CategoryName,
                                GSM.NominatedBeneficiary
                           FROM PolicyManagement..TGroupSchemeMember GSM
                                LEFT JOIN PolicyManagement..TGroupScheme GS
                                  ON GSM.GroupSchemeId = GS.GroupSchemeId
                                LEFT JOIN PolicyManagement..TGroupSchemeCategory GSC
                                  ON GSM.GroupSchemeCategoryId = GSC.GroupSchemeCategoryId
                           WHERE GSM.PolicyBusinessId = @PolicyBusinessId ) GSh
                  ON GSh.PolicyBusinessId = P.PolicyBusinessId
                LEFT JOIN PolicyManagement..TRefClientType RCT
                  ON RCT.RefClientTypeId = p.ClientTypeId
				LEFT JOIN policymanagement..TPensionInfo pinfo on pinfo.PolicyBusinessId  = p.PolicyBusinessId
           WHERE p.policybusinessid = @PolicyBusinessId
             AND p.indigoclientid = @TenantId
             AND pld.refplantype2prodsubtypeid = @ProductTypeId;

     END;


GO


