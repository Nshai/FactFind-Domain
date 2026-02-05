CREATE TABLE [dbo].[TOutGoingTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[OutGoingTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOutGoingT_StampDateTime_1__51] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOutGoingTypeAudit] ADD CONSTRAINT [PK_TOutGoingTypeAudit_2__51] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOutGoingTypeAudit_OutGoingTypeId_ConcurrencyId] ON [dbo].[TOutGoingTypeAudit] ([OutGoingTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
