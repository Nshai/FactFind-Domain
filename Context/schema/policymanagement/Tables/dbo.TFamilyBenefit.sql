CREATE TABLE [dbo].[TFamilyBenefit]
(
[FamilyBenefitId] [int] NOT NULL IDENTITY(1, 1),
[IncomeBenefitFG] [bit] NOT NULL,
[Amount] [money] NULL,
[RefFrequencyId] [int] NULL,
[UntilDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFamilyBenefit] ADD CONSTRAINT [PK_TFamilyBenefit] PRIMARY KEY CLUSTERED  ([FamilyBenefitId])
GO
