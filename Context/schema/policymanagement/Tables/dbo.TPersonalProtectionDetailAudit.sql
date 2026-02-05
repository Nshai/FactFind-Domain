CREATE TABLE [dbo].[TPersonalProtectionDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProtectionId] [int] NULL,
[SumAssured] [money] NULL,
[CoverTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPersonalProtectionDetailAudit_ConcurrencyId] DEFAULT ((1)),
[PersonalProtectionDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPersonalProtectionDetailAudit_StampDateTime] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[TPersonalProtectionDetailAudit] ADD CONSTRAINT [PK_TPersonalProtectionDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
