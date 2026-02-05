CREATE TABLE [dbo].[TWebServiceSettingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NULL,
[RefWebServiceId] [int] NULL,
[MaxNumberOfRecordsReturned] [int] NOT NULL CONSTRAINT [DF_TWebServiceSettingAudit_MaxNumberOfRecordsReturned] DEFAULT ((0)),
[MaxNumberOfConcurrentCalls] [int] NOT NULL CONSTRAINT [DF_TWebServiceSettingAudit_MaxNumberOfConcurrentCalls] DEFAULT ((0)),
[MaxNumberOfCallsPer24Hours] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[StartHours] [smallint] NULL,
[StartMinutes] [smallint] NULL,
[EndHours] [smallint] NULL,
[EndMinutes] [smallint] NULL,
[DenyAccess] [bit] NOT NULL CONSTRAINT [DF_TWebServiceSettingAudit_DenyAccess] DEFAULT ((0)),
[NamedDataSource] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ValidateOnUserId] [bit] NOT NULL CONSTRAINT [DF_TWebServiceSettingAudit_ValidateOnUserId] DEFAULT ((0)),
[ConcurrencyId] [char] (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TWebServiceSettingAudit_ConcurrencyId] DEFAULT ((1)),
[WebServiceSettingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TWebServiceSettingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TWebServiceSettingAudit] ADD CONSTRAINT [PK_TWebServiceSettingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TWebServiceSettingAudit_WebServiceSettingId_ConcurrencyId] ON [dbo].[TWebServiceSettingAudit] ([WebServiceSettingId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
