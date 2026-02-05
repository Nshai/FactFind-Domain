CREATE TABLE [dbo].[TDependant]
(
[DependantId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (32)  NOT NULL,
[DoB] [datetime] NOT NULL,
[IndependenceAge] [int] NULL,
[CrmContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDependant_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDependant] ADD CONSTRAINT [PK_TDependant_DependantId] PRIMARY KEY CLUSTERED  ([DependantId])
GO
ALTER TABLE [dbo].[TDependant] WITH CHECK ADD CONSTRAINT [FK_TDependant_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
