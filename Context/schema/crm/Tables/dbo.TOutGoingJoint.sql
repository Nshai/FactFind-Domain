CREATE TABLE [dbo].[TOutGoingJoint]
(
[OutGoingJointId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[PartnerCRMContactId] [int] NOT NULL,
[OutGoingTypeId] [int] NOT NULL,
[Frequency] [varchar] (50)  NOT NULL,
[Amount] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOutGoingJoint_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOutGoingJoint] ADD CONSTRAINT [PK_TOutGoingJoint] PRIMARY KEY NONCLUSTERED  ([OutGoingJointId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOutGoingJoint_CRMContactId] ON [dbo].[TOutGoingJoint] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOutGoingJoint_OutGoingTypeId] ON [dbo].[TOutGoingJoint] ([OutGoingTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOutGoingJoint_PartnerCRMContactId] ON [dbo].[TOutGoingJoint] ([PartnerCRMContactId])
GO
ALTER TABLE [dbo].[TOutGoingJoint] WITH CHECK ADD CONSTRAINT [FK_TOutGoingJoint_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TOutGoingJoint] ADD CONSTRAINT [FK_TOutGoingJoint_OutGoingTypeId_OutGoingTypeId] FOREIGN KEY ([OutGoingTypeId]) REFERENCES [dbo].[TOutGoingType] ([OutGoingTypeId])
GO
ALTER TABLE [dbo].[TOutGoingJoint] WITH CHECK ADD CONSTRAINT [FK_TOutGoingJoint_PartnerCRMContactId_CRMContactId] FOREIGN KEY ([PartnerCRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
