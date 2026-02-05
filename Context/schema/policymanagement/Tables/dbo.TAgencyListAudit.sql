USE [policymanagement]
GO

/****** Object:  Table [dbo].[TAgencyList]    Script Date: 05/11/2015 13:43:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TAgencyListAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[AgencyListId] [int] NULL,
	[Code] [varchar](50) NULL,
	[Type] [varchar](10) NULL,
	[Fca] [varchar](50) NULL,
	[RefProdProviderId] [int] NULL,
	[StampAction] [char] (1) NULL,
	[StampDateTime] [datetime2] NULL,
	[StampUser] [varchar] (255) NULL,
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TAgencyListAudit] ADD CONSTRAINT [PK_TAgencyListAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])

