CREATE TABLE [dbo].[TStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[OrigoStatusId] [int] NULL,
[IntelligentOfficeStatusType] [varchar] (50) NULL,
[PreComplianceCheck] [bit] NOT NULL CONSTRAINT [DF_TStatusAudit_PreComplianceCheck] DEFAULT ((0)),
[PostComplianceCheck] [bit] NOT NULL CONSTRAINT [DF_TStatusAudit_PostComplianceCheck] DEFAULT ((0)),
[SystemSubmitFg] [bit] NOT NULL CONSTRAINT [DF_TStatusAudit_SystemSubmitFg] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatusAudit_ConcurrencyId] DEFAULT ((1)),
[StatusId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[IsPipelineStatus] [bit] NOT NULL CONSTRAINT [DF_TStatusAudit_PipelineStatus] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TStatusAudit] ADD CONSTRAINT [PK_TStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TStatusAudit_StatusId_ConcurrencyId] ON [dbo].[TStatusAudit] ([StatusId], [ConcurrencyId])
GO
