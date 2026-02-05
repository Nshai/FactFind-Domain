create TABLE [dbo].TSingleSignOn(
	[SingleSignOnId] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[PortalId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[LoggedOnUserId] [int] NOT NULL,	
	[UserIdentity] [varchar](max) NULL,
	[ConsumerServiceUrl] [varchar](max) NOT NULL,
	[RelayState] [varchar](max) NOT NULL,
	[EntityId] [int] NULL,
	[LinkedEntityType] [varchar](255) NULL	
	
 CONSTRAINT [PK_TSingleSignOn] PRIMARY KEY CLUSTERED 
(
	SingleSignOnId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



