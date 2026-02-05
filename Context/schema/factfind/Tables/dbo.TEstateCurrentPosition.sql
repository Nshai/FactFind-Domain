CREATE TABLE [dbo].[TEstateCurrentPosition]
(
[EstateCurrentPositionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[BroadContent] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[client1total] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[client2total] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[jointtotal] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CapitalGifts] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[UsedAnnualExemption] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[RegularGifts] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstateCu__Concu__47B19113] DEFAULT ((1)),
[EstimatedLiabilities] [money] NULL,
[EstimatedLiabilitiesJoint] [money] NULL,
[Inheritance] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEstateCurrentPosition_CRMContactId] ON [dbo].[TEstateCurrentPosition] ([CRMContactId])
GO
