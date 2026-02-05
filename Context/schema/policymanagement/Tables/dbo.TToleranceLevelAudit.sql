CREATE TABLE [dbo].[TToleranceLevelAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Tolerance] [money] NOT NULL,
[PurchaseTolerance] [money] NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TToleranceLevelAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL,
[ToleranceLevelId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TToleranceLevelAudit] ADD CONSTRAINT [PK_TToleranceLevelAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
