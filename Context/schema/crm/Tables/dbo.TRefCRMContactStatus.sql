CREATE TABLE [dbo].[TRefCRMContactStatus]
(
[RefCRMContactStatusId] [int] NOT NULL IDENTITY(1, 1),
[StatusName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OrderNo] [int] NULL,
[InternalFG] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCRMCon_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCRMContactStatus] ADD CONSTRAINT [PK_TRefCRMContactStatus_2__54] PRIMARY KEY NONCLUSTERED  ([RefCRMContactStatusId]) WITH (FILLFACTOR=80)
GO
