CREATE TABLE [dbo].[TBuildingandContents]
(
[BuildingandContentsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[renewbuildingscover] [bit] NULL,
[renewcontentscover] [bit] NULL,
[approvedlocks] [bit] NULL,
[burglaralarm] [bit] NULL,
[haveclaimed] [bit] NULL,
[SelectAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Numberofbedrooms] [decimal] (10, 2) NULL,
[Yearbuilt] [decimal] (10, 2) NULL,
[Amountofcover] [decimal] (10, 2) NULL,
[Amountofexcess] [decimal] (10, 2) NULL,
[accidentalcover] [bit] NULL,
[existingcover] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBuildingandContents_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBuildingandContents] ADD CONSTRAINT [PK_TBuildingandContents] PRIMARY KEY NONCLUSTERED  ([BuildingandContentsId]) WITH (FILLFACTOR=80)
GO
