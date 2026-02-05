CREATE TABLE [dbo].[TGroupSchemeNoteAudit](
	[AuditId]           int IDENTITY(1,1) NOT NULL,
	[GroupSchemeNoteId] int               NOT NULL,
	[GroupSchemeId]     int               NOT NULL,
	[TenantId]          int               NOT NULL,
	[Text]              varchar(max)      NOT NULL,
	[CreatedOn]         datetime          NOT NULL,
	[CreatedBy]         int               NOT NULL,
	[UpdatedOn]         datetime          NOT NULL,
	[UpdatedBy]         int               NOT NULL,
	[IsSystem]          bit               NOT NULL,
	[ConcurrencyId]     int               NOT NULL,
	[StampAction]       char(1)           NULL,
	[StampDateTime]     datetime          NULL,
	[StampUser]         varchar(255)      NULL,
CONSTRAINT [PK_TGroupSchemeNoteAudit] PRIMARY KEY CLUSTERED
(
	[AuditId] ASC
)
WITH
	(
	PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
	) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TGroupSchemeNoteAudit] ADD  CONSTRAINT [DF_TGroupSchemeNoteAudit_IsSystem]  DEFAULT ((0)) FOR [IsSystem]
ALTER TABLE [dbo].[TGroupSchemeNoteAudit] ADD  CONSTRAINT [DF_TGroupSchemeNoteAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]

CREATE NONCLUSTERED INDEX [IX_TGroupSchemeNoteAudit_TenantId_GroupSchemeId] ON [dbo].[TGroupSchemeNoteAudit] ([TenantId],[GroupSchemeId])

CREATE NONCLUSTERED INDEX [IX_TGroupSchemeNoteAudit_TenantId_GroupSchemeNoteId] ON [dbo].[TGroupSchemeNoteAudit] ([TenantId],[GroupSchemeNoteId])

GO 