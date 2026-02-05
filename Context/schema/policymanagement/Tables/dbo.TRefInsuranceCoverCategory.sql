CREATE TABLE [dbo].[TRefInsuranceCoverCategory]
(
[RefInsuranceCoverCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefInsuranceCoverCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefInsuranceCoverCategory] ADD CONSTRAINT [PK_TRefInsuranceCoverCategory] PRIMARY KEY CLUSTERED  ([RefInsuranceCoverCategoryId])
GO
