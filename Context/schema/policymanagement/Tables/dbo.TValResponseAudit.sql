CREATE TABLE [dbo].[TValResponseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ValRequestId] [int] NOT NULL,
[ImplementationCode] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ResponseXML] [text] COLLATE Latin1_General_CI_AS NULL,
[ResponseDate] [datetime] NULL,
[ResponseStatus] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ErrorDescription] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ProviderErrorCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProviderErrorDescription] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[IsAnalysed] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValResponseAudit_ConcurrencyId] DEFAULT ((1)),
[ValResponseId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TValResponseAudit_StampDateTime] DEFAULT (getdate()) ,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValResponseAudit] ADD CONSTRAINT [PK_TValResponseAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId], StampDateTime)
GO
CREATE NONCLUSTERED INDEX [IX_TvalResponseAudit_StampDateTime] ON [dbo].[TValResponseAudit] ([StampDateTime])
