SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kanstantsin Pavaliayeu
-- Create date: 19/05/2020
-- Description:	Get count of group scheme where party is a member
-- =============================================
CREATE PROCEDURE [dbo].[spCountGroupSchemeByClientIdQuery]
    @fromPartyId INT,
    @toPartyId INT
AS
BEGIN
    SELECT COUNT(member.GroupSchemeMemberId)
    FROM policymanagement..TGroupSchemeMember member
    INNER JOIN crm..TCRMContact c ON c.CRMContactId = member.CRMContactId
    INNER JOIN policymanagement..TGroupScheme scheme ON scheme.GroupSchemeId = member.GroupSchemeId
    WHERE member.CRMContactId = @fromPartyId
    AND member.IsLeaver = 0
    AND member.TenantId = c.IndClientId
    AND scheme.OwnerCRMContactId = @toPartyId
END
GO


