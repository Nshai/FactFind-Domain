CREATE TABLE [dbo].[TCheckListAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ReferenceNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCheckList_ConcurrencyId_1__56] DEFAULT ((1)),
[CheckListId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCheckList_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCheckListAudit] ADD CONSTRAINT [PK_TCheckListAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TCheckListAudit_CheckListId_ConcurrencyId] ON [dbo].[TCheckListAudit] ([CheckListId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
