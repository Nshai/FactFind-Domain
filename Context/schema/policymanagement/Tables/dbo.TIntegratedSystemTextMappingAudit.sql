CREATE TABLE [dbo].[TIntegratedSystemTextMappingAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationLinkId] [int] NOT NULL,
	[DisplayAsReadOnly] [bit] NOT NULL,
	[DeclarationText] [nvarchar](MAX) NULL,
	[ConcurrencyId] [int] NOT NULL,
	[IntegratedSystemTextMappingId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
 CONSTRAINT [PK_TIntegratedSystemTextMappingAudit] PRIMARY KEY NONCLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TIntegratedSystemTextMappingAudit] ADD  CONSTRAINT [DF_TIntegratedSystemTextMappingAudit_DisplayAsReadOnly]  DEFAULT ((0)) FOR [DisplayAsReadOnly]
GO

ALTER TABLE [dbo].[TIntegratedSystemTextMappingAudit] ADD  CONSTRAINT [DF_TIntegratedSystemTextMappingAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO

ALTER TABLE [dbo].[TIntegratedSystemTextMappingAudit] ADD  CONSTRAINT [DF_TIntegratedSystemTextMappingAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO


