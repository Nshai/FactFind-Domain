CREATE TABLE [dbo].[TCrmSyncRequestAudit]
(
[AuditId] [int] IDENTITY(1,1) NOT NULL,
[CrmSyncRequestId] [uniqueidentifier] NOT NULL,
[ClientPartyId] [int] NOT NULL,
[CreatedByUserId] [int] NOT NULL,
[RefApplicationId] [int] NOT NULL,
[SyncCrmAction] [varchar](50) NOT NULL,
[SyncCrmStatus] [varchar](50) NOT NULL,
[Retries] [smallint] NOT NULL,
[CreatedDateTime] [datetime] NOT NULL,
[LastUpdatedDateTime] [datetime] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCrmSyncRequestAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char](1) NOT NULL,
[STAMPDATETIME] [datetime] NOT NULL CONSTRAINT [DF_TCrmSyncRequestAudit_StampDateTime]  DEFAULT (getdate()),
[STAMPUSER] [varchar](255) NULL,
 CONSTRAINT [PK_CrmSyncRequestAudit] PRIMARY KEY NONCLUSTERED (	[AuditId] ASC)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
