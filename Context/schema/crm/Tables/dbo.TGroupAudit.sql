CREATE TABLE [dbo].[TGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NULL,
[RefGroupTypeId] [int] NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NULL,
[Reference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ParentGroupId] [int] NULL,
[RetiredFG] [tinyint] NULL,
[Notes] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL,
[GroupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGroupAudi_StampDateTime_1__69] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupAudit] ADD CONSTRAINT [PK_TGroupAudit_2__69] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TGroupAudit_GroupId_ConcurrencyId] ON [dbo].[TGroupAudit] ([GroupId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
