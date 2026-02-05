CREATE TABLE [dbo].[TRefOccupationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[OrigoCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefOccupationAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefOccupationAudit_ConcurrencyId] DEFAULT ((1)),
[RefOccupationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefOccupationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefOccupationAudit] ADD CONSTRAINT [PK_TRefOccupationAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefOccupationAudit_RefOccupationId_ConcurrencyId] ON [dbo].[TRefOccupationAudit] ([RefOccupationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
