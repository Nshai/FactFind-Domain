CREATE TABLE [dbo].[TLinkedProductProviderAudit](
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
	[LinkedProductProviderId] [int] NOT NULL,
	[RefProdProviderId] [int] NOT NULL,
	[LinkedRefProdProviderId] [int] NOT NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TLinkedProductProviderAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL

    CONSTRAINT [PK_TLinkedProductProviderAudit] PRIMARY KEY CLUSTERED ([AuditId])
)