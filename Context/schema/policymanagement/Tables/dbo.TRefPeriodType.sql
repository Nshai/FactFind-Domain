CREATE TABLE [dbo].[TRefPeriodType]
(
[RefPeriodTypeId] [int] NOT NULL IDENTITY(1, 1),
[PeriodTypeName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefPeriodType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPeriodType] ADD CONSTRAINT [PK_TRefPeriodType] PRIMARY KEY CLUSTERED  ([RefPeriodTypeId])
GO
