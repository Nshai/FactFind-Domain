USE [policymanagement]
GO

/****** Object:  Table [dbo].[TAgencyList]    Script Date: 05/11/2015 13:43:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TAgencyList](
	[AgencyListId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) NULL,
	[Type] [varchar](10) NULL,
	[Fca] [varchar](50) NULL,
	[RefProdProviderId] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TAgencyList]  WITH CHECK ADD  CONSTRAINT [FK_TAgencyList_TRefProdProvider] FOREIGN KEY([RefProdProviderId])
REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO

ALTER TABLE [dbo].[TAgencyList] CHECK CONSTRAINT [FK_TAgencyList_TRefProdProvider]
GO

ALTER TABLE [dbo].[TAgencyList] ADD CONSTRAINT [PK_TAgencyList] PRIMARY KEY NONCLUSTERED  ([AgencyListId]) WITH (FILLFACTOR=90)
