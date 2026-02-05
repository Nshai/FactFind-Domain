CREATE TABLE [dbo].[TExistingProvisionExt]
(
[ExistingProvisionExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[existingMortgFg] [bit] NULL,
[numExistingMortgages] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExistingProvisionExt_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TExistingProvisionExt] ADD CONSTRAINT [PK_TExistingProvisionExt] PRIMARY KEY NONCLUSTERED  ([ExistingProvisionExtId]) WITH (FILLFACTOR=80)
GO
