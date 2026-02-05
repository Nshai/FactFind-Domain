CREATE TABLE [dbo].[TRefUnEmpAndDisabilityBenefitType]
(
[RefUnEmpAndDisabilityBenefitTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefUnEmpAndDisabilityBenefitType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefUnEmpAndDisabilityBenefitType] ADD CONSTRAINT [PK_TRefUnEmpAndDisabilityBenefitType] PRIMARY KEY CLUSTERED  ([RefUnEmpAndDisabilityBenefitTypeId])
GO
