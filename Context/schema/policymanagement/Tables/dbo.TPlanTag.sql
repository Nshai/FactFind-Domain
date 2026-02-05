CREATE TABLE [dbo].[TPlanTag]
(
   [PlanTagId] [int] NOT NULL IDENTITY(1, 1),
   [TenantId] [int] NOT NULL,
   [PolicyBusinessId] [int] NOT NULL,
   [Name] [nvarchar](100) NOT NULL, 
   CONSTRAINT [PK_TPlanTag] PRIMARY KEY CLUSTERED ( [PlanTagId] ASC)
)
GO

ALTER TABLE [dbo].[TPlanTag]  WITH CHECK ADD  CONSTRAINT [FK_TPlanTag_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId])
REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO

ALTER TABLE [dbo].[TPlanTag] CHECK CONSTRAINT [FK_TPlanTag_TPolicyBusiness]
GO

CREATE NONCLUSTERED INDEX [IX_TPlanTag_TenantId] ON [dbo].[TPlanTag]
( 
   [TenantId] ASC
)
GO