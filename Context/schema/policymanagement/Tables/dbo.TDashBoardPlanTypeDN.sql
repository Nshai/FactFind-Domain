CREATE TABLE [dbo].[TDashBoardPlanTypeDN](
	[PractitionerId] [int] NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[RefPlanType2ProdSubTypeId] [int] NOT NULL,
	[RefPlanTypeId] [int] NOT NULL,
	[PolicyBusinessId] [int] NOT NULL,
	[PolicyDetailId] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_TDashBoardPlanTypeDN_IndigoClientId ON [dbo].[TDashBoardPlanTypeDN] ([IndigoClientId]) INCLUDE ([PractitionerId],[RefPlanTypeId])
go