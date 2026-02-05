SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VRetainer]

AS

SELECT
	R.*,
	RO.CRMContactId AS ClientCRMContactId,
	P.CRMContactId AS AdviserCRMContactId,
	CU.CRMContactId AS TnCCoachCRMContactId,
	RS.RetainerStatusId,
	CS.[Status] AS CurrentStatus,
	CS.StatusDate AS StatusDate,
	RS.StatusDate AS ActiveDate
FROM
	PolicyManagement..TRetainer R
	JOIN PolicyManagement..TFeeRetainerOwner RO ON RO.RetainerId = R.RetainerId
	JOIN CRM..TPractitioner P ON P.PractitionerId = RO.PractitionerId
	LEFT JOIN Compliance..TTnCCoach C ON C.TnCCoachId = RO.TnCCoachId
	LEFT JOIN Administration..TUser CU ON CU.UserId = C.UserId
	LEFT JOIN
		(
			SELECT
				RetainerId,
				Max(RetainerStatusId) AS RetainerStatusId
			FROM
				PolicyManagement..TRetainerStatus
			WHERE
				[Status] = 'Active'
			GROUP BY
				RetainerId
		) TnCSubmit ON TnCSubmit.RetainerId = R.RetainerId
	LEFT JOIN PolicyManagement..TRetainerStatus RS ON RS.RetainerStatusId = TnCSubmit.RetainerStatusId
	LEFT JOIN
		(
			SELECT
				RetainerId,
				Max(RetainerStatusId) AS RetainerStatusId
			FROM
				PolicyManagement..TRetainerStatus
			GROUP BY
				RetainerId
		) CurrentStatus ON CurrentStatus.RetainerId = R.RetainerId
	LEFT JOIN PolicyManagement..TRetainerStatus CS ON CS.RetainerStatusId = CurrentStatus.RetainerStatusId
GO
