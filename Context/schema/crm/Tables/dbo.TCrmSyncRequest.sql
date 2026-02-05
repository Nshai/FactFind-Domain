CREATE TABLE [dbo].[TCrmSyncRequest]
(
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCrmSyncRequest_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCrmSyncRequest] ADD CONSTRAINT [PK_TCrmSyncRequest] PRIMARY KEY CLUSTERED  ([CrmSyncRequestId])
GO

