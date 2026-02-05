CREATE TABLE [dbo].[TGroupingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ParentId] [int] NULL,
[IsPayable] [bit] NOT NULL CONSTRAINT [DF_TGroupingA_IsPayable_2__56] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupingA_ConcurrencyId_1__56] DEFAULT ((1)),
[GroupingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGroupingA_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupingAudit] ADD CONSTRAINT [PK_TGroupingAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TGroupingAudit_GroupingId_ConcurrencyId] ON [dbo].[TGroupingAudit] ([GroupingId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
