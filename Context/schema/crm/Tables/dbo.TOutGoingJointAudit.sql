CREATE TABLE [dbo].[TOutGoingJointAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[PartnerCRMContactId] [int] NOT NULL,
[OutGoingTypeId] [int] NOT NULL,
[Frequency] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Amount] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[OutGoingJointId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOutGoingJ_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOutGoingJointAudit] ADD CONSTRAINT [PK_TOutGoingJointAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOutGoingJointAudit_OutGoingJointId_ConcurrencyId] ON [dbo].[TOutGoingJointAudit] ([OutGoingJointId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
