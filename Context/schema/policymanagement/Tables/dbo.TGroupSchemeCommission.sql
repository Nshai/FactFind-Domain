CREATE TABLE [dbo].[TGroupSchemeCommission]
(
[GroupSchemeCommissionId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[PolicyExpectedCommissionId] [int] NOT NULL,
[SchemeCommissionRate] [decimal] (10, 2) NULL,
[SchemeCommissionType] [tinyint] NULL,
[IsCalculateCommissionDue] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeCommission_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TGroupSchemeCommission] ADD CONSTRAINT [PK_TGroupSchemeCommission] PRIMARY KEY NONCLUSTERED  ([GroupSchemeCommissionId])
GO
ALTER TABLE [dbo].[TGroupSchemeCommission] ADD CONSTRAINT [FK_TGroupSchemeCommission_GroupSchemeId_TGroupScheme] FOREIGN KEY ([GroupSchemeId]) REFERENCES [dbo].[TGroupScheme] ([GroupSchemeId])
GO
ALTER TABLE [dbo].[TGroupSchemeCommission] ADD CONSTRAINT [FK_TGroupSchemeCommission_PolicyExpectedCommissionId_TPolicyExpectedCommission] FOREIGN KEY ([PolicyExpectedCommissionId]) REFERENCES [dbo].[TPolicyExpectedCommission] ([PolicyExpectedCommissionId])
GO
