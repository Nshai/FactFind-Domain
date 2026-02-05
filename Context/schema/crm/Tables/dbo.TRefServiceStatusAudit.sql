CREATE TABLE [dbo].[TRefServiceStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ServiceStatusName] [varchar] (50) NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefServiceStatusAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefServiceStatusAudit_ConcurrencyId] DEFAULT ((1)),
[RefServiceStatusId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefServiceStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[GroupId] [int] NULL,
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TRefServiceStatusAudit_IsPropagated] DEFAULT ((1)),
[ReportFrequency] [int] NULL,
[ReportStartDateType] [smallint] NULL,
[ReportStartDate] [datetime] NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_TRefServiceStatusAudit_IsDefault] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefServiceStatusAudit] ADD CONSTRAINT [PK_TRefServiceStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TRefServiceStatusAudit_RefServiceStatusId_ConcurrencyId] ON [dbo].[TRefServiceStatusAudit] ([RefServiceStatusId], [ConcurrencyId])
GO
