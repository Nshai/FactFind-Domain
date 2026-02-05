CREATE TABLE [dbo].[TPolicyBusinessFundAttributeMask]
(
[PolicyBusinessFundAttributeMaskId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessFundId] [int] NOT NULL,
[AttributeMask] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessFundAttributeMask_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBusinessFundAttributeMask] ADD CONSTRAINT [PK_TPolicyBusinessFundAttributeMask] PRIMARY KEY CLUSTERED  ([PolicyBusinessFundAttributeMaskId])
GO
CREATE NONCLUSTERED INDEX IX_TPolicyBusinessFundAttributeMask_PolicyBusinessFundId ON [dbo].[TPolicyBusinessFundAttributeMask] ([PolicyBusinessFundId]) INCLUDE ([AttributeMask])
GO