CREATE TABLE [dbo].[TCCJDefaultAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ccjType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ccjDateReg] [datetime] NULL,
[ccjAmount] [decimal] (10, 2) NULL,
[ccjDateSatisf] [datetime] NULL,
[ccjApp1] [bit] NULL,
[ccjApp2] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCCJDefaultAudit_ConcurrencyId] DEFAULT ((1)),
[CCJDefaultId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCCJDefaultAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCCJDefaultAudit] ADD CONSTRAINT [PK_TCCJDefaultAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCCJDefaultAudit_CCJDefaultId_ConcurrencyId] ON [dbo].[TCCJDefaultAudit] ([CCJDefaultId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
