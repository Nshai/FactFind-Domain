CREATE TABLE [dbo].[TGroupSchemeMember]
(
[GroupSchemeMemberId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[GroupSchemeCategoryId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[JoiningDate] [datetime] NULL,
[LeavingDate] [datetime] NULL,
[IsLeaver] [bit] NOT NULL CONSTRAINT [DF_TGroupSchemeMember_IsLeaver] DEFAULT ((0)),
[NominatedBeneficiary] [varchar] (255) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeMember_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TGroupSchemeMember] ADD CONSTRAINT [PK_TGroupSchemeMember] PRIMARY KEY CLUSTERED  ([GroupSchemeMemberId])
GO
CREATE NONCLUSTERED INDEX [IX_TGroupSchemeMember_GroupSchemeId] ON [dbo].[TGroupSchemeMember] ([GroupSchemeId])
GO
CREATE NONCLUSTERED INDEX [IX_TGroupSchemeMember_PolicyBusinessId] ON [dbo].[TGroupSchemeMember] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TGroupSchemeMember] ADD CONSTRAINT [FK_TGroupSchemeMember_GroupSchemeCategoryId_TGroupSchemeCategory] FOREIGN KEY ([GroupSchemeCategoryId]) REFERENCES [dbo].[TGroupSchemeCategory] ([GroupSchemeCategoryId])
GO
ALTER TABLE [dbo].[TGroupSchemeMember] ADD CONSTRAINT [FK_TGroupSchemeMember_GroupSchemeId_TGroupScheme] FOREIGN KEY ([GroupSchemeId]) REFERENCES [dbo].[TGroupScheme] ([GroupSchemeId])
GO
CREATE NONCLUSTERED INDEX IX_TGroupSchemeMember_GroupSchemeCategoryId ON [dbo].[TGroupSchemeMember] ([GroupSchemeCategoryId])
go
create index IX_TGroupSchemeMember_1 on TGroupSchemeMember (GroupSchemeMemberId,GroupSchemeId,CRMContactId,GroupSchemeCategoryId,PolicyBusinessId,JoiningDate,IsLeaver)
GO