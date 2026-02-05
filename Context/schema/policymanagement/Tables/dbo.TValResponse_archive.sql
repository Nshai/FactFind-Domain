CREATE TABLE [dbo].[TValResponse_archive](
	[ValResponseId] [int] IDENTITY(1,1) NOT NULL,
	[ValRequestId] [int] NOT NULL,
	[ResponseXML] [text] NULL,
	[ResponseDate] [datetime] NULL,
	[ResponseStatus] [varchar](255) NULL,
	[ErrorDescription] [varchar](4000) NULL,
	[IsAnalysed] [bit] NULL,
	[ConcurrencyId] [int] NOT NULL,
	[ImplementationCode] [varchar](100) NULL,
	[ProviderErrorCode] [varchar](50) NULL,
	[ProviderErrorDescription] [varchar](1000) NULL
) 