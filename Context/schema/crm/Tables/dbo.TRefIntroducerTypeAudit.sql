CREATE TABLE [dbo].[TRefIntroducerTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[ShortName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LongName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[MinSplitRange] [decimal] (18, 0) NOT NULL,
[MaxSplitRange] [decimal] (18, 0) NOT NULL,
[DefaultSplit] [decimal] (18, 2) NULL,
[RenewalsFG] [bit] NULL,
[ArchiveFG] [bit] NOT NULL,
[Extensible] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[RefIntroducerTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefIntrod_StampDateTime_1__69] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefIntroducerTypeAudit] ADD CONSTRAINT [PK_TRefIntroducerTypeAudit_2__69] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
