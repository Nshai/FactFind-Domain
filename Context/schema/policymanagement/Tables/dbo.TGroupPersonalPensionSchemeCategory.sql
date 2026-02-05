CREATE TABLE [dbo].[TGroupPersonalPensionSchemeCategory]
(
[GroupPersonalPensionSchemeCategoryId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeCategoryId] [int] NOT NULL,
[RefCoverToId] [int] NULL,
[AccrualRate] [int] NULL,
[RefSalaryExchangeforEmployerId] [int] NULL,
[EmployerPercentagetoPension] [decimal] (8, 2) NULL,
[RefSalaryExchangeforEmployeeId] [int] NULL,
[IsEarlyRetirementOption] [bit] NOT NULL CONSTRAINT [DF_TGroupPersonalPensionSchemeCategory_IsEarlyRetirementOption] DEFAULT ((0)),
[IsLateRetirementOption] [bit] NOT NULL CONSTRAINT [DF_TGroupPersonalPensionSchemeCategory_IsLateRetirementOption] DEFAULT ((0)),
[EarliestRetirementAge] [int] NULL,
[LatestRetirementAge] [int] NULL,
[IsSchemeLinkedtoGroupLife] [bit] NOT NULL CONSTRAINT [DF_TGroupPersonalPensionSchemeCategory_IsSchemeLinkedtoGroupLife] DEFAULT ((0)),
[MSRtoEmployerContribution] [int] NULL,
[RefMinimumServiceRequirementTypeId] [int] NULL,
[RefChangesTakeEffectId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupPersonalPensionSchemeCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TGroupPersonalPensionSchemeCategory] ADD CONSTRAINT [PK_TGroupPersonalPensionSchemeCategory] PRIMARY KEY CLUSTERED  ([GroupPersonalPensionSchemeCategoryId])
GO
ALTER TABLE [dbo].[TGroupPersonalPensionSchemeCategory] ADD CONSTRAINT [FK_TGroupPersonalPensionSchemeCategory_TRefChangesTakeEffect] FOREIGN KEY ([RefChangesTakeEffectId]) REFERENCES [dbo].[TRefChangesTakeEffect] ([RefChangesTakeEffectId])
GO
ALTER TABLE [dbo].[TGroupPersonalPensionSchemeCategory] ADD CONSTRAINT [FK_TGroupPersonalPensionSchemeCategory_TRefCoverTo] FOREIGN KEY ([RefCoverToId]) REFERENCES [dbo].[TRefCoverTo] ([RefCoverToID])
GO
ALTER TABLE [dbo].[TGroupPersonalPensionSchemeCategory] ADD CONSTRAINT [FK_TGroupPersonalPensionSchemeCategory_TRefMinimumServiceRequirementType] FOREIGN KEY ([RefMinimumServiceRequirementTypeId]) REFERENCES [dbo].[TRefMinimumServiceRequirementType] ([RefMinimumServiceRequirementTypeId])
GO
ALTER TABLE [dbo].[TGroupPersonalPensionSchemeCategory] ADD CONSTRAINT [FK_TGroupPersonalPensionSchemeCategory_TRefSalaryExchangeforEmployee] FOREIGN KEY ([RefSalaryExchangeforEmployeeId]) REFERENCES [dbo].[TRefSalaryExchangeforEmployee] ([RefSalaryExchangeforEmployeeId])
GO
ALTER TABLE [dbo].[TGroupPersonalPensionSchemeCategory] ADD CONSTRAINT [FK_TGroupPersonalPensionSchemeCategory_TRefSalaryExchangeforEmployer] FOREIGN KEY ([RefSalaryExchangeforEmployerId]) REFERENCES [dbo].[TRefSalaryExchangeforEmployer] ([RefSalaryExchangeforEmployerId])
GO
