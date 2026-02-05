CREATE TABLE [dbo].[TAdviserReallocateClientDetails]
(
[AdviserReallocateClientDetailsId] [int] NOT NULL IDENTITY(1, 1),
[AdviserReallocateStatsId] [int] NOT NULL,
[ClientPartyId] [int] NULL,
[IsRelatedClient] [bit] NULL,
[IsProcessed] [bit] NULL CONSTRAINT [DF_TAdviserReallocateClientDetails_IsProcessed] DEFAULT ((0)),
[ErrorMessage] [varchar] (255) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviserReallocateClientDetails_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviserReallocateClientDetails] ADD CONSTRAINT [PK_TAdviserReallocateClientDetails] PRIMARY KEY NONCLUSTERED  ([AdviserReallocateClientDetailsId])
GO
CREATE CLUSTERED INDEX CLX_TAdviserReallocateClientDetails_ClientPartyId ON [TAdviserReallocateClientDetails] ([ClientPartyId])
GO
CREATE NONCLUSTERED INDEX IDX_TAdviserReallocateClientDetails_AdviserReallocateStatsId ON [TAdviserReallocateClientDetails] (AdviserReallocateStatsId)
GO
