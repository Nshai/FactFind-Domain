CREATE TABLE [dbo].[TValPotentialPlan]
(
[ValPotentialPlanId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValuationProviderId] [int] NULL,
[PolicyProviderId] [int] NULL,
[PolicyProviderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NULL,
[PolicyBusinessId] [int] NOT NULL,
[SequentialRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PolicyDetailId] [int] NULL,
[PolicyNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FormattedPolicyNumber] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[PortalReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FormattedPortalReference] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[AgencyNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefPlanType2ProdSubTypeId] [int] NULL,
[ProviderPlanType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NINumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[LastName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Postcode] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[PolicyStatusId] [int] NULL,
[PolicyStartDate] [datetime] NULL,
[PolicyOwnerCRMContactID] [int] NULL,
[SellingAdviserCRMContactID] [int] NULL,
[SellingAdviserStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ServicingAdviserCRMContactID] [int] NULL,
[ServicingAdviserStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ExtendValuationsByServicingAdviser] [bit] CONSTRAINT [DF_TValPotentialPlan_ExtendValuationsByServicingAdviser] Default 0,
[IsExcluded] [bit] CONSTRAINT [DF_TValPotentialPlan_IsExcluded] Default 0,
[IsTopup] [bit] CONSTRAINT [DF_TValPotentialPlan_IsTopup] Default 0,
[EligibilityMask] [int] NULL,
[EligibilityMaskRequiresUpdating] [bit] NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValPotentialPlan] ADD CONSTRAINT [PK_TValPotentialPlan] PRIMARY KEY NONCLUSTERED([ValPotentialPlanId],[PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX IX_TValPotentialPlan_IndigoClientId_PolicyBusinessId on TvalPotentialPlan (IndigoClientId,PolicyBusinessId) INCLUDE (EligibilityMask,PolicyNumber,PolicyOwnerCRMContactID,PolicyProviderName,PolicyStartDate,PortalReference,RefPlanType2ProdSubTypeId,SellingAdviserCRMContactID,ValuationProviderId)
go
CREATE NONCLUSTERED INDEX [IX_TValPotentialPlan_PolicyBusinessId_EligibilityMaskRequiresUpdating_ValuationProviderId] ON [dbo].[TValPotentialPlan] ([PolicyBusinessId],[EligibilityMaskRequiresUpdating], [ValuationProviderId])
go

