CREATE TABLE [dbo].[TCrmSyncResponseAudit]
(
[AuditId] [int] IDENTITY(1,1) NOT NULL,
[CrmSyncResponseId] [int] NOT NULL,
[CrmSyncRequestId] [uniqueidentifier] NOT NULL,
[RetryNumber] [smallint] NULL,
[RequestString] [varchar](max) NULL,
[ResponseString] [varchar](max) NULL,
[SystemError]  [bit] NULL,
[ErrorMessage] [varchar](max) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCrmSyncResponseAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char](1) NOT NULL,
[STAMPDATETIME] [datetime] NOT NULL CONSTRAINT [DF_TCrmSyncResponseAudit_StampDateTime]  DEFAULT (getdate()),
[STAMPUSER] [varchar](255) NULL,
 CONSTRAINT [PK_TCrmSyncResponseAudit] PRIMARY KEY NONCLUSTERED (	[AuditId] ASC)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO