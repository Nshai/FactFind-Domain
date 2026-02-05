CREATE TABLE [dbo].[TIntroducerEmployeeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TIntroducerEmployeeAudit_ConcurrencyId] DEFAULT ((1)),
[IntroducerEmployeeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIntroducerEmployeeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntroducerEmployeeAudit] ADD CONSTRAINT [PK_TIntroducerEmployeeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
