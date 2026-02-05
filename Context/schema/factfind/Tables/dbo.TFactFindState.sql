
CREATE TABLE [dbo].[TFactFindState]
(
[FactFindStateId] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindState_ConcurrencyId] DEFAULT ((1)),
[TenantId] [int] NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[StampUserId] [int] NOT NULL,
[ClientPartyId] [int] NOT NULL,
[ClientFactFindId] [int] NOT NULL,
[ServiceCaseId] [int] NULL
)
GO
ALTER TABLE [dbo].[TFactFindState] ADD CONSTRAINT [PK_TFactFindState] PRIMARY KEY CLUSTERED  ([FactFindStateId]) WITH (FILLFACTOR=80)
GO

