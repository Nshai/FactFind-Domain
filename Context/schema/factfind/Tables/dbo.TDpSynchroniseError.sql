CREATE TABLE [dbo].[TDpSynchroniseError]
(
[DpSynchroniseErrorId] [int] NOT NULL IDENTITY(1, 1),
[Error] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDpSynchroniseError_StampDateTime] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[TDpSynchroniseError] ADD CONSTRAINT [PK_DpSynchroniseError] PRIMARY KEY NONCLUSTERED  ([DpSynchroniseErrorId]) WITH (FILLFACTOR=80)
GO
