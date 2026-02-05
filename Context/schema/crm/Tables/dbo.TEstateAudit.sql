CREATE TABLE [dbo].[TEstateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Selected] [bit] NOT NULL,
[Joint] [bit] NOT NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [char] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[EstateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEstateAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEstateAudit] ADD CONSTRAINT [PK_TEstateAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TEstateAudit_EstateId_ConcurrencyId] ON [dbo].[TEstateAudit] ([EstateId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
