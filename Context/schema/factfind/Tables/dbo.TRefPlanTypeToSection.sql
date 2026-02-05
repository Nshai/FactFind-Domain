CREATE TABLE [dbo].[TRefPlanTypeToSection]
(
[RefPlanTypeToSectionId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[Section] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanTypeToSection_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPlanTypeToSection] ADD CONSTRAINT [PK_TRefPlanTypeToSection] PRIMARY KEY NONCLUSTERED  ([RefPlanTypeToSectionId])
GO
