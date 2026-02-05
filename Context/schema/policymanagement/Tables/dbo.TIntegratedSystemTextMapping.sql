CREATE TABLE [dbo].[TIntegratedSystemTextMapping](
	[IntegratedSystemTextMappingId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationLinkId] [int] NOT NULL,
	[DisplayAsReadOnly] [bit] NOT NULL,
	[DeclarationText] [nvarchar](MAX) NULL,
	[ConcurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_TIntegratedSystemTextMapping] PRIMARY KEY NONCLUSTERED 
(
	[IntegratedSystemTextMappingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TIntegratedSystemTextMapping] ADD  CONSTRAINT [DF_TIntegratedSystemTextMapping_DisplayAsReadOnly]  DEFAULT ((0)) FOR [DisplayAsReadOnly]
GO

ALTER TABLE [dbo].[TIntegratedSystemTextMapping] ADD  CONSTRAINT [DF_TIntegratedSystemTextMapping_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO
