CREATE TABLE [dbo].[TRefPlanType2ProdSubTypeInsuranceCoverCategory]
(
[RefPlanType2ProdSubTypeId] [int] NULL,
[RefInsuranceCoverCategoryId] [int] NOT NULL
)
GO

ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeInsuranceCoverCategory] ADD CONSTRAINT [FK_TRefPlanType2ProdSubTypeInsuranceCoverCategory_RefPlanType2ProdSubType] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeInsuranceCoverCategory] ADD CONSTRAINT [FK_TRefPlanType2ProdSubTypeInsuranceCoverCategory_RefInsuranceCoverCategory] FOREIGN KEY ([RefInsuranceCoverCategoryId]) REFERENCES [dbo].[TRefInsuranceCoverCategory] ([RefInsuranceCoverCategoryId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TRefPlanType2ProdSubTypeInsuranceCoverCategory_RefPlanType2ProdSubTypeId_RefInsuranceCoverCategoryId] ON [dbo].[TRefPlanType2ProdSubTypeInsuranceCoverCategory] ([RefPlanType2ProdSubTypeId], [RefInsuranceCoverCategoryId]) WITH (FILLFACTOR=80)
GO