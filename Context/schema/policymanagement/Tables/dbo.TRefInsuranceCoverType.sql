CREATE TABLE [dbo].[TRefInsuranceCoverType]
(
[RefInsuranceCoverTypeId] [int] NOT NULL IDENTITY(0, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_RefInsuranceCoverType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefInsuranceCoverType] ADD CONSTRAINT [PK_TRefInsuranceCoverType] PRIMARY KEY CLUSTERED  ([RefInsuranceCoverTypeId])
GO
