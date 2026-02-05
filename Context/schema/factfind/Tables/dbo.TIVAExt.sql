CREATE TABLE [dbo].[TIVAExt]
(
[IVAExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[beenBancruptIVAFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIVAExt_ConcurrencyId] DEFAULT ((1))
)
GO
