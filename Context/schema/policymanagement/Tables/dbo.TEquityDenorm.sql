SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TEquityDenorm]
(
	[EquityId] [int] NOT NULL,
	[ComputedId] AS ( 'E' + CONVERT(varchar(10), EquityId) ) PERSISTED,
	[Name] [varchar] (255) NULL,
	[EpicCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
	[ISINCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
	[UpdatedFg] [bit] NOT NULL CONSTRAINT [DF_TEquityDenorm_UpdatedFg] DEFAULT (1),
	[Currency] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEquityDenorm] ADD CONSTRAINT [PK_TEquityDenorm] PRIMARY KEY CLUSTERED  ([EquityId])
GO
CREATE NONCLUSTERED INDEX [IX_EquityDenorm_ComputedId] ON [dbo].[TEquityDenorm] ([ComputedId], [EquityId])
GO
