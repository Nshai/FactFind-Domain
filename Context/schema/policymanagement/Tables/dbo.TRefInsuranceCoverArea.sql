CREATE TABLE [dbo].[TRefInsuranceCoverArea]
(
[RefInsuranceCoverAreaId] [int] NOT NULL IDENTITY(0, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_RefInsuranceCoverArea_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefInsuranceCoverArea] ADD CONSTRAINT [PK_TRefInsuranceCoverArea] PRIMARY KEY CLUSTERED  ([RefInsuranceCoverAreaId])
GO
