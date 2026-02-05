CREATE TABLE [dbo].[TPensionableSalary]
(
[PensionableSalaryId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[PensionableSalary] [money] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[IsCurrent] [bit] NULL,
[ActionDate] [datetime] NULL,
[HasBeenActioned] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPensionableSalary_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPensionableSalary] ADD CONSTRAINT [PK_TPensionableSalary] PRIMARY KEY NONCLUSTERED ([PensionableSalaryId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPensionableSalary_PolicyBusinessId] ON [dbo].[TPensionableSalary] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPensionableSalary] WITH CHECK ADD CONSTRAINT [FK_TPensionableSalary_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO

