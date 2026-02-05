CREATE TABLE [dbo].[TEstateissuesactions]
(
[EstateissuesactionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[LikelyReceiveInheritanceYN] [bit] NULL,
[DeFactoRelationshipYN] [bit] NULL,
[ChildrenDifferentRelYN] [bit] NULL,
[DesireOmitfromWillYN] [bit] NULL,
[VulnerableDependentsYN] [bit] NULL,
[Actions] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstateis__Concu__2D32A501] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEstateissuesactions_CRMContactId] ON [dbo].[TEstateissuesactions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
