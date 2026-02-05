CREATE TABLE [dbo].[TClientPlanType]
(
[ClientPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TClientPlanType] ADD CONSTRAINT [PK_TClientPlanType] PRIMARY KEY NONCLUSTERED  ([ClientPlanTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TClientPlanType_RefPlanTypeId] ON [dbo].[TClientPlanType] ([RefPlanTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TClientPlanType] ADD CONSTRAINT [FK_TClientPlanType_RefPlanTypeId_RefPlanTypeId] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
