USE [policymanagement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetLifeCycleIdByAdviceTypeId]
    @AdviceTypeId INT,
    @TenantId INT
AS   
    SELECT TOP 1 
    	T.LifeCycleId
    FROM [policymanagement]..TLifeCycle2RefPlanType T
    INNER JOIN [policymanagement]..TLifeCycle L ON T.LifeCycleId = L.LifeCycleId
    WHERE AdviceTypeId = @AdviceTypeId AND L.IndigoClientId = @TenantId
