CREATE TABLE [dbo].[TGroupSchemeClaimAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[GroupSchemeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ClaimDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MemberPartyId] [int] NULL,
[MemberName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MemberGender] [int] NULL,
[IsSpousesPension] [bit] NULL CONSTRAINT [DF_TGroupSchemeClaimAudit_IsSpousesPension] DEFAULT ((0)),
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Amount] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeClaimAudit_ConcurrencyId] DEFAULT ((1)),
[GroupSchemeClaimId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGroupSchemeClaimAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupSchemeClaimAudit] ADD CONSTRAINT [PK_TGroupSchemeClaimAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroupSchemeClaimAudit_GroupSchemeClaimId_ConcurrencyId] ON [dbo].[TGroupSchemeClaimAudit] ([GroupSchemeClaimId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
