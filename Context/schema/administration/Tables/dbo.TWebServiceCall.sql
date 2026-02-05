CREATE TABLE [dbo].[TWebServiceCall]
(
[WebServiceCallId] [int] NOT NULL IDENTITY(1, 1),
[RefWebServiceId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[StartDateTime] [datetime] NOT NULL CONSTRAINT [DF_TWebServiceCall_StartDateTime] DEFAULT (getdate()),
[EndDateTime] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWebServiceCall_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TWebServiceCall] ADD CONSTRAINT [PK_TWebServiceCall] PRIMARY KEY NONCLUSTERED  ([WebServiceCallId])
GO
ALTER TABLE [dbo].[TWebServiceCall] WITH CHECK ADD CONSTRAINT [FK_TWebServiceCall_TIndigoClient] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TWebServiceCall] ADD CONSTRAINT [FK_TWebServiceCall_TRefWebService] FOREIGN KEY ([RefWebServiceId]) REFERENCES [dbo].[TRefWebService] ([RefWebServiceId])
GO
ALTER TABLE [dbo].[TWebServiceCall] WITH CHECK ADD CONSTRAINT [FK_TWebServiceCall_TUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
