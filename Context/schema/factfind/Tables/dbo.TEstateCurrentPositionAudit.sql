CREATE TABLE [dbo].[TEstateCurrentPositionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[BroadContent] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[client1total] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[client2total] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[jointtotal] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CapitalGifts] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[UsedAnnualExemption] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[RegularGifts] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[EstateCurrentPositionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstateCu__Concu__1B68FA81] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EstimatedLiabilities] [money] NULL,
[Inheritance] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[EstimatedLiabilitiesJoint] [money] NULL
)
GO
ALTER TABLE [dbo].[TEstateCurrentPositionAudit] ADD CONSTRAINT [PK_TEstateCurrentPositionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
