CREATE TABLE [dbo].[TRefPersonalProtectionCoverTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CoverTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPersonalProtectionCoverTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefPersonalProtectionCoverTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPersonalProtectionCoverTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPersonalProtectionCoverTypeAudit] ADD CONSTRAINT [PK_TRefPersonalProtectionCoverTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
