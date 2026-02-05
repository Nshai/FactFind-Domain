CREATE TABLE [dbo].[TRefEmploymentType]
(
[RefEmploymentTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefBenefitPeriod_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEmploymentType] ADD CONSTRAINT [PK_TRefEmploymentType] PRIMARY KEY CLUSTERED  ([RefEmploymentTypeId])
GO
