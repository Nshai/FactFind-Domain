CREATE TABLE [dbo].[TYourRetirement]
(
[YourRetirementId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[PreferredRetirementAge] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[IntendedRetirementDate] [datetime] NULL,
[ReqdAnnualIncome] [money] NULL,
[IncomeSources] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[InheritanceReqdYN] [bit] NULL,
[InheritanceReqdDet] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[PensionSchemeYN] [bit] NULL,
[PensionSchemeMemberYN] [bit] NULL,
[PensionSchemeEligibleYN] [bit] NULL,
[EligibleToJoin] [datetime] NULL,
[EmpSchemeNotJoinedDet] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[PreservedPensionYN] [bit] NULL,
[PreservedPensionDet] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[DetailsofTransferReqYN] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TYourReti__Concu__1837881B] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TYourRetirement] ADD CONSTRAINT [PK_TYourRetirement] PRIMARY KEY CLUSTERED  ([YourRetirementId])
GO
CREATE NONCLUSTERED INDEX [IDX_TYourRetirement_CRMContactId] ON [dbo].[TYourRetirement] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TYourRetirement_CRMContactId] ON [dbo].[TYourRetirement] ([CRMContactId])
GO
