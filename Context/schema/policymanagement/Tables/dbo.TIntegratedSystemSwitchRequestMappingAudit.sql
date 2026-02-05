CREATE TABLE [dbo].[TIntegratedSystemSwitchRequestMappingAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationLinkId] [int] NOT NULL,
	[DisplayAsReadOnly] [bit] NOT NULL,
	[DeclarationText] [nvarchar](1000) NULL,
	[ConcurrencyId] [int] NOT NULL,
	[IntegratedSystemSwitchRequestMappingId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
 CONSTRAINT [PK_TIntegratedSystemSwitchRequestMappingAudit] PRIMARY KEY NONCLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TIntegratedSystemSwitchRequestMappingAudit] ADD  CONSTRAINT [DF_TIntegratedSystemSwitchRequestMappingAudit_DisplayAsReadOnly]  DEFAULT ((0)) FOR [DisplayAsReadOnly]
GO

ALTER TABLE [dbo].[TIntegratedSystemSwitchRequestMappingAudit] ADD  CONSTRAINT [DF_TIntegratedSystemSwitchRequestMappingAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO

ALTER TABLE [dbo].[TIntegratedSystemSwitchRequestMappingAudit] ADD  CONSTRAINT [DF_TIntegratedSystemSwitchRequestMappingAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO


