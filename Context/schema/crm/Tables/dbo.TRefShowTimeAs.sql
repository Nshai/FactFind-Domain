CREATE TABLE [dbo].[TRefShowTimeAs]
(
[RefShowTimeAsId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Color] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FreeFG] [bit] NOT NULL CONSTRAINT [DF_TRefShowTi_FreeFG_2__51] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefShowTi_ConcurrencyId_1__51] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefShowTimeAs] ADD CONSTRAINT [PK_TRefShowTimeAs_3__51] PRIMARY KEY NONCLUSTERED  ([RefShowTimeAsId]) WITH (FILLFACTOR=80)
GO
