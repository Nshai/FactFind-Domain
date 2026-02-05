CREATE TABLE [dbo].[TFactFindSearchPlanType]
(
[FactFindSearchPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[FactFindSearchId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindSearchPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFactFindSearchPlanType] ADD CONSTRAINT [PK_TFactFindSearchPlanType_FactFindSearchPlanTypeId] PRIMARY KEY NONCLUSTERED  ([FactFindSearchPlanTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TFactFindSearchPlanType] ADD CONSTRAINT [FK_TFactFindSearchPlanType_FactFindSearchId_FactFindSearchId] FOREIGN KEY ([FactFindSearchId]) REFERENCES [dbo].[TFactFindSearch] ([FactFindSearchId])
GO
