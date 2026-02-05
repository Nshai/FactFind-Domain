CREATE TABLE [dbo].[TEstatePlanningAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[hasWill] [bit] NOT NULL,
[WillUpdate] [datetime] NULL,
[hasCircumstancesChanged] [bit] NULL,
[hasGiftsGiven] [bit] NOT NULL,
[GivenDetails] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[hasGiftsReceived] [bit] NOT NULL,
[ReceivedDetails] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[IsAllowanceUsed] [bit] NOT NULL,
[IHTEstimate] [money] NULL,
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[EstatePlanningId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEstatePla_StampDateTime_1__57] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEstatePlanningAudit] ADD CONSTRAINT [PK_TEstatePlanningAudit_2__57] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TEstatePlanningAudit_EstatePlanningId_ConcurrencyId] ON [dbo].[TEstatePlanningAudit] ([EstatePlanningId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
