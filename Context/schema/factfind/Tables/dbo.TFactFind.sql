CREATE TABLE [dbo].[TFactFind]
(
[FactFindId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId1] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[FactFindTypeId] [int] NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFind_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFactFind] ADD CONSTRAINT [PK_TFactFind] PRIMARY KEY CLUSTERED  ([FactFindId])
GO
ALTER TABLE [dbo].[TFactFind] WITH CHECK ADD CONSTRAINT [FK_TFactFind_FactFindTypeId_FactFindTypeId] FOREIGN KEY ([FactFindTypeId]) REFERENCES [dbo].[TFactFindType] ([FactFindTypeId])
GO
CREATE INDEX [IDX_TFactFind_CRMContactId2] ON TFactFind (CRMContactId2)
GO
CREATE UNIQUE INDEX UX_TFactFind ON [dbo].[TFactFind]([CRMContactId1],[CRMContactId2])
GO


