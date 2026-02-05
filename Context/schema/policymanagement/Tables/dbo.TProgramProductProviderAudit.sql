CREATE TABLE [dbo].[TProgramProductProviderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProgramProductProviderId] [int] NOT NULL,
[ProgramId] [int] NOT NULL,
[ProviderId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProgramProductProviderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TProgramProductProviderAudit] ADD CONSTRAINT [PK_TProgramProductProviderAudit_AuditId] PRIMARY KEY CLUSTERED ([AuditId])
GO
