USE PolicyManagement;
GO

IF OBJECT_ID('dbo.SpCustomDashboardRetrieveGroupTop10Products') IS NOT NULL
    DROP PROCEDURE dbo.SpCustomDashboardRetrieveGroupTop10Products;
GO
/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20191211    Nick Fairway    IP-65541    Performance Improvement
*/
CREATE PROCEDURE dbo.SpCustomDashboardRetrieveGroupTop10Products
    @UserId     BIGINT
,   @GroupId    BIGINT = 0
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

    DECLARE @IndigoClientId    BIGINT;
    DECLARE @PlanTable TABLE
    (
        RefPlanTypeId    BIGINT
,       NumberOfPlans    BIGINT
    );
    DECLARE @TopTenPlansWithOthers TABLE
    (
        PlanTypeName     VARCHAR(255)
,       NumberOfPlans    BIGINT
,       RefPlanTypeId    INT
    );
    DECLARE @Work1 TABLE
    (
        RefPlanTypeId    INT
,       NumberOfPlans    INT
    );

    CREATE TABLE #Groups
    (
        GroupId    BIGINT
    );

    -- basic security check
    IF NOT EXISTS
    (
        SELECT 1
        FROM
             administration..TUser u
        JOIN administration..TGroup g
        ON
            g.IndigoClientId = u.IndigoClientId
        WHERE
        u.UserId = @UserId
        AND
            g.GroupId = @GroupId
    )
        RETURN; 
        
        SELECT
            @IndigoClientId = u.IndigoClientId
        FROM administration..TUser u
        WHERE
            u.UserId = @UserId;

    IF @GroupId > 0
    BEGIN
        INSERT INTO #Groups
        SELECT GroupId
        FROM administration..fnGetChildGroupsForGroup
        (@GroupId, 0);
    END;
    ELSE
    BEGIN
        INSERT INTO #Groups
        SELECT GroupId
        FROM administration..fnGetChildGroupsForGroup
        (0, @UserId);
    END;

    --CREATE INDEX idx_Grps_GrpId ON #Groups(GroupId);

    SELECT
        p.PractitionerId
      , A.RefPlanTypeId
    INTO
        #work0
    FROM
         #Groups G
    JOIN administration..TUser U
    ON  g.GroupId = u.GroupId
    JOIN crm..TPractitioner P
    ON  p.CRMContactId = u.CRMContactId
    AND
        u.IndigoClientId = @IndigoClientId
    JOIN dbo.TDashBoardPlanTypeDN A
    ON  a.IndigoClientId = @IndigoClientId
    AND
        A.PractitionerId = p.PractitionerId;

    INSERT INTO @Work1
    SELECT
        B.RefPlanTypeId
      , COUNT(1) AS NumberOfPlans
    FROM
         #work0 B
    JOIN policymanagement..TRefPlanType rpt
    ON
        b.RefPlanTypeId = rpt.RefPlanTypeId
    GROUP BY
        B.RefPlanTypeId
    ORDER BY
        2 DESC;

    INSERT INTO @TopTenPlansWithOthers
    SELECT TOP 10
        rpt.PlanTypeName
      , pt.NumberOfPlans
      , pt.RefPlanTypeId
    FROM
         @Work1 pt
    JOIN policymanagement..TRefPlanType rpt
        ON
        pt.RefPlanTypeId = rpt.RefPlanTypeId
    ORDER BY
        pt.NumberOfPlans DESC;

    IF (   
        SELECT
            COUNT(RefPlanTypeId)
        FROM @Work1
    ) > 10
    BEGIN

        INSERT INTO @TopTenPlansWithOthers
        (
            PlanTypeName
          , NumberOfPlans
        )
        SELECT
            'Others' AS PlanTypeName
          , SUM(NumberOfPlans)
        FROM  @Work1
        WHERE RefPlanTypeId NOT IN
        (
            SELECT RefPlanTypeId FROM @TopTenPlansWithOthers
        );
    END;

    SELECT
        PlanTypeName
      , NumberOfPlans
    FROM @TopTenPlansWithOthers;
END;

GO