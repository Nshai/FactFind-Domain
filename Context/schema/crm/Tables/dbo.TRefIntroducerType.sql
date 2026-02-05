CREATE TABLE [dbo].[TRefIntroducerType]
(
[RefIntroducerTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[ShortName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LongName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[MinSplitRange] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TRefIntroducerType_MinSplitRange] DEFAULT ((0)),
[MaxSplitRange] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TRefIntroducerType_MaxSplitRange] DEFAULT ((100)),
[DefaultSplit] [decimal] (18, 2) NULL,
[RenewalsFG] [bit] NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TRefIntroducerType_ArchiveFG] DEFAULT ((0)),
[Extensible] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefIntroducerType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefIntroducerType] ADD CONSTRAINT [PK_TRefIntroducerType] PRIMARY KEY NONCLUSTERED  ([RefIntroducerTypeId]) WITH (FILLFACTOR=80)
GO
