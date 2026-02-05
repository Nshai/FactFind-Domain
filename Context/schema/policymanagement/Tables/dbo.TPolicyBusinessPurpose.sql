CREATE TABLE [dbo].[TPolicyBusinessPurpose]
(
[PolicyBusinessPurposeId] [int] NOT NULL IDENTITY(1, 1),
[PlanPurposeId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessPurpose_ConcurrencyId] DEFAULT ((1)),
PlanMigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TPolicyBusinessPurpose] ADD CONSTRAINT [PK_TPolicyBusinessPurpose] PRIMARY KEY NONCLUSTERED  ([PolicyBusinessPurposeId])
GO
CREATE CLUSTERED INDEX [IDX1_TPolicyBusinessPurpose_PolicyBusinessId] ON [dbo].[TPolicyBusinessPurpose] ([PolicyBusinessId])
GO
CREATE UNIQUE INDEX UX_TPolicyBusinessPurpose ON [dbo].[TPolicyBusinessPurpose] ([PlanPurposeId], [PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyBusinessPurpose] ADD CONSTRAINT [FK_TPolicyBusinessPurpose_PlanPurposeId_PlanPurposeId] FOREIGN KEY ([PlanPurposeId]) REFERENCES [dbo].[TPlanPurpose] ([PlanPurposeId])
GO
ALTER TABLE [dbo].[TPolicyBusinessPurpose] WITH CHECK ADD CONSTRAINT [FK_TPolicyBusinessPurpose_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
create index IX_TPolicyBusinessPurpose_PlanMigrationRef on TPolicyBusinessPurpose(PlanMigrationRef) 
go 
