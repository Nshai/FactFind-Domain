CREATE TABLE [dbo].[TRefInsuranceCoverOption]
(
[RefInsuranceCoverOptionId] [int] NOT NULL IDENTITY(0, 1),
[FlagValue] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_RefInsuranceCoverOption_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefInsuranceCoverOption] ADD CONSTRAINT [PK_TRefInsuranceCoverOption] PRIMARY KEY CLUSTERED  ([RefInsuranceCoverOptionId])
GO
