CREATE TABLE [dbo].[TRefLifeCover]
(
[RefLifeCoverId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefLifeCover] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefLifeCover] ADD CONSTRAINT [PK_TRefLifeCover] PRIMARY KEY CLUSTERED  ([RefLifeCoverId])
GO
