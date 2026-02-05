CREATE TABLE [dbo].[TGroupSchemeNote](
	[GroupSchemeNoteId] int IDENTITY(1,1) NOT NULL,
	[GroupSchemeId]     int               NOT NULL,
	[TenantId]          int               NOT NULL,
	[Text]              varchar(max)      NOT NULL,
	[CreatedOn]         datetime          NOT NULL,
	[CreatedBy]         int               NOT NULL,
	[UpdatedOn]         datetime          NOT NULL,
	[UpdatedBy]         int               NOT NULL,
	[IsSystem]          bit               NOT NULL,
	[ConcurrencyId]     int               NOT NULL,
CONSTRAINT [PK_TGroupSchemeNote] PRIMARY KEY CLUSTERED 
(
	[GroupSchemeNoteId] ASC
)
WITH 
	(
		PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
	) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TGroupSchemeNote] ADD  CONSTRAINT [DF_TGroupSchemeNote_IsSystem]  DEFAULT ((0)) FOR [IsSystem]
ALTER TABLE [dbo].[TGroupSchemeNote] ADD  CONSTRAINT [DF_TGroupSchemeNote_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]

CREATE NONCLUSTERED INDEX [IX_TGroupSchemeNote_TenantId_GroupSchemeId] ON [dbo].[TGroupSchemeNote] ([TenantId],[GroupSchemeId])

GO