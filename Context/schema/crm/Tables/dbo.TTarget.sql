CREATE TABLE [dbo].[TTarget]
(
[TargetId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PractCRMContactId] [int] NOT NULL,
[TargetAmount] [float] NOT NULL,
[Month] [tinyint] NOT NULL,
[Year] [smallint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTarget_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTarget] ADD CONSTRAINT [PK_TTarget] PRIMARY KEY NONCLUSTERED  ([TargetId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTarget_PractCRMContactId] ON [dbo].[TTarget] ([PractCRMContactId])
GO
ALTER TABLE [dbo].[TTarget] WITH CHECK ADD CONSTRAINT [FK_TTarget_PractCRMContactId_CRMContactId] FOREIGN KEY ([PractCRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
