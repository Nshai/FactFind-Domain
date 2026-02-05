CREATE TABLE [dbo].[TPartyKey]
(
    [PartyKeyId] [int] NOT NULL IDENTITY(1, 1),
    [TenantId] [int] NOT NULL,
    [UserId] [int] NOT NULL,
    [PartyId] [int] NOT NULL,
    [RightMask] [int] NOT NULL,
	[PartyRoleId] [int] NOT NULL, 
	[IsDerived] [bit] NOT NULL  -- Is indicates if the user got the permission from the entity security policy OR if they were given access to this particular party
)
GO
ALTER TABLE [dbo].[TPartyKey] ADD CONSTRAINT [PK_TPartyKey] PRIMARY KEY NONCLUSTERED  ([PartyKeyId])
GO
CREATE CLUSTERED INDEX [IDX_TPartyKey_TenantId_UserId_PartyId] ON [dbo].[TPartyKey] ([TenantId], [UserId], [PartyId])
GO
CREATE NONCLUSTERED INDEX [IX_TPartyKey_TenantId_PartyId] ON [dbo].[TPartyKey] ([TenantId], [PartyId])
GO
