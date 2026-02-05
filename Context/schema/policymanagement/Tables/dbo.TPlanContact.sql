CREATE TABLE [dbo].[TPlanContact]
(
[PlanContactId] [int] NOT NULL IDENTITY(1, 1),
[SubjectId] [int] NOT NULL,
[SubjectType] [varchar] (50) NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[IsTrusted] [bit] NOT NULL CONSTRAINT [DF_TPlanContract_IsTrusted] DEFAULT (1)
)
GO
ALTER TABLE [dbo].[TPlanContact] ADD CONSTRAINT [PK_TPlanContact] PRIMARY KEY NONCLUSTERED ([PlanContactId])
GO
ALTER TABLE [dbo].[TPlanContact] WITH CHECK ADD  CONSTRAINT [FK_TPlanContact_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId])
REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO