CREATE TABLE [dbo].[TDependants]
(
[DependantsId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[Name] [varchar] (512) NULL,
[DOB] [datetime] NULL,
[Age] [varchar] (512) NULL,
[AgeCustom] [tinyint] NULL,
[AgeCustomUntil] [tinyint] NULL,
[Relationship] [varchar] (512) NULL,
[DependantOf] [varchar] (512) NULL,
[FinDep] [bit] NULL,
[AgeOfInd] [varchar] (512) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDependants_ConcurrencyId] DEFAULT ((1)),
[MigrationRef] [varchar] (255) NULL,
[LivingWithClientId] [int] NULL,
[DependantDurationId] [int] NULL,
[FinancialDependencyEndingOn] [datetime] NULL,
[Notes] [varchar] (500) NULL
)
GO

ALTER TABLE [dbo].[TDependants] ADD CONSTRAINT [PK_TDependants] PRIMARY KEY NONCLUSTERED  ([DependantsId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDependants_CRMContactId] ON [dbo].[TDependants] ([CRMContactId])
GO
CREATE CLUSTERED INDEX [IX_TDependants_CRMContactId] ON [dbo].[TDependants] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TDependants_MigrationRef_CRMContactId_CRMContactId2] ON [dbo].[TDependants] ([MigrationRef], [CRMContactId], [CRMContactId2])
GO
CREATE NONCLUSTERED INDEX [IDX_TDependants_CRMContactId2] ON [dbo].[TDependants] ([CRMContactId2])
GO
