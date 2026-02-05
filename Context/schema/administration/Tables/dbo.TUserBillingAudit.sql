CREATE TABLE [dbo].[TUserBillingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NOT NULL,
[HourlyBillingRate] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserBillingAudit_ConcurrencyId] DEFAULT ((1)),
[UserBillingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TUserBillingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserBillingAudit] ADD CONSTRAINT [PK_TUserBillingAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
