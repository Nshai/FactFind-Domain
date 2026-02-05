CREATE TABLE [dbo].[TFeeRetainerOwnerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[CRMContactId] [int] NULL,
[TnCCoachId] [int] NULL,
[PractitionerId] [int] NULL,
[BandingTemplateId] [int] NULL,
[IndigoClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFeeRetainerAudit_ConcurrencyId] DEFAULT ((1)),
[FeeRetainerOwnerId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFeeRetainerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL,
[SecondaryOwnerId] [int] NULL
)
GO
ALTER TABLE [dbo].[TFeeRetainerOwnerAudit] ADD CONSTRAINT [PK_TFeeRetainerOwnerAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFeeRetainerOwnerAudit_FeeRetainerOwnerId_ConcurrencyId] ON [dbo].[TFeeRetainerOwnerAudit] ([FeeRetainerOwnerId], [ConcurrencyId])
GO
