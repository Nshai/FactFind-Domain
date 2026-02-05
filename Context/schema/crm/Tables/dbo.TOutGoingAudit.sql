CREATE TABLE [dbo].[TOutGoingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[OutGoingTypeId] [int] NOT NULL,
[Frequency] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Amount] [money] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[OutGoingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOutGoingA_StampDateTime_1__51] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOutGoingAudit] ADD CONSTRAINT [PK_TOutGoingAudit_2__51] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOutGoingAudit_OutGoingId_ConcurrencyId] ON [dbo].[TOutGoingAudit] ([OutGoingId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
