CREATE TABLE [dbo].[TAdviserReallocateClientDetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviserReallocateClientDetailsId] [int] NOT NULL,
[AdviserReallocateStatsId] [int] NOT NULL,
[ClientPartyId] [int] NULL,
[IsRelatedClient] [bit] NULL,
[IsProcessed] [bit] NULL,
[ErrorMessage] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviserReallocateClientDetailsAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviserReallocateClientDetailsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviserReallocateClientDetailsAudit] ADD CONSTRAINT [PK_TAdviserReallocateClientDetailsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviserReallocateClientDetailsAudit_AdviserReallocateClientDetailsId_ConcurrencyId] ON [dbo].[TAdviserReallocateClientDetailsAudit] ([AdviserReallocateClientDetailsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
