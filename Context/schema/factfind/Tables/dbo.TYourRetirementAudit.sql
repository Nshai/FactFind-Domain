CREATE TABLE [dbo].[TYourRetirementAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
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
[CRMContactId] [int] NOT NULL,
[YourRetirementId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TYourReti__Concu__6BEEF189] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TYourRetirementAudit] ADD CONSTRAINT [PK_TYourRetirementAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
