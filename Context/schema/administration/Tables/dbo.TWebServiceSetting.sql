CREATE TABLE [dbo].[TWebServiceSetting]
(
[WebServiceSettingId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NULL,
[RefWebServiceId] [int] NULL,
[MaxNumberOfRecordsReturned] [int] NOT NULL CONSTRAINT [DF_TWebServiceSetting_MaxNumberOfRecordsReturned] DEFAULT ((0)),
[MaxNumberOfConcurrentCalls] [int] NOT NULL CONSTRAINT [DF_TWebServiceSetting_MaxNumberOfConcurrentCalls] DEFAULT ((0)),
[MaxNumberOfCallsPer24Hours] [char] (10)  NULL,
[StartHours] [smallint] NULL,
[StartMinutes] [smallint] NULL,
[EndHours] [smallint] NULL,
[EndMinutes] [smallint] NULL,
[DenyAccess] [bit] NOT NULL CONSTRAINT [DF_TWebServiceSetting_DenyAccess] DEFAULT ((0)),
[NamedDataSource] [varchar] (255)  NULL,
[ValidateOnUserId] [bit] NOT NULL CONSTRAINT [DF_TWebServiceSetting_ValidateOnUserId] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWebServiceSetting_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TWebServiceSetting] ADD CONSTRAINT [PK_TWebServiceSetting] PRIMARY KEY NONCLUSTERED  ([WebServiceSettingId])
GO
ALTER TABLE [dbo].[TWebServiceSetting] WITH CHECK ADD CONSTRAINT [FK_TWebServiceSetting_TIndigoClient] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TWebServiceSetting] ADD CONSTRAINT [FK_TWebServiceSetting_TRefWebService] FOREIGN KEY ([RefWebServiceId]) REFERENCES [dbo].[TRefWebService] ([RefWebServiceId])
GO
ALTER TABLE [dbo].[TWebServiceSetting] WITH CHECK ADD CONSTRAINT [FK_TWebServiceSetting_TUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
