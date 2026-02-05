SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VPolicyBusiness

AS

SELECT        PB.PolicyBusinessId, PB.PolicyDetailId, PB.PolicyNumber, PB.PractitionerId, PB.ReplaceNotes, PB.TnCCoachId, PB.AdviceTypeId, PB.BestAdvicePanelUsedFG, 

                         PB.WaiverDefermentPeriod, PB.IndigoClientId, PB.SwitchFG, PB.TotalRegularPremium, PB.TotalLumpSum, PB.MaturityDate, PB.LifeCycleId, PB.PolicyStartDate, 

                         PB.PremiumType, PB.AgencyNumber, PB.ProviderAddress, PB.OffPanelFg, PB.BaseCurrency, PB.ExpectedPaymentDate, PB.ProductName, PB.InvestmentTypeId, 

                         PB.RiskRating, PB.SequentialRef, PB.ConcurrencyId, PB.IsGuaranteedToProtectOriginalInvestment, PB.ClientTypeId, PB.PlanMigrationRef, PB.UsePriceFeed, 

                         PB.LowMaturityValue, PB.MediumMaturityValue, PB.HighMaturityValue, PB.ProjectionDetails, PB.TopupMasterPolicyBusinessId, PB.ServicingUserId as ServicingUserId, 

                         P.CRMContactId AS AdviserCRMContactId, U.CRMContactId AS TnCCoachCRMContactId, AU.CRMContactId AS ServicingCRMContactId, PB.PropositionTypeId,PB.ParaplannerUserId, PB.PerformanceStartDate, PB.PerformanceEndDate

FROM            dbo.TPolicyBusiness AS PB INNER JOIN

                         crm.dbo.TPractitioner AS P ON P.PractitionerId = PB.PractitionerId LEFT OUTER JOIN

                         compliance.dbo.TTnCCoach AS TnC ON TnC.TnCCoachId = PB.TnCCoachId LEFT OUTER JOIN

                         administration.dbo.TUser AS U ON U.UserId = TnC.UserId LEFT OUTER JOIN

                         administration.dbo.TUser AS AU ON AU.UserId = PB.ServicingUserId

GO
