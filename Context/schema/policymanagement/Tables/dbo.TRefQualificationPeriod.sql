CREATE TABLE [dbo].[TRefQualificationPeriod]
(
[RefQualificationPeriodId] [int] NOT NULL IDENTITY(1, 1),
[QualificationPeriod] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefQualificationPeriod_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefQualificationPeriod] ADD CONSTRAINT [PK_TRefQualificationPeriod] PRIMARY KEY CLUSTERED  ([RefQualificationPeriodId])
GO
