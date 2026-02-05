CREATE TABLE [dbo].[TRefOccupationBasis]
(
[RefOccupationBasisId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefOccupationBasisName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefOccupationBasis_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefOccupationBasis_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefOccupationBasis] ADD CONSTRAINT [PK_TRefOccupationBasis] PRIMARY KEY NONCLUSTERED  ([RefOccupationBasisId]) WITH (FILLFACTOR=80)
GO
