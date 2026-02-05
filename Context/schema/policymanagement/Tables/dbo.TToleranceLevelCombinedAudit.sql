CREATE TABLE [dbo].[TToleranceLevelCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ToleranceLevelId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[Tolerance] [money] NOT NULL,
[PurchaseTolerance] [money] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TToleranceLevelCombinedAudit_Guid] DEFAULT (newid()),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TToleranceLevelCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TToleranceLevelCombinedAudit] ADD CONSTRAINT [PK_TToleranceLevelCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TToleranceLevelCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TToleranceLevelCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
