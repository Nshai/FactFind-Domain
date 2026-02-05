CREATE TABLE [dbo].[TPropertyOwnershipAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OwnershipType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPropertyO_ConcurrencyId_1__56] DEFAULT ((1)),
[PropertyOwnershipId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPropertyO_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPropertyOwnershipAudit] ADD CONSTRAINT [PK_TPropertyOwnershipAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPropertyOwnershipAudit_PropertyOwnershipId_ConcurrencyId] ON [dbo].[TPropertyOwnershipAudit] ([PropertyOwnershipId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
