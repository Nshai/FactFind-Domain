CREATE TABLE [dbo].[TValBulkPershingFund]
(
[ValBulkPershingFundId] [int] NOT NULL IDENTITY(1, 1),
[SedolCode] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[FundName] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TValBulkPershingFund] ADD CONSTRAINT [PK_TValBulkPershingFund] PRIMARY KEY CLUSTERED  ([ValBulkPershingFundId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TValBulkPershingFund] ON [dbo].[TValBulkPershingFund] ([SedolCode])
GO
