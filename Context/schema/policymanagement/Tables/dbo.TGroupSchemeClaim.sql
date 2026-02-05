CREATE TABLE [dbo].[TGroupSchemeClaim]
(
[GroupSchemeClaimId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[GroupSchemeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ClaimDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MemberPartyId] [int] NULL,
[MemberName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MemberGender] [int] NULL,
[IsSpousesPension] [bit] NULL CONSTRAINT [DF_TGroupSchemeClaim_IsSpousesPension] DEFAULT ((0)),
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Amount] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeClaim_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TGroupSchemeClaim] ADD CONSTRAINT [PK_TGroupSchemeClaim] PRIMARY KEY NONCLUSTERED  ([GroupSchemeClaimId])
GO
ALTER TABLE [dbo].[TGroupSchemeClaim] ADD CONSTRAINT [FK_TGroupSchemeClaim_GroupSchemeId_TGroupScheme] FOREIGN KEY ([GroupSchemeId]) REFERENCES [dbo].[TGroupScheme] ([GroupSchemeId])
GO
