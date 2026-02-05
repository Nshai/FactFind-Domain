CREATE TABLE [dbo].[TCorporateProtectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Objectives] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[LiabilitiesCovered] [bit] NULL,
[ReviewablePremiums] [bit] NULL,
[RenewCoverOption] [bit] NULL,
[CriticalIllnessCover] [bit] NULL,
[WrittenInTrust] [bit] NULL,
[ExistingProvision] [bit] NULL,
[ExistingContractsCancelled] [bit] NULL,
[CorporateProtectionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateProtectionAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCorporateProtectionAudit] ADD CONSTRAINT [PK_TCorporateProtectionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
