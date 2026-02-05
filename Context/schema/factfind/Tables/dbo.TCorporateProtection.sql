CREATE TABLE [dbo].[TCorporateProtection]
(
[CorporateProtectionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Objectives] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[LiabilitiesCovered] [bit] NULL,
[ReviewablePremiums] [bit] NULL,
[RenewCoverOption] [bit] NULL,
[CriticalIllnessCover] [bit] NULL,
[WrittenInTrust] [bit] NULL,
[ExistingProvision] [bit] NULL,
[ExistingContractsCancelled] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateProtection__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateProtection_CRMContactId] ON [dbo].[TCorporateProtection] ([CRMContactId])
GO
