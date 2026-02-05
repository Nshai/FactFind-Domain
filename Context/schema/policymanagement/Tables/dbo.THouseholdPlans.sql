CREATE TABLE [dbo].[THouseholdPlan](
	HouseholdPlanId	INT IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	PolicyBusinessId	INT NOT NULL,
	HouseholdId			INT NOT NULL,
	HouseholdGroupId	INT NULL,
	CONSTRAINT [PK_THouseholdPlanId] PRIMARY KEY NONCLUSTERED 
	(
		HouseholdPlanId ASC
	)
) 
GO

ALTER TABLE [dbo].[THouseholdPlan]  WITH CHECK ADD  CONSTRAINT [FK_THouseholdPlan_TPolicyBusiness] FOREIGN KEY([PolicyBusinessId])
REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO

ALTER TABLE [dbo].[THouseholdPlan] CHECK CONSTRAINT [FK_THouseholdPlan_TPolicyBusiness]
GO

