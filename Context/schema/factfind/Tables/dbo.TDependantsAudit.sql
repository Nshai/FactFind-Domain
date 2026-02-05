CREATE TABLE [dbo].[TDependantsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (512) NULL,
[DOB] [datetime] NULL,
[Age] [varchar] (512) NULL,
[AgeCustom] [tinyint] NULL,
[AgeCustomUntil] [tinyint] NULL,
[Relationship] [varchar] (512) NULL,
[DependantOf] [varchar] (512) NULL,
[FinDep] [bit] NULL,
[AgeOfInd] [varchar] (512) NULL,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[DependantsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDependantsAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) NULL,
[MigrationRef] [varchar] (255) NULL,
[DependantDurationId] [int] NULL,
[LivingWithClientId] [int] NULL,
[FinancialDependencyEndingOn] [datetime] NULL,
[Notes] [varchar] (500) NULL
)
GO
ALTER TABLE [dbo].[TDependantsAudit] ADD CONSTRAINT [PK_TDependantsAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDependantsAudit_DependantsId_ConcurrencyId] ON [dbo].[TDependantsAudit] ([DependantsId], [ConcurrencyId])
GO
