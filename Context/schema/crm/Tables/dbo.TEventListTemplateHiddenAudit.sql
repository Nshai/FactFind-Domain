CREATE TABLE [dbo].[TEventListTemplateHiddenAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[EventListTemplateHiddenId] [int] NOT NULL,
	[EventListTemplateId] [int] NOT NULL,
	[GroupId] [int] NULL,
	[TenantId] [int] NULL,
	[ConcurrencyId] [nchar](10) NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
 CONSTRAINT [PK_TEventListTemplateHiddenAudit] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


