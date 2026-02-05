CREATE TABLE [dbo].[TClientShare]
(
[ClientShareId] [int] NOT NULL IDENTITY(1, 1),
[ClientPartyId] [int] NOT NULL,
[SharedByCRMContactId] [int] NOT NULL,
[SharedToCRMContactId] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[ShareEndedByCRMContactId] [int] NULL,
[IsShareActive] [bit] NOT NULL CONSTRAINT [DF_Table_1_IsShareEnd] DEFAULT ((1)),
[ShareIdentifier] [uniqueidentifier] NOT NULL,
[OrganiserActivityId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientShare_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TClientShare] ADD CONSTRAINT [PK_TClientShare] PRIMARY KEY CLUSTERED  ([ClientShareId])
GO
CREATE NONCLUSTERED INDEX [idx_ClientPartyId] ON [dbo].[TClientShare] ([ClientPartyId])
GO
CREATE NONCLUSTERED INDEX [idx_OrganiserActivityId] ON [dbo].[TClientShare] ([OrganiserActivityId])
GO
CREATE NONCLUSTERED INDEX [idx_SharedBy] ON [dbo].[TClientShare] ([SharedByCRMContactId])
GO
CREATE NONCLUSTERED INDEX [idx_AdditionalAdviserId] ON [dbo].[TClientShare] ([SharedToCRMContactId])
GO
CREATE NONCLUSTERED INDEX [idx_ShareEndedBy] ON [dbo].[TClientShare] ([ShareEndedByCRMContactId])
GO
CREATE NONCLUSTERED INDEX [idx_ShareIdentifier] ON [dbo].[TClientShare] ([ShareIdentifier])
GO
CREATE NONCLUSTERED INDEX [idx_TenantId] ON [dbo].[TClientShare] ([TenantId])
GO
