CREATE TABLE [dbo].[TPropertytobeMortgagedQuestion]
(
[PropertytobeMortgagedQuestionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[iscurrentresidence] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPropertytobeMortgagedQuestion_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPropertytobeMortgagedQuestion] ADD CONSTRAINT [PK_TPropertytobeMortgagedQuestion] PRIMARY KEY NONCLUSTERED  ([PropertytobeMortgagedQuestionId]) WITH (FILLFACTOR=80)
GO
