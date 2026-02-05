CREATE TABLE [dbo].[TRefRiskComment]
(
[RefRiskCommentId] [int] NOT NULL IDENTITY(1, 1),
[RiskComment] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRiskComment_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefRiskComment] ADD CONSTRAINT [PK_TRefRiskComment] PRIMARY KEY NONCLUSTERED  ([RefRiskCommentId]) WITH (FILLFACTOR=80)
GO
CREATE UNIQUE CLUSTERED INDEX [IDX_UNQ_TRefRiskComment_RefRiskCommentId] ON [dbo].[TRefRiskComment] ([RefRiskCommentId]) WITH (FILLFACTOR=80)
GO