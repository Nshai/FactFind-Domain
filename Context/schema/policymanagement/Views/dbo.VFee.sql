SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VFee]

AS

SELECT
	F.*,
	FO.CRMContactId AS ClientCRMContactId,
	P.CRMContactId AS AdviserCRMContactId,
	CU.CRMContactId AS TnCCoachCRMContactId,
	CS.[Status] AS CurrentStatus,
	CS.StatusDate AS StatusDate,
	SS.StatusDate AS DueDate
FROM
	PolicyManagement..TFee F
	JOIN PolicyManagement..TFeeRetainerOwner FO ON FO.FeeId = F.FeeId
	JOIN CRM..TPractitioner P ON P.PractitionerId = FO.PractitionerId
	LEFT JOIN Compliance..TTnCCoach C ON C.TnCCoachId = FO.TnCCoachId
	LEFT JOIN Administration..TUser CU ON CU.UserId = C.UserId
	LEFT JOIN
		(
			SELECT
				FeeId,
				Max(FeeStatusId) AS FeeStatusId
			FROM
				PolicyManagement..TFeeStatus
			WHERE
				[Status] = 'Due'
			GROUP BY
				FeeId
		) TnCSubmit ON TnCSubmit.FeeId = F.FeeId
	LEFT JOIN PolicyManagement..TFeeStatus SS ON SS.FeeStatusId = TnCSubmit.FeeStatusId
	LEFT JOIN
		(
			SELECT
				FeeId,
				Max(FeeStatusId) AS FeeStatusId
			FROM
				PolicyManagement..TFeeStatus
			GROUP BY
				FeeId
		) CurrentStatus ON CurrentStatus.FeeId = F.FeeId
	LEFT JOIN PolicyManagement..TFeeStatus CS ON CS.FeeStatusId = CurrentStatus.FeeStatusId
GO
