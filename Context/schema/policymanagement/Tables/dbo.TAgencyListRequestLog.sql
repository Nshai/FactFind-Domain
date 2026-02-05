/****** Object:  Table [dbo].[TAgencyListRequestLog]    Script Date: 11/11/2015 13:27:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TAgencyListRequestLog](
	[AgencyListRequestLogId] [int] IDENTITY(1,1) NOT NULL,
	[RequestDateTime] [datetime2](7) NULL,
	[Request] varchar(1000) NULL,
	[ErrorMessage] varchar(2000) NULL,
	[Status] varchar(50) NULL,
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TAgencyListRequestLog] ADD CONSTRAINT [PK_TAgencyListRequestLog] PRIMARY KEY NONCLUSTERED  ([AgencyListRequestLogId]) WITH (FILLFACTOR=90)




