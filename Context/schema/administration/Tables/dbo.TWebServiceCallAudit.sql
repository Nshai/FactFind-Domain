CREATE TABLE [dbo].[TWebServiceCallAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefWebServiceId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[StartDateTime] [datetime] NOT NULL CONSTRAINT [DF_TWebServiceCallAudit_StartDateTime] DEFAULT (getdate()),
[EndDateTime] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWebServiceCallAudit_ConcurrencyId] DEFAULT ((1)),
[WebServiceCallId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TWebServiceCallAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TWebServiceCallAudit] ADD CONSTRAINT [PK_TWebServiceCallAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TWebServiceCallAudit_WebServiceCallId_ConcurrencyId] ON [dbo].[TWebServiceCallAudit] ([WebServiceCallId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
