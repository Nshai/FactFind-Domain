CREATE VIEW [dbo].[VModelPlan]

AS

SELECT	
    pb.PolicyBusinessId,
    pb.IndigoClientId,
    pb.PolicyNumber,
    pdd.RefProdProviderId,
    pbext.ModelId
FROM dbo.TPolicyBusiness AS pb 
    INNER JOIN TPolicyBusinessExt pbext on pbext.PolicyBusinessId = pb.PolicyBusinessId
    INNER JOIN TPolicyDetail pd on pd.PolicyDetailId = pb.PolicyDetailId
    INNER JOIN TPlanDescription pdd on pdd.PlanDescriptionId = pd.PlanDescriptionId
GO