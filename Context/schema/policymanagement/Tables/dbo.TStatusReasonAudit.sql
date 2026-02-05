CREATE TABLE [dbo].[TStatusReasonAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StatusId] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL,
[OrigoStatusId] [int] NULL,
[IntelligentOfficeStatusType] [varchar] (50) NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatusReasonAudit_ConcurrencyId] DEFAULT ((1)),
[StatusReasonId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TStatusReasonAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[RefLicenceTypeId] [int] NOT NULL CONSTRAINT [DF_TStatusReasonAudit_RefLicenceTypeId] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TStatusReasonAudit_IsArchived] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TStatusReasonAudit] ADD CONSTRAINT [PK_TStatusReasonAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TStatusReasonAudit_StatusReasonId_ConcurrencyId] ON [dbo].[TStatusReasonAudit] ([StatusReasonId], [ConcurrencyId])
GO
