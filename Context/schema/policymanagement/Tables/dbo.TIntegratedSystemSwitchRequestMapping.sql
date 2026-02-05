CREATE TABLE [dbo].[TIntegratedSystemSwitchRequestMapping](
	[IntegratedSystemSwitchRequestMappingId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationLinkId] [int] NOT NULL,
	[DisplayAsReadOnly] [bit] NOT NULL,
	[DeclarationText] [nvarchar](1000) NULL,
	[ConcurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_TIntegratedSystemSwitchRequestMapping] PRIMARY KEY NONCLUSTERED 
(
	[IntegratedSystemSwitchRequestMappingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TIntegratedSystemSwitchRequestMapping] ADD  CONSTRAINT [DF_TIntegratedSystemSwitchRequestMapping_DisplayAsReadOnly]  DEFAULT ((0)) FOR [DisplayAsReadOnly]
GO

ALTER TABLE [dbo].[TIntegratedSystemSwitchRequestMapping] ADD  CONSTRAINT [DF_TIntegratedSystemSwitchRequestMapping_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO
