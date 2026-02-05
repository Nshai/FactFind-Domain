CREATE TABLE [dbo].[TWrapperPolicyBusiness]
(
[WrapperPolicyBusinessId] [int] NOT NULL IDENTITY(1, 1),
[ParentPolicyBusinessId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWrapperPolicyBusiness_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TWrapperPolicyBusiness] ADD CONSTRAINT [PK_TWrapperPolicyBusiness] PRIMARY KEY CLUSTERED  ([WrapperPolicyBusinessId])
GO
ALTER TABLE [dbo].[TWrapperPolicyBusiness] ADD CONSTRAINT [FK_TWrapperPolicyBusiness_ParentPolicyBusinessId_TPolicyBusiness] FOREIGN KEY ([ParentPolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TWrapperPolicyBusiness] ADD CONSTRAINT [FK_TWrapperPolicyBusiness_PolicyBusinessId_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX IX_TWrapperPolicyBusiness_PolicyBusinessId
ON [dbo].[TWrapperPolicyBusiness] ([PolicyBusinessId])
INCLUDE ([ParentPolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX IX_TWrapperPolicyBusiness_ParentPolicyBusinessId ON [dbo].[TWrapperPolicyBusiness] ([ParentPolicyBusinessId]) 
go