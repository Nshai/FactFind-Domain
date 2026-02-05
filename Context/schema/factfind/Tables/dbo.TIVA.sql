CREATE TABLE [dbo].[TIVA]
(
[IVAId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ivaCurrentFg] [bit] NULL,
[ivaNoYears] [int] NULL,
[ivaDate] [datetime] NULL,
[ivaApp1] [bit] NULL,
[ivaApp2] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIVA_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIVA] ADD CONSTRAINT [PK_TIVA] PRIMARY KEY NONCLUSTERED  ([IVAId]) WITH (FILLFACTOR=80)
GO
