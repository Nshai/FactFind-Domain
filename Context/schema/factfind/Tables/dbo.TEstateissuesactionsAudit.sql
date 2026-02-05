CREATE TABLE [dbo].[TEstateissuesactionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LikelyReceiveInheritanceYN] [bit] NULL,
[DeFactoRelationshipYN] [bit] NULL,
[ChildrenDifferentRelYN] [bit] NULL,
[DesireOmitfromWillYN] [bit] NULL,
[VulnerableDependentsYN] [bit] NULL,
[Actions] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[EstateissuesactionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstateis__Concu__00EA0E6F] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEstateissuesactionsAudit] ADD CONSTRAINT [PK_TEstateissuesactionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
