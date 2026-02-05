SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Artur Barysheuski
-- Create date: 28/08/2020
-- Description: Stored procedure for getting Plan created info by plan ids
-- =============================================
CREATE PROCEDURE [dbo].[nio_spGetPlanCreatedInfoByIds]
    @PolicyBusinessIds dbo.PolicyBusinessIdListType READONLY
AS
BEGIN
    ;WITH allHistory AS
    (
        SELECT 
            h.PolicyBusinessId AS PlanId
            , ChangedOn = h.DateOfChange
            , c.FirstName + ' ' + c.LastName AS ChangedByUserName
        FROM policymanagement..VStatusHistory h
        JOIN crm..TCRMContact c ON c.CRMContactId=h.ChangedByCRMContactId
        JOIN @PolicyBusinessIds pb ON pb.PolicyBusinessId = h.PolicyBusinessId
        UNION
        SELECT 
            h.PolicyBusinessId AS PlanId
            , ChangedOn = h.DateOfChange
            , c.FirstName + ' ' + c.LastName AS ChangedByUserName
        FROM policymanagement..VPlanActionHistory h
        JOIN crm..TCRMContact c ON c.CRMContactId=h.ChangedByCRMContactId
        JOIN @PolicyBusinessIds pb ON pb.PolicyBusinessId = h.PolicyBusinessId
    ),
    createdHistory AS
    (
        SELECT
            PlanId, MIN(ChangedOn) AS CreatedOn
        FROM allHistory
        GROUP BY PlanId
    )
    SELECT
        ch.PlanId AS PlanId
        , ah.ChangedByUserName AS CreatedByName
    FROM createdHistory ch
    JOIN allHistory ah ON ah.PlanId=ch.PlanId AND ah.ChangedOn=ch.CreatedOn
    GROUP BY ch.PlanId, ah.ChangedByUserName
END
GO