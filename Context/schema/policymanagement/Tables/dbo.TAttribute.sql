CREATE TABLE [dbo].[TAttribute]
(
[AttributeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Value] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrribute_ConcurrencyId_1__51] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAttribute] ADD CONSTRAINT [PK_TAtrribute_2__51] PRIMARY KEY NONCLUSTERED  ([AttributeId]) WITH (FILLFACTOR=80)
GO
