SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VwCurrentStatus]
AS

	SELECT
		Pb.IndigoClientId,
		Sh.PolicyBusinessId,
		Sh.StatusHistoryId,		
		Sh.DateOfChange,
		Sh.ChangedToDate,
		S.IntelligentOfficeStatusType,
		S.[Name] AS StatusName,
		Sr.[Name] AS StatusReason
	FROM
		 policymanagement..TPolicyBusiness Pb WITH(NOLOCK)
		JOIN policymanagement..TStatusHistory Sh WITH(NOLOCK) ON Pb.PolicyBusinessId = Sh.PolicyBusinessId
		LEFT JOIN policymanagement..TStatusReason Sr WITH(NOLOCK) ON Sr.StatusReasonId = Sh.StatusReasonId
		JOIN policymanagement..TStatus S WITH(NOLOCK) ON S.StatusId = Sh.StatusId
	WHERE
		Sh.CurrentStatusFg = 1

GO
