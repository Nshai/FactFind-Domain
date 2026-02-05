CREATE TABLE [dbo].[TOnlineSourceDataAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[OnlineSourceDataId] [int] NOT NULL,
	[OpportunityId] [int] NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[SubmittedDate] [datetime] NULL,
	[SubmittedTime] [varchar](50) NULL,
	[CallbackPreference] [varchar](4000) NULL,
	[Source] [varchar](4000) NULL,
	[Keywords] [varchar](4000) NULL,
	[RefferedURL] [varchar](4000) NULL,
	[LandingPageURL] [varchar](4000) NULL,
	[SubmittedFromURL] [varchar](4000) NULL,
	[SubmittedFromIP] [varchar](255) NULL,
	[ConcurrencyId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
 CONSTRAINT [PK_TOnlineSourceDataAudit] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


