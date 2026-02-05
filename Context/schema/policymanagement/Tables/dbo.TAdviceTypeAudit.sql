CREATE TABLE [dbo].[TAdviceTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IntelligentOfficeAdviceType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TAdviceTyp_ArchiveFg_1__56] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceTyp_ConcurrencyId_2__56] DEFAULT ((1)),
[AdviceTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceTyp_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsSystem] [bit] NULL
)
GO
ALTER TABLE [dbo].[TAdviceTypeAudit] ADD CONSTRAINT [PK_TAdviceTypeAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAdviceTypeAudit_AdviceTypeId_ConcurrencyId] ON [dbo].[TAdviceTypeAudit] ([AdviceTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
