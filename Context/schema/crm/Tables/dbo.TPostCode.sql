CREATE TABLE [dbo].[TPostCode]
(
[PostCodeId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL CONSTRAINT [DF_TPostCode_IndigoClientId] DEFAULT ((0)),
[PostCodeShortName] [varchar] (4) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TPostCode_PostCodeShortName] DEFAULT (' '),
[LatitudeX] [decimal] (18, 8) NOT NULL CONSTRAINT [DF_TPostCode_LatitudeX] DEFAULT ((0)),
[LongitudeY] [decimal] (18, 8) NOT NULL CONSTRAINT [DF_TPostCode_LongitudeY] DEFAULT ((0)),
[IsSystemAdded] [bit] NOT NULL CONSTRAINT [DF_TPostCode_IsSystemAdded] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCode_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPostCode] ADD CONSTRAINT [PK_TPostCode] PRIMARY KEY CLUSTERED  ([PostCodeId]) WITH (FILLFACTOR=80)
GO
