CREATE TABLE [dbo].[TFamilyMembers]
(
[FamilyMembersId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RolesDuties] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[Smoker] [bit] NULL,
[GoodHealth] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFamilyMe__Concu__0E7913B7] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TFamilyMembers_CRMContactId] ON [dbo].[TFamilyMembers] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
