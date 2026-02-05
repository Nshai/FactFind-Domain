CREATE TABLE [dbo].[TOnlineSourceData](
	[OnlineSourceDataId] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_TOnlineSourceData] PRIMARY KEY CLUSTERED 
(
	[OnlineSourceDataId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


