CREATE TABLE [dbo].[TFullQuoteCCJDefaultAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[CCJDefaultId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteCCJDefaultAudit_ConcurrencyId] DEFAULT ((1)),
[FullQuoteCCJDefaultId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuoteCCJDefaultAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteCCJDefaultAudit] ADD CONSTRAINT [PK_TFullQuoteCCJDefaultAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuoteCCJDefaultAudit_FullQuoteCCJDefaultId_ConcurrencyId] ON [dbo].[TFullQuoteCCJDefaultAudit] ([FullQuoteCCJDefaultId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
